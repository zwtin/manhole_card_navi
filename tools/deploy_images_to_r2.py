#!/usr/bin/env python3
"""カード原本画像を gk-p.jp からダウンロードし、Cloudflare R2 の
master/v{version}/images/{id}.jpg へアップロードする。

背景:
  画像は Cloud Storage → Firebase Hosting → Cloudflare R2 と移してきた。
  R2 は egress 無料なので配信量が増えても取得課金が発生しない。
  master の cards は R2 の配信 URL をフルで持つ（image_url）。アプリはそれをそのまま使う。
  （旧アプリは master の image パスに自前でベース URL を付けていたが、その方式は廃止した）

画像ソース:
  gk-p.jp（各カードの image_url）から直接ダウンロードする。
  cards_base.json（parse_cards.py の出力）の各カードが image_url を持つ。
  ※ この image_url は「gk-p.jp 上のソース画像 URL」。master の image_url（R2 配信 URL）とは別物。

オブジェクト名（id）:
  カード画像に印字された正規化ID（例 00-101-A001）。cards_base.json の ocr_id を使う。
  これは ocr_cards.py が画像の二重OCRで確定した値。
  ocr_id が無いカードはスキップして警告する（IDが確定していない＝配置できない）。
  ※ 画像URLから機械生成した推定IDや人力付与のIDは不正確なので使わない。

アップロード先:
  s3://{bucket}/master/v{version}/images/{id}.jpg   （bucket は dev / prod で分ける）
  配信 URL: {base_url}/master/v{version}/images/{id}.jpg

バージョン運用:
  master バージョンを上げるたびに、新しい master/v{version}/ 配下へ全画像を置く。
  旧バージョンの画像は全端末が新バージョンへ移行しきるまで残す
  （後片付けは delete_images_from_r2.py）。

認証:
  R2 の認証情報は環境変数から読む（r2_utils.py 参照）。
    R2_ACCOUNT_ID / R2_ACCESS_KEY_ID / R2_SECRET_ACCESS_KEY

使い方:
  # 対象・件数の確認のみ（DLもアップロードもしない）。R2 の既存オブジェクトとの差分も出す
  python3 tools/deploy_images_to_r2.py --version 0005 --project dev --dry-run

  # gk-p.jp から取得して R2 にアップロード（既にあるものはスキップ）
  python3 tools/deploy_images_to_r2.py --version 0005 --project dev

  # 疎通確認: 先頭3件だけ流す
  python3 tools/deploy_images_to_r2.py --version 0005 --project dev --limit 3

  # 既存オブジェクトも再取得して上書きする
  python3 tools/deploy_images_to_r2.py --version 0005 --project prod --overwrite
"""
import argparse
import io
import json
import os
import sys
import time
import urllib.error
import urllib.request
from collections import Counter

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import r2_utils  # noqa: E402

DATA = os.path.join(HERE, "data")
CARDS_PATH = os.path.join(DATA, "cards_base.json")

# gk-p.jp は https + Referer が無いと 403 を返す（download_images.py と同じ作法）。
REFERER = "https://www.gk-p.jp/mhcard/"
USER_AGENT = ("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
              "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36")


def card_image_id(card):
    """配置ファイル名に使う確定ID（ocr_cards.py が確定した ocr_id）。無ければ None。"""
    return card.get("ocr_id") or None


def download_one(url):
    """(ok, data or None, error)"""
    req = urllib.request.Request(url, headers={
        "User-Agent": USER_AGENT,
        "Referer": REFERER,
        "Accept": "image/avif,image/webp,image/apng,image/*,*/*;q=0.8",
    })
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return True, resp.read(), ""
    except urllib.error.HTTPError as e:
        return False, None, f"HTTP {e.code}"
    except urllib.error.URLError as e:
        return False, None, f"URLError {e.reason}"
    except Exception as e:  # noqa
        return False, None, f"{type(e).__name__}: {e}"


def to_jpeg(data):
    """(jpeg_bytes, converted)

    gk-p.jp には拡張子が .png のカードがある（柏市 12-217-A001 など）。
    R2 には Content-Type: image/jpeg で置くので、中身が JPEG でないものは
    JPEG に変換してからアップロードする。
    """
    if data[:3] == b"\xff\xd8\xff":       # JPEG (SOI)
        return data, False
    img = Image.open(io.BytesIO(data))
    if img.mode != "RGB":
        img = img.convert("RGB")
    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=95)
    return buf.getvalue(), True


