#!/usr/bin/env python3
"""【R2移行用・一度きり】既存 master バージョンを土台に、image_url 版の新バージョンを作る。

背景:
  アプリの画像参照が「image（Hosting のパス）＋アプリ側でベースURL前置」から
  「image_url（R2 のフルURL）をそのまま使う」に変わった（PR #14）。
  新アプリを公開するには image_url を持つ master が要るが、
  通常ルート（build_master.py）は cards_base.json と OCR/AI抽出の中間成果物が揃っていないと
  実行できない（新弾のタイミングで全部やり直す前提の作り）。

  一方、Firestore の master/0004 には確定済みのデータが全件入っており、
  Hosting の master/v0004/images/ には確定済みJPEGが全件ある。
  そこで **0004 の内容をそのまま引き継ぎ、画像フィールドだけ差し替えた 0005** を作る。
  カードの中身（座標・配布場所・在庫状況）は 0004 と完全に同一になる。

  次回の新弾では通常ルート（/update-master → build_master.py）に戻る。このスクリプトは
  R2 移行のための一度きりの橋渡し。

やること:
  1. Firestore の master/{source} から cards / prefectures / volumes を全件読む
  2. cards の image（master/v{source}/images/{id}.jpg）を落とし、
     image_url（{R2ベースURL}/master/v{target}/images/{id}.jpg）に差し替える
  3. Firestore 投入用 JSON を出力（upload_master_to_firestore.py にそのまま渡せる形式）
  4. 画像コピー用のカードJSON を出力（deploy_images_to_r2.py --cards に渡す形式）
     ソース画像は Hosting の master/v{source}/images/{id}.jpg。
     gk-p.jp から取り直さないので、**現行ユーザーが見ている画像とバイト単位で同一**になる
     （JPEG変換や再取得による差異が入らない）。

認証: gcloud アクセストークン（Firestore 読み取り）

使い方:
  # dev 用（R2 dev ドメインの image_url）と、画像コピー用カードJSON を出力
  python3 tools/migrate_master_to_r2.py --source-version 0004 --target-version 0005 --project dev

  # prod 用
  python3 tools/migrate_master_to_r2.py --source-version 0004 --target-version 0005 --project prod

  # 出力した画像コピー用JSONで R2 へアップロード
  python3 tools/deploy_images_to_r2.py --version 0005 --project dev \\
    --cards tools/data/firestore/image_copy_0004.json --dry-run
"""
import argparse
import json
import os
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import r2_utils  # noqa: E402
from geo_utils import GEO_KEY  # noqa: E402  （GeoPoint センチネルは geo_utils と共有）

FS = os.path.join(HERE, "data", "firestore")

# 読み出し元。確定データの正は prod。dev 用の JSON も prod の中身から作る
# （dev と prod で master の中身が食い違っている場合に備え、--source-firebase-project で変更可）。
DEFAULT_SOURCE_FIREBASE_PROJECT = "manhole-card-navi"


def token():
    try:
        return subprocess.check_output(
            ["gcloud", "auth", "print-access-token"],
            stderr=subprocess.DEVNULL).decode().strip()
    except Exception:
        sys.exit("gcloud アクセストークン取得失敗。`gcloud auth login` を実行してください。")


def from_value(v):
    """Firestore REST の Value 表現 -> Python値（to_value の逆変換）。"""
    if "nullValue" in v:
        return None
    if "booleanValue" in v:
        return v["booleanValue"]
    if "integerValue" in v:
        return int(v["integerValue"])
    if "doubleValue" in v:
        return float(v["doubleValue"])
    if "stringValue" in v:
        return v["stringValue"]
    if "geoPointValue" in v:
        g = v["geoPointValue"]
        # GeoPoint は geo_utils のセンチネル形式で持つ（upload 側が geoPointValue に戻す）
        return {GEO_KEY: {"lat": float(g.get("latitude", 0.0)),
                          "lon": float(g.get("longitude", 0.0))}}
    if "arrayValue" in v:
        return [from_value(x) for x in v["arrayValue"].get("values", [])]
    if "mapValue" in v:
        return {k: from_value(x) for k, x in v["mapValue"].get("fields", {}).items()}
    if "timestampValue" in v:
        return v["timestampValue"]
    raise ValueError(f"未対応の Firestore Value: {list(v)}")


