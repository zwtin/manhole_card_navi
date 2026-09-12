#!/usr/bin/env python3
"""Firebase Hosting（画像の代替配信元）への配置設定。

deploy_images.py / delete_images_from_hosting.py / build_master.py が共有する。

位置づけ:
  画像の**主系は Cloudflare R2**（egress 無料）。Hosting は**代替配信元**で、
  master の cards が持つ image_sub_url がこれを指す。
  アプリは image_url（R2）の取得に失敗したときだけ image_sub_url へフォールバックする
  （lib/app/service/image_fallback.dart）。

なぜ代替が要るのか:
  2026-07-27 に画像配信を Hosting から R2 へ移したところ「画像が表示されない」問い合わせが来た。
  配信ドメイン cdn.manholecardnavi.com が経路上のフィルタリング装置に遮断される端末がある
  （Crashlytics に HandshakeException: WRONG_VERSION_NUMBER。SNI を見て平文を返す装置が
  割り込んでいる）。発生は cdn を使う世代に 100% 偏り、影響は該当世代の約 0.6%。
  *.web.app は Google のドメインでフィルタ製品の許可リストに入っているため、
  代替経路として機能する。

  ※ Hosting を踏むのは遮断されているごく一部のユーザーだけなので、
    R2 に移した意味（egress 無料）は保たれる。Hosting の転送量は Spark で 10GB/月まで無料、
    Blaze でも $0.15/GB。全画像で約 190MB なので、フォールバック利用なら無視できる。

配置パス（R2 と完全に同一。計算は image_layout.py）:
  public/master/v{version}/images/{id}.jpg
  配信 URL: {PUBLIC_BASE_URL}/master/v{version}/images/{id}.jpg

デプロイ方式:
  画像はこのリポジトリではなく、別に切ってある Firebase プロジェクトのローカルディレクトリ
  （LOCAL_DIRS）の public/ 配下に置き、そこで firebase deploy --only hosting を実行する。
  Cache-Control は各プロジェクトの firebase.json の headers で設定済み
  （source: "/master/**/images/**" に public, max-age=31536000, immutable）。

認証:
  firebase CLI（`firebase login` 済みであること）。
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

from image_layout import image_key, image_prefix, image_url  # noqa: E402,F401

# ---- dev / prod ごとの配信ベース URL とローカルディレクトリ ----
# 機密ではない。ここを正にして、必要なら環境変数 / CLI 引数で上書きする。
PUBLIC_BASE_URLS = {
    # Firebase が発行する既定ドメイン。末尾スラッシュは付けない
    # （付いていても base_url_of() が落とす）。
    # *.web.app であること自体に意味がある（フィルタ製品の許可リストに入っている）ので、
    # 独自ドメインに差し替えないこと。代替配信元の役目を果たさなくなる。
    "prod": "https://manhole-card-navi.web.app",
    "dev": "https://manhole-card-navi-dev.web.app",
}

# 画像を置いてデプロイする Firebase プロジェクトのローカルディレクトリ。
LOCAL_DIRS = {
    "prod": "~/Documents/github/firebase/manhole_card_navi",
    "dev": "~/Documents/github/firebase/manhole_card_navi_dev",
}

PROJECTS = tuple(PUBLIC_BASE_URLS)


def base_url_of(project, override=None):
    """project（dev / prod）の配信ベース URL。--hosting-base-url / 環境変数で上書き可。"""
    url = (override
           or os.environ.get(f"HOSTING_BASE_URL_{project.upper()}")
           or PUBLIC_BASE_URLS.get(project))
    if not url:
        sys.exit(f"Hosting の配信ベース URL が未設定です（project={project}）。"
                 f"tools/hosting_utils.py の PUBLIC_BASE_URLS か環境変数 "
                 f"HOSTING_BASE_URL_{project.upper()} を設定してください。")
    return url.rstrip("/")


def local_dir_of(project, override=None):
    """project（dev / prod）の Firebase プロジェクトのローカルディレクトリ。"""
    path = (override
            or os.environ.get(f"HOSTING_DIR_{project.upper()}")
            or LOCAL_DIRS.get(project))
    if not path:
        sys.exit(f"Hosting のローカルディレクトリが未設定です（project={project}）。"
                 f"tools/hosting_utils.py の LOCAL_DIRS か環境変数 "
                 f"HOSTING_DIR_{project.upper()} を設定してください。")
    return os.path.expanduser(path)


def image_dir(local_dir, version):
    """画像を配置するローカルディレクトリ（public/master/v{version}/images）。"""
    return os.path.join(local_dir, "public", image_prefix(version).rstrip("/"))


def image_path(local_dir, version, image_id):
    """画像1件の配置先ローカルパス。"""
    return os.path.join(local_dir, "public", image_key(version, image_id))


def existing_ids(local_dir, version):
    """既に配置済みの画像IDの集合（中身が空のファイルは未配置とみなす）。"""
    d = image_dir(local_dir, version)
    if not os.path.isdir(d):
        return set()
    ids = set()
    for name in os.listdir(d):
        if not name.endswith(".jpg"):
            continue
        if os.path.getsize(os.path.join(d, name)) <= 0:
            continue
        ids.add(name[:-len(".jpg")])
    return ids