def head_public_url(url):
    """配信 URL を叩いて (status, content_type) を返す。失敗時は (None, 説明)。"""
    req = urllib.request.Request(url, method="HEAD", headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.status, resp.headers.get("Content-Type", "")
    except urllib.error.HTTPError as e:
        return e.code, e.headers.get("Content-Type", "") if e.headers else ""
    except Exception as e:  # noqa
        return None, f"{type(e).__name__}: {e}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True,
                    help="master バージョン（例 0005）。アップロード先 master/v{version}/images/")
    ap.add_argument("--project", required=True, choices=list(r2_utils.PROJECTS),
                    help="アップロード先（prod / dev）。バケットと配信 URL が切り替わる")
    ap.add_argument("--cards", default=CARDS_PATH,
                    help="カードJSON（既定 tools/data/cards_base.json）")
    ap.add_argument("--bucket", default=None, help="バケット名を明示指定（既定は project から解決）")
    ap.add_argument("--base-url", default=None, help="配信ベース URL を明示指定（検証表示用）")
    ap.add_argument("--dry-run", action="store_true",
                    help="DL もアップロードもせず、対象件数と R2 の既存差分のみ表示")
    ap.add_argument("--limit", type=int, default=0,
                    help="先頭 N 件だけ処理する（疎通確認用。0 で全件）")
    ap.add_argument("--sleep", type=float, default=0.15,
                    help="ダウンロード間の待機秒（gk-p.jp の負荷軽減）")
    ap.add_argument("--overwrite", action="store_true",
                    help="R2 に既にオブジェクトがあっても再ダウンロードして上書き")
    ap.add_argument("--cache-control", default=r2_utils.DEFAULT_CACHE_CONTROL,
                    help="オブジェクトに付ける Cache-Control")
    args = ap.parse_args()

    bucket = r2_utils.bucket_of(args.project, args.bucket)
    base_url = r2_utils.base_url_of(args.project, args.base_url)
    prefix = r2_utils.image_prefix(args.version)

    if not os.path.exists(args.cards):
        sys.exit(f"カードJSON が見つかりません: {args.cards}")

    cards = json.load(open(args.cards, encoding="utf-8"))

    # アップロード対象を組み立てる。ID が確定していないカードは除外。
    targets = []      # (id, source_url)
    no_id = []        # ID未確定
    no_url = []       # ソース image_url なし
    for c in cards:
        cid = card_image_id(c)
        url = c.get("image_url", "")
        if not cid:
            no_id.append(c.get("card_id"))
            continue
        if not url:
            no_url.append(c.get("card_id"))
            continue
        targets.append((cid, url))

    print(f"プロジェクト   : {args.project}")
    print(f"バケット       : {bucket}")
    print(f"キー接頭辞     : {prefix}")
    print(f"配信ベース URL : {base_url}")
    print(f"カードJSON総数 : {len(cards)}")
    print(f"アップロード対象: {len(targets)}")
    if no_id:
        print(f"  ⚠️ ocr_id が無くスキップ: {len(no_id)}（ocr_cards.py を実行してください）")
    if no_url:
        print(f"  ⚠️ ソース image_url なしでスキップ: {len(no_url)}")

    # ID の重複チェック（別カードが同じIDに落ちると上書きされる）
    dup = {k: n for k, n in Counter(cid for cid, _ in targets).items() if n > 1}
    if dup:
        print(f"  ⚠️ アップロードID重複: {len(dup)} 種（後勝ちで上書きされる）")
        for k in list(dup)[:5]:
            print(f"     {k} ×{dup[k]}")

    if args.limit:
        targets = targets[:args.limit]
        print(f"  --limit {args.limit}: 先頭 {len(targets)} 件のみ処理します")

    # R2 の既存オブジェクトを1回の一覧で取る（存在チェック・過不足確認に使う）
    s3 = r2_utils.client()
    try:
        existing = set(r2_utils.list_keys(s3, bucket, prefix))
    except Exception as e:  # noqa
        sys.exit(f"R2 の一覧取得に失敗しました（bucket={bucket}）: {type(e).__name__}: {e}\n"
                 "  バケット名・アカウントID・APIトークンの権限を確認してください。")
    print(f"R2 の既存      : {len(existing)} オブジェクト（{prefix}）")

    required = {r2_utils.image_key(args.version, cid) for cid, _ in targets}
    missing = required - existing
    extra = existing - required
    print(f"  未アップロード: {len(missing)} / 余剰（対象外のオブジェクト）: {len(extra)}")
    if extra and not args.limit:
        for k in sorted(extra)[:5]:
            print(f"     余剰: {k}")
        print("     ※ 旧IDの残骸の可能性がある。master の要求と一致させるなら削除を検討する")

    if args.dry_run:
        print("\n（--dry-run のため取得・アップロードしません）")
        if targets:
            cid, src = targets[0]
            print(f"  例: {r2_utils.image_key(args.version, cid)} <- {src}")
            print(f"      {r2_utils.image_url(base_url, args.version, cid)}")
        return

    n_ok = n_skip = n_fail = n_conv = 0
    uploaded_ids = []
    for i, (cid, url) in enumerate(targets, start=1):
        key = r2_utils.image_key(args.version, cid)
        if not args.overwrite and key in existing:
            n_skip += 1
            continue
        ok, data, err = download_one(url)
        if not ok or not data:
            n_fail += 1
            print(f"  [失敗] {cid} <- {url}: {err}")
            time.sleep(args.sleep)
            continue
        try:
            data, converted = to_jpeg(data)
        except Exception as e:  # noqa
            n_fail += 1
            print(f"  [失敗] {cid}: JPEG 変換に失敗 ({type(e).__name__}: {e})")
            time.sleep(args.sleep)
            continue
        if converted:
            n_conv += 1
            print(f"  [変換] {cid}: 非JPEG画像を JPEG に変換してアップロード <- {url}")
        try:
            s3.put_object(Bucket=bucket, Key=key, Body=data,
                          ContentType=r2_utils.CONTENT_TYPE,
                          CacheControl=args.cache_control)
        except Exception as e:  # noqa
            n_fail += 1
            print(f"  [失敗] {cid}: R2 アップロード失敗 ({type(e).__name__}: {e})")
            time.sleep(args.sleep)
            continue
        n_ok += 1
        uploaded_ids.append(cid)
        if i % 50 == 0:
            print(f"  ... {i}/{len(targets)} (ok={n_ok} skip={n_skip} fail={n_fail})")
        time.sleep(args.sleep)

    print(f"\nアップロード完了: 新規 {n_ok}（うち JPEG 変換 {n_conv}） / "
          f"スキップ(既存) {n_skip} / 失敗 {n_fail}")
    print(f"  -> s3://{bucket}/{prefix}")
    if n_fail:
        print("  ⚠️ 失敗があります。master 投入前に原因を確認してください。")

    # 過不足の再確認（アップロード後に一覧を取り直す）
    after = set(r2_utils.list_keys(s3, bucket, prefix))
    still_missing = required - after
    print(f"\n検証: R2 の {prefix} に {len(after)} オブジェクト"
          f"（今回の対象 {len(required)}）")
    if still_missing:
        print(f"  ⚠️ 未アップロードが {len(still_missing)} 件残っています:")
        for k in sorted(still_missing)[:10]:
            print(f"     {k}")
    else:
        print("  ✅ 今回の対象はすべて R2 に存在します")
    if args.limit:
        print("  ※ --limit 指定のため、master 全件との過不足は確認していません")

    # 配信 URL の実地確認（1件）
    check_id = uploaded_ids[0] if uploaded_ids else (targets[0][0] if targets else None)
    if check_id:
        url = r2_utils.image_url(base_url, args.version, check_id)
        status, ctype = head_public_url(url)
        print(f"\n配信確認: {url}")
        print(f"  -> {status} {ctype}")
        if status != 200:
            print("  ⚠️ 200 になりません。バケットの公開設定（カスタムドメイン接続）を確認してください。")
        elif "image/jpeg" not in (ctype or ""):
            print("  ⚠️ Content-Type が image/jpeg ではありません。")


if __name__ == "__main__":
    main()