def list_docs(tok, project, coll_path):
    """コレクション配下の全ドキュメントを {フィールド辞書} のリストで返す（ページング対応）。"""
    base = (f"https://firestore.googleapis.com/v1/projects/{project}"
            f"/databases/(default)/documents/{coll_path}")
    docs = []
    page_token = None
    while True:
        params = {"pageSize": "300"}
        if page_token:
            params["pageToken"] = page_token
        url = base + "?" + urllib.parse.urlencode(params)
        req = urllib.request.Request(url, headers={"Authorization": f"Bearer {tok}"})
        try:
            with urllib.request.urlopen(req, timeout=60) as resp:
                data = json.loads(resp.read())
        except urllib.error.HTTPError as e:
            sys.exit(f"list失敗 HTTP {e.code}: {e.read().decode()[:300]}")
        for doc in data.get("documents", []):
            fields = {k: from_value(v) for k, v in doc.get("fields", {}).items()}
            fields.setdefault("id", doc["name"].rsplit("/", 1)[-1])
            docs.append(fields)
        page_token = data.get("nextPageToken")
        if not page_token:
            break
    return docs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--source-version", required=True,
                    help="読み出し元の master バージョン（例 0004）")
    ap.add_argument("--target-version", required=True,
                    help="生成する master バージョン（例 0005）")
    ap.add_argument("--project", required=True, choices=list(r2_utils.PROJECTS),
                    help="出力先（dev / prod）。R2 の配信ベース URL が切り替わる")
    ap.add_argument("--source-firebase-project", default=DEFAULT_SOURCE_FIREBASE_PROJECT,
                    help="読み出し元の Firebase プロジェクトID（既定 manhole-card-navi）")
    ap.add_argument("--base-url", default=None,
                    help="R2 配信ベース URL を明示指定（既定は --project から解決）")
    ap.add_argument("--image-base-url", default=None,
                    help="画像コピー元のベース URL（既定 https://{source-firebase-project}.web.app）")
    ap.add_argument("--out", default=None,
                    help="master JSON の出力先（既定 data/firestore/master_{target}_{project}.json）")
    ap.add_argument("--cards-out", default=None,
                    help="画像コピー用カードJSONの出力先（既定 data/firestore/image_copy_{source}.json）")
    args = ap.parse_args()

    base_url = r2_utils.base_url_of(args.project, args.base_url)
    image_base = (args.image_base_url
                  or f"https://{args.source_firebase_project}.web.app").rstrip("/")
    out_path = args.out or os.path.join(
        FS, f"master_{args.target_version}_{args.project}.json")
    cards_out_path = args.cards_out or os.path.join(
        FS, f"image_copy_{args.source_version}.json")

    if args.source_version == args.target_version:
        sys.exit("--source-version と --target-version が同じです。"
                 "既存バージョンを壊さないよう別の番号にしてください。")

    root = f"master/{args.source_version}"
    tok = token()
    print(f"読み出し元 : {args.source_firebase_project} の {root}")
    cards = list_docs(tok, args.source_firebase_project, f"{root}/cards")
    prefectures = list_docs(tok, args.source_firebase_project, f"{root}/prefectures")
    volumes = list_docs(tok, args.source_firebase_project, f"{root}/volumes")
    print(f"  cards {len(cards)} / prefectures {len(prefectures)} / volumes {len(volumes)}")
    if not cards:
        sys.exit("cards が0件です。--source-version を確認してください。")

    expected_prefix = f"master/v{args.source_version}/images/"
    warnings = []
    cards_out = []
    copy_targets = []
    for c in dict_sorted(cards):
        cid = c["id"]
        image = c.get("image")
        if not image:
            warnings.append(f"{cid}: image が無い（画像コピー元を特定できない）")
        elif not image.startswith(expected_prefix):
            warnings.append(f"{cid}: image が想定と違う: {image}")
        if c.get("image_url"):
            warnings.append(f"{cid}: 既に image_url がある: {c['image_url']}")

        new_card = {k: v for k, v in c.items() if k not in ("image", "image_url")}
        new_card["image_url"] = r2_utils.image_url(base_url, args.target_version, cid)
        cards_out.append(new_card)

        if image:
            copy_targets.append({
                "card_id": cid,
                "ocr_id": cid,                       # master の ID は OCR 確定値そのもの
                "image_url": f"{image_base}/{image}",  # Hosting 上の確定JPEG
            })

    out = {
        "version": args.target_version,
        "prefectures": [{"id": p["id"], "name": p.get("name", "")} for p in dict_sorted(prefectures)],
        "volumes": [{"id": v["id"], "name": v.get("name", "")} for v in dict_sorted(volumes)],
        "cards": cards_out,
    }
    os.makedirs(FS, exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
    with open(cards_out_path, "w", encoding="utf-8") as f:
        json.dump(copy_targets, f, ensure_ascii=False, indent=2)

    print(f"\nmaster JSON 生成完了 -> {out_path}")
    print(f"  画像URL    : {r2_utils.image_url(base_url, args.target_version, '{id}')}")
    print(f"  cards      : {len(cards_out)}")
    print(f"画像コピー用カードJSON -> {cards_out_path}")
    print(f"  コピー元   : {image_base}/{expected_prefix}{{id}}.jpg")
    print(f"  対象       : {len(copy_targets)}")
    if warnings:
        print(f"\n=== 警告 {len(warnings)}件 ===")
        for w in warnings[:30]:
            print("  ", w)
        if len(warnings) > 30:
            print(f"   ... 他 {len(warnings)-30} 件")

    print("\n次の手順:")
    print(f"  1) 画像コピー: python3 tools/deploy_images_to_r2.py "
          f"--version {args.target_version} --project {args.project} "
          f"--cards {cards_out_path} --sleep 0 --dry-run")
    print("     （コピー元は自前の Hosting なので --sleep 0 でよい）")
    print(f"  2) Firestore : python3 tools/upload_master_to_firestore.py "
          f"--project <firebase project> --input {out_path} "
          f"--target-version {args.target_version} --replace --dry-run")


def dict_sorted(docs):
    """ID順に並べる（出力 JSON の差分を安定させるため）。"""
    return sorted(docs, key=lambda d: d.get("id", ""))


if __name__ == "__main__":
    main()
