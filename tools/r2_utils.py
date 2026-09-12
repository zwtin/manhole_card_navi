#!/usr/bin/env python3
"""Cloudflare R2（画像配信）への接続設定とキー計算。

deploy_images.py / delete_images_from_r2.py / build_master.py が共有する。

背景:
  画像は Cloud Storage → Firebase Hosting → Cloudflare R2 と移してきた。
  R2 は egress 無料なので、配信量が増えても取得課金が発生しない。
  master の cards は配信 URL をフルで持つ（image_url）。アプリはそれをそのまま使う
  （旧アプリのようにベース URL をアプリ側で組み立てない）。

オブジェクトキー（バケット内のパス）:
  master/v{version}/images/{id}.jpg   … 計算は image_layout.py が持つ（Hosting と共通）
  配信 URL       : {PUBLIC_BASE_URL}/master/v{version}/images/{id}.jpg
  master バージョンをパスに含めるので、バージョンを上げると URL が変わる。
  端末側の CachedNetworkImage のキャッシュが自然に切り替わる（Hosting 運用と同じ狙い）。

  同じパスで Firebase Hosting にも同じ画像を置く（代替配信元 = cards.image_sub_url）。
  接続設定は hosting_utils.py、パス計算は image_layout.py に分けてある。

dev / prod:
  Firebase と同様にバケットを分ける。dev の操作ミスが prod に波及しない。
  バケット名と配信ベース URL は機密ではないので下の定数に持つ（環境変数 / CLI で上書き可）。

機密情報（このファイルにもリポジトリにも置かない・実行時に環境変数から読む）:
  R2_ACCOUNT_ID         Cloudflare のアカウントID（S3 互換エンドポイントに使う）
  R2_ACCESS_KEY_ID      R2 API トークンのアクセスキーID
  R2_SECRET_ACCESS_KEY  R2 API トークンのシークレットアクセスキー
  （R2_ENDPOINT_URL を直接指定してもよい。指定時は R2_ACCOUNT_ID より優先）

依存:
  boto3（S3 互換 API クライアント）。未導入なら `pip3 install --user boto3`。
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

# 画像のパス計算と共通定数は配信先に依存しないので image_layout に置いてある。
# 既存の呼び出し元（deploy/delete/build/migrate）が r2_utils.image_key 等をそのまま
# 使えるよう、ここで再エクスポートする。
from image_layout import (  # noqa: E402,F401
    CONTENT_TYPE,
    DEFAULT_CACHE_CONTROL,
    id_from_key,
    image_key,
    image_prefix,
    image_url,
)

# ---- dev / prod ごとのバケットと配信ベース URL ----
# 機密ではない。ここを正にして、必要なら環境変数 / CLI 引数で上書きする。
BUCKETS = {
    "prod": "manholecardnavi",
    "dev": "manholecardnavidev",
}
PUBLIC_BASE_URLS = {
    # R2 バケットに接続したカスタムドメイン。末尾スラッシュは付けない
    # （付いていても base_url_of() が落とす）。
    "prod": "https://cdn.manholecardnavi.com",
    "dev": "https://cdn-dev.manholecardnavi.com",
}

PROJECTS = tuple(BUCKETS)



def bucket_of(project, override=None):
    """project（dev / prod）のバケット名。--bucket / 環境変数で上書き可。"""
    if override:
        return override
    env = os.environ.get(f"R2_BUCKET_{project.upper()}")
    if env:
        return env
    name = BUCKETS.get(project)
    if not name:
        sys.exit(f"バケット名が未設定です（project={project}）。"
                 f"tools/r2_utils.py の BUCKETS か環境変数 R2_BUCKET_{project.upper()} を設定してください。")
    return name


def base_url_of(project, override=None):
    """project（dev / prod）の配信ベース URL。--base-url / 環境変数で上書き可。"""
    url = override or os.environ.get(f"R2_BASE_URL_{project.upper()}") or PUBLIC_BASE_URLS.get(project)
    if not url:
        sys.exit(f"配信ベース URL が未設定です（project={project}）。"
                 f"tools/r2_utils.py の PUBLIC_BASE_URLS か環境変数 "
                 f"R2_BASE_URL_{project.upper()} を設定してください。")
    return url.rstrip("/")






def endpoint_url():
    """S3 互換エンドポイント。R2_ENDPOINT_URL 優先、無ければアカウントIDから組む。"""
    direct = os.environ.get("R2_ENDPOINT_URL")
    if direct:
        return direct.rstrip("/")
    account = os.environ.get("R2_ACCOUNT_ID")
    if not account:
        return None
    return f"https://{account}.r2.cloudflarestorage.com"


def client():
    """R2 の S3 互換クライアントを返す。認証情報は環境変数から読む。"""
    try:
        # boto3 は Python 3.9 サポート終了の警告を毎回出す。ログが読みにくくなるので黙らせる
        # （実行環境の python3 は 3.9 系。動作自体に問題は無い）。
        import warnings
        warnings.filterwarnings("ignore", category=DeprecationWarning)
        warnings.filterwarnings("ignore", message=".*Python 3.9.*")
        import boto3
        from botocore.config import Config
    except ImportError:
        sys.exit("boto3 が見つかりません。`pip3 install --user boto3` を実行してください。")

    ep = endpoint_url()
    key_id = os.environ.get("R2_ACCESS_KEY_ID")
    secret = os.environ.get("R2_SECRET_ACCESS_KEY")
    missing = []
    if not ep:
        missing.append("R2_ACCOUNT_ID（または R2_ENDPOINT_URL）")
    if not key_id:
        missing.append("R2_ACCESS_KEY_ID")
    if not secret:
        missing.append("R2_SECRET_ACCESS_KEY")
    if missing:
        sys.exit("R2 の認証情報が環境変数にありません: " + " / ".join(missing) +
                 "\n  Cloudflare ダッシュボード > R2 > API トークンで発行し、シェルに export してください。")

    kwargs = dict(
        region_name="auto",                       # R2 は region の概念が無いので auto 固定
        signature_version="s3v4",
        s3={"addressing_style": "path"},          # {endpoint}/{bucket}/{key} 形式で叩く
        retries={"max_attempts": 5, "mode": "standard"},
    )
    # botocore 1.36 以降は既定で追加チェックサム（CRC32）を付ける。R2 では
    # 付けない方が無難なので必要時のみに落とす（古い botocore では引数が無いので無視）。
    try:
        cfg = Config(request_checksum_calculation="when_required",
                     response_checksum_validation="when_required", **kwargs)
    except TypeError:
        cfg = Config(**kwargs)

    return boto3.client(
        "s3",
        endpoint_url=ep,
        aws_access_key_id=key_id,
        aws_secret_access_key=secret,
        config=cfg,
    )


def list_keys(s3, bucket, prefix):
    """prefix 配下の全オブジェクトキーを返す（ページング対応）。"""
    keys = []
    token = None
    while True:
        kw = {"Bucket": bucket, "Prefix": prefix, "MaxKeys": 1000}
        if token:
            kw["ContinuationToken"] = token
        resp = s3.list_objects_v2(**kw)
        for obj in resp.get("Contents", []):
            keys.append(obj["Key"])
        if not resp.get("IsTruncated"):
            break
        token = resp.get("NextContinuationToken")
        if not token:
            break
    return keys
