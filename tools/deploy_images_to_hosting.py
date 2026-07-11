#!/usr/bin/env python3
"""
カード原本画像を gk-p.jp からダウンロードし、Firebase Hosting の
master/v{version}/images/ 配下へ {id}.jpg で配置してデプロイする。

背景:
  従来は画像を Cloud Storage に置き、master に GCS の絶対 URL を保存していた。
  そのため画像取得のたびに GCS egress 課金が発生していた。
  これを Firebase Hosting（Fastly CDN・10GB/月まで無料）配信へ移行する。
  master には配信 URL ではなくパス（master/v{version}/images/{id}.jpg）のみを持たせ、
  ベース URL（https://{projectId}.web.app）はアプリ側で付与する。

画像ソース:
  gk-p.jp（各カードの image_url）から直接ダウンロードする。
  cards_base.json（parse_cards.py の出力）の各カードが image_url を持つ。

配置ファイル名（id）:
  カード画像に印字された正規化ID（例 00-101-A001）。cards_base.json の ocr_id を使う。
  これは ocr_cards.py が画像の二重OCRで確定した値。
  ocr_id が無いカードはスキップして警告する（IDが確定していない＝配置できない）。
  ※ 画像URLから機械生成した推定IDや人力付与のIDは不正確なので使わない。

配置先:
  {hosting_dir}/public/master/v{version}/images/{id}.jpg

バージョン運用:
  master バージョンを上げるたびに、新しい v{version} ディレクトリへ全画像を配置する。
  旧バージョンの画像は全端末が新バージョンへ移行しきるまで残す
  （後片付けは delete_images_from_hosting.py）。

認証:
  デプロイに firebase CLI（firebase login 済みであること）を使う。

使い方:
  # 対象・件数の確認のみ（DLもコピーもしない）
  python3 tools/deploy_images_to_hosting.py --version 0004 --project prod --dry-run

  # gk-p.jp から取得して public/master/v0004/images/ に配置（デプロイはしない）
  python3 tools/deploy_images_to_hosting.py --version 0004 --project prod

  # 配置してそのままデプロイまで実行
  python3 tools/deploy_images_to_hosting.py --version 0004 --project prod --deploy
"""
import argparse
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "data")
CARDS_PATH = os.path.join(DATA, "cards_base.json")

# Firebase プロジェクトのローカルディレクトリ。
PROJECTS = {
    "prod": os.path.expanduser("~/Documents/github/firebase/manhole_card_navi"),
    "dev": os.path.expanduser("~/Documents/github/firebase/manhole_card_navi_dev"),
}

# gk-p.jp は https + Referer が無いと 403 を返す（download_images.py と同じ作法）。
REFERER = "https://www.gk-p.jp/mhcard/"
USER_AGENT = ("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
              "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36")


def run(cmd, cwd=None):
    print("  $", " ".join(cmd))
    result = subprocess.run(cmd, cwd=cwd)
    if result.returncode != 0:
        sys.exit(f"コマンド失敗（exit {result.returncode}）: {' '.join(cmd)}")


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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True,
                    help="master バージョン（例 0004）。配置先 master/v{version}/images/")
    ap.add_argument("--project", required=True, choices=list(PROJECTS),
                    help="配置先プロジェクト（prod / dev）")
    ap.add_argument("--deploy", action="store_true",
                    help="配置後に firebase deploy --only hosting を実行する")
    ap.add_argument("--dry-run", action="store_true",
                    help="DL もコピーもせず、対象件数のみ表示")
    ap.add_argument("--sleep", type=float, default=0.15,
                    help="ダウンロード間の待機秒（サーバ負荷軽減）")
    ap.add_argument("--overwrite", action="store_true",
                    help="配置先に既に画像があっても再ダウンロードして上書き")
    args = ap.parse_args()

    hosting_dir = PROJECTS[args.project]
    dest_dir = os.path.join(
        hosting_dir, "public", "master", f"v{args.version}", "images")

    if not os.path.isdir(hosting_dir):
        sys.exit(f"Firebase プロジェクトディレクトリが見つかりません: {hosting_dir}")
    if not os.path.exists(CARDS_PATH):
        sys.exit(f"cards_base.json が見つかりません: {CARDS_PATH}")

    cards = json.load(open(CARDS_PATH, encoding="utf-8"))

    # 配置対象を組み立てる。ID が確定していないカードは除外。
    targets = []      # (id, image_url)
    no_id = []        # ID未確定
    no_url = []       # image_url なし
    for c in cards:
        cid = card_image_id(c)
        url = c.get("image_url", "")
        if not cid:
            no_id.append(c["card_id"])
            continue
        if not url:
            no_url.append(c["card_id"])
            continue
        targets.append((cid, url))

    print(f"プロジェクト   : {args.project} ({hosting_dir})")
    print(f"配置先         : {dest_dir}")
    print(f"cards_base 総数: {len(cards)}")
    print(f"配置対象       : {len(targets)}")
    if no_id:
        print(f"  ⚠️ ocr_id が無くスキップ: {len(no_id)}（ocr_cards.py を実行してください）")
    if no_url:
        print(f"  ⚠️ image_url なしでスキップ: {len(no_url)}")

    # ID の重複チェック（別カードが同じIDに落ちると上書きされる）
    from collections import Counter
    dup = {k: n for k, n in Counter(cid for cid, _ in targets).items() if n > 1}
    if dup:
        print(f"  ⚠️ 配置ID重複: {len(dup)} 種（後勝ちで上書きされる）")
        for k in list(dup)[:5]:
            print(f"     {k} ×{dup[k]}")

    if args.dry_run:
        print("\n（--dry-run のため取得・配置しません）")
        if targets:
            print("  例:", targets[0][0], "<-", targets[0][1])
        return

    os.makedirs(dest_dir, exist_ok=True)
    n_ok = n_skip = n_fail = 0
    for i, (cid, url) in enumerate(targets, start=1):
        dest = os.path.join(dest_dir, f"{cid}.jpg")
        if not args.overwrite and os.path.exists(dest) and os.path.getsize(dest) > 0:
            n_skip += 1
            continue
        ok, data, err = download_one(url)
        if ok and data:
            with open(dest, "wb") as f:
                f.write(data)
            n_ok += 1
        else:
            n_fail += 1
            print(f"  [失敗] {cid} <- {url}: {err}")
        if i % 50 == 0:
            print(f"  ... {i}/{len(targets)} (ok={n_ok} skip={n_skip} fail={n_fail})")
        time.sleep(args.sleep)

    print(f"\n配置完了: DL {n_ok} / スキップ(既存) {n_skip} / 失敗 {n_fail} -> {dest_dir}")
    if n_fail:
        print("  ⚠️ 失敗があります。デプロイ前に確認してください。")

    if args.deploy:
        print(f"\nデプロイ中（{args.project}）...")
        run(["firebase", "deploy", "--only", "hosting"], cwd=hosting_dir)
        print("デプロイ完了")
    else:
        print("\n（--deploy 未指定のため配置のみ。デプロイは手動で実行してください）")
        print(f"  cd {hosting_dir} && firebase deploy --only hosting")


if __name__ == "__main__":
    main()
