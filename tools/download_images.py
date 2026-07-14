#!/usr/bin/env python3
"""
cards_base.json の image_url からカード画像をダウンロードして tools/images/ に保存する。

要件:
  - https スキーム + Referer https://www.gk-p.jp/mhcard/ が必須（無いと403）
  - 一部404あり。欠損は download_status.json にフラグ化してスキップ（後段はこの画像を除外）
  - 冪等・差分実行: 既に正常DL済み（ファイルが存在しサイズ>0）ならスキップ

使い方:
  python3 tools/download_images.py            # 全件
  python3 tools/download_images.py --limit 30 # 先頭30件だけ（試作用）
  python3 tools/download_images.py --ids card_0001,card_0004  # 指定IDのみ

保存名: <card_id>.jpg （card_idで一意。拡張子は元URLに合わせるが判別はcard_id基準）
状態:   tools/data/download_status.json （card_id -> {ok, path, http_status, bytes, error}）
"""
import argparse
import json
import os
import sys
import time
import urllib.request
import urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
CARDS_PATH = os.path.join(HERE, "data", "cards_base.json")
IMAGES_DIR = os.path.join(HERE, "images")
STATUS_PATH = os.path.join(HERE, "data", "download_status.json")

REFERER = "https://www.gk-p.jp/mhcard/"
USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"


def load_status():
    if os.path.exists(STATUS_PATH):
        return json.load(open(STATUS_PATH, encoding="utf-8"))
    return {}


def save_status(status):
    with open(STATUS_PATH, "w", encoding="utf-8") as f:
        json.dump(status, f, ensure_ascii=False, indent=2)


def ext_from_url(url):
    for e in (".jpg", ".jpeg", ".png"):
        if url.lower().endswith(e):
            return e
    return ".jpg"


def download_one(url):
    """(ok, http_status, data or None, error)"""
    req = urllib.request.Request(url, headers={
        "User-Agent": USER_AGENT,
        "Referer": REFERER,
        "Accept": "image/avif,image/webp,image/apng,image/*,*/*;q=0.8",
    })
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = resp.read()
            return True, resp.status, data, ""
    except urllib.error.HTTPError as e:
        return False, e.code, None, f"HTTPError {e.code}"
    except urllib.error.URLError as e:
        return False, None, None, f"URLError {e.reason}"
    except Exception as e:  # noqa
        return False, None, None, f"{type(e).__name__}: {e}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0, help="先頭N件だけ処理（0=全件）")
    ap.add_argument("--ids", type=str, default="", help="カンマ区切りcard_idのみ処理")
    ap.add_argument("--retry-failed", action="store_true", help="前回失敗分も再試行する")
    ap.add_argument("--sleep", type=float, default=0.15, help="リクエスト間の待機秒")
    args = ap.parse_args()

    os.makedirs(IMAGES_DIR, exist_ok=True)
    cards = json.load(open(CARDS_PATH, encoding="utf-8"))
    status = load_status()

    target_ids = set(x.strip() for x in args.ids.split(",") if x.strip()) if args.ids else None

    todo = cards
    if target_ids is not None:
        todo = [c for c in cards if c["card_id"] in target_ids]
    if args.limit:
        todo = todo[: args.limit]

    n_ok = n_skip = n_fail = 0
    for i, c in enumerate(todo, start=1):
        cid = c["card_id"]
        url = c["image_url"]
        st = status.get(cid)

        # 冪等: 既にOKでファイルが実在すればスキップ
        if st and st.get("ok"):
            p = st.get("path", "")
            if p and os.path.exists(p) and os.path.getsize(p) > 0:
                n_skip += 1
                continue
        # 前回失敗を再試行しない設定なら、404等は確定欠損としてスキップ
        if st and not st.get("ok") and not args.retry_failed:
            n_skip += 1
            continue

        if not url:
            status[cid] = {"ok": False, "path": "", "http_status": None,
                           "bytes": 0, "error": "no image_url"}
            n_fail += 1
            continue

        fname = cid + ext_from_url(url)
        fpath = os.path.join(IMAGES_DIR, fname)
        ok, http_status, data, err = download_one(url)
        if ok and data:
            with open(fpath, "wb") as f:
                f.write(data)
            status[cid] = {"ok": True, "path": fpath, "http_status": http_status,
                           "bytes": len(data), "error": ""}
            n_ok += 1
        else:
            status[cid] = {"ok": False, "path": "", "http_status": http_status,
                           "bytes": 0, "error": err}
            n_fail += 1
            print(f"  [欠損] {cid} {url} -> {err}")

        if i % 50 == 0:
            save_status(status)
            print(f"  ... {i}/{len(todo)} 件処理 (ok={n_ok} skip={n_skip} fail={n_fail})")
        time.sleep(args.sleep)

    save_status(status)
    total_ok = sum(1 for v in status.values() if v.get("ok"))
    total_fail = sum(1 for v in status.values() if not v.get("ok"))
    print(f"\n完了: 今回 ok={n_ok} skip={n_skip} fail={n_fail}")
    print(f"累計: DL成功 {total_ok} / 欠損 {total_fail} / status記録 {len(status)}")
    if total_fail:
        print("欠損一覧:")
        for cid, v in status.items():
            if not v.get("ok"):
                print(f"  {cid}: {v.get('http_status')} {v.get('error')}")


if __name__ == "__main__":
    main()
