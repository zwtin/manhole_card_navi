#!/usr/bin/env python3
"""
新規カードの原本画像を Firebase Storage の images/color/original/{fs_id}.jpg へアップロードする。

前提:
  - gk-p.jp からDL済みの原本画像が tools/images/{card_id}.jpg にある
  - 画像は「無加工の原本」をそのままアップ（既存Storageと同じ挙動。リサイズ・再エンコードしない）
  - frame_* 等の加工画像はアプリで未使用のためアップしない（originalのみ）
  - fs_id は manhole_coords_new.json の printed_id（カード印字のFirestore ID）

認証:
  - gcloud のアクセストークンを使用（gcloud auth login 済みであること）

冪等:
  - 既にオブジェクトが存在する場合はスキップ（--overwrite で上書き）

使い方:
  python3 tools/upload_images_to_storage.py            # 新規76件をアップ
  python3 tools/upload_images_to_storage.py --dry-run  # 対象一覧のみ表示
"""
import argparse
import json
import os
import subprocess
import sys
import urllib.request
import urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
IMAGES_DIR = os.path.join(HERE, "images")
NEW_COORDS = os.path.join(HERE, "data", "manhole_coords_new.json")
DEFAULT_BUCKET = "manhole-card-navi.appspot.com"
OBJ_PREFIX = "images/color/original"


def access_token():
    try:
        t = subprocess.check_output(
            ["gcloud", "auth", "print-access-token"],
            stderr=subprocess.DEVNULL).decode().strip()
        return t
    except Exception:
        sys.exit("gcloud アクセストークンの取得に失敗。`gcloud auth login` を実行してください。")


def object_exists(token, bucket, obj_name):
    url = (f"https://storage.googleapis.com/storage/v1/b/{bucket}/o/"
           + urllib.parse.quote(obj_name, safe=""))
    req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})
    try:
        urllib.request.urlopen(req, timeout=30)
        return True
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return False
        raise


def upload(token, bucket, local_path, obj_name):
    url = (f"https://storage.googleapis.com/upload/storage/v1/b/{bucket}/o"
           f"?uploadType=media&name=" + urllib.parse.quote(obj_name, safe=""))
    with open(local_path, "rb") as f:
        data = f.read()
    req = urllib.request.Request(url, data=data, method="POST", headers={
        "Authorization": f"Bearer {token}",
        "Content-Type": "image/jpeg",
    })
    with urllib.request.urlopen(req, timeout=120) as resp:
        return resp.status


import urllib.parse  # noqa: E402


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--overwrite", action="store_true", help="既存でも上書き")
    ap.add_argument("--bucket", default=DEFAULT_BUCKET,
                    help="アップロード先バケット（開発: manhole-card-navi-dev.appspot.com）")
    args = ap.parse_args()

    bucket = args.bucket
    new = json.load(open(NEW_COORDS, encoding="utf-8"))
    token = None if args.dry_run else access_token()

    n_up = n_skip = n_missing = 0
    for card_id, info in new.items():
        fs_id = info["printed_id"]
        local = os.path.join(IMAGES_DIR, f"{card_id}.jpg")
        obj = f"{OBJ_PREFIX}/{fs_id}.jpg"

        if not os.path.exists(local):
            print(f"  [画像なし] {card_id} ({fs_id})")
            n_missing += 1
            continue

        if args.dry_run:
            print(f"  {card_id} -> {bucket}/{obj}")
            continue

        if not args.overwrite and object_exists(token, bucket, obj):
            n_skip += 1
            continue

        try:
            upload(token, bucket, local, obj)
            n_up += 1
            if n_up % 10 == 0:
                print(f"  ... {n_up} 件アップロード済み")
        except Exception as e:  # noqa
            print(f"  [失敗] {card_id} -> {obj}: {e}")

    if args.dry_run:
        print(f"\n（--dry-run）対象 {len(new)} 件")
    else:
        print(f"\n完了: アップロード {n_up} / スキップ(既存) {n_skip} / 画像なし {n_missing}")


if __name__ == "__main__":
    main()
