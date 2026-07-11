#!/usr/bin/env python3
"""
gk-p.jp の全カードから master バージョンを「毎回まるごと」生成する。

バージョン番号は --version で指定する（例 0004）。以下 {version} と表記。

設計方針:
  - 既存 master を引き継がず、cards_base.json（サイトの全カード）から全件を再生成する。
    これにより、弾の追加・カードの増減・在庫状況の変化がすべて自動で反映される。
  - カードID・マンホール座標は OCR 確定値（ocr_*）を使う。
  - 配布場所の住所・在庫状況は AI 抽出の確定値（dist_*）を使う。
  - 配布場所の座標は geocode_cache から引く。
  - 都道府県ID・弾IDは決定論的に導出する（ハードコードしない）:
      prefecture_id = pref_code を3桁ゼロ埋め（000=国機関 … 047=沖縄県）
      volume_id     = 弾番号 - 1 を4桁ゼロ埋め（第01弾=0000 … 第28弾=0027）

出力構造（3コレクション）:
  {
    "version": "{version}",
    "prefectures": [{id, name}, ...],           全48件（000=国機関）
    "volumes":     [{id, name}, ...],           登場する弾すべて
    "cards": [{
      id                      : OCR確定ID（例 00-101-A001）
      name                    : 自治体名
      prefecture_id           : "001"
      volume_id               : "0026"
      publication_date        : "2022/08/06"
      location                : GeoPoint       マンホール座標（OCR確定）
      image                   : "master/v{version}/images/{id}.jpg"
      distribution_place_html : 配布場所HTML（サイトのまま）
      distribution_points     : [GeoPoint]     配布場所の座標（0〜複数）
      stock_html              : 在庫状況HTML（サイトのまま）
      distribution_state      : distributing / stopped / notClear
    }, ...]
  }

  ※ 旧構造の contacts / images コレクションは廃止。配布場所と画像はカードに埋め込む。

入力:
  tools/data/cards_base.json    parse_cards.py の出力に、以下が付与されていること
      ocr_id / ocr_lat_dms / ocr_lon_dms   … ocr_cards.py（画像の二重OCR）
      dist_addresses / dist_state          … extract_distribution.py（配布場所のAI抽出）
  tools/data/geocode_cache.json  住所 -> 座標（geocode.py）

前提が欠けていれば、どのカードの何が足りないかを表示して中断する。

使い方:
  python3 tools/build_master.py --version 0004
  python3 tools/build_master.py --version 0004 --out path/to/master.json
"""
import argparse
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from geo_utils import geopoint, parse_dms_string, validate_jp_latlon  # noqa: E402
from parse_cards import PREF_BY_CODE  # noqa: E402  （都道府県コード -> 名前）

FS = os.path.join(HERE, "data", "firestore")
DATA = os.path.join(HERE, "data")

EDITION_RE = re.compile(r"第(\d+)弾")


def load(path):
    return json.load(open(path, encoding="utf-8"))


def volume_id_of(edition):
    """弾名（例 '第27弾'）から決定論的に volume_id を導出する。

    第01弾 -> "0000" … 第28弾 -> "0027"（既存 master の採番規約に合わせる）。
    形式が違えば None。
    """
    m = EDITION_RE.fullmatch((edition or "").strip())
    if not m:
        return None
    return f"{int(m.group(1)) - 1:04d}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True,
                    help="master バージョン（例 0004）。画像パス master/v{version}/images/ に使う")
    ap.add_argument("--out", default=None,
                    help="出力先JSONパス（省略時は data/firestore/master_{version}.json）")
    args = ap.parse_args()
    if args.out is None:
        args.out = os.path.join(FS, f"master_{args.version}.json")

    # 画像は Firebase Hosting から配信する。master には配信 URL ではなく Hosting 上の
    # パスのみを持たせ、ベース URL（https://{projectId}.web.app）はアプリ側で付与する。
    image_dir = f"master/v{args.version}/images"

    cards_base = load(os.path.join(DATA, "cards_base.json"))
    geocache = load(os.path.join(DATA, "geocode_cache.json"))

    errors = []    # 致命的（これがあると master を作れない）
    warnings = []  # 注意（作れるが確認すべき）

    # ---- 前提チェック: OCR と AI抽出が全カードに揃っているか ----
    for c in cards_base:
        cid = c["card_id"]
        if not c.get("ocr_id"):
            errors.append(f"{cid}: ocr_id が無い（ocr_cards.py を実行）")
        if not c.get("ocr_lat_dms") or not c.get("ocr_lon_dms"):
            errors.append(f"{cid}: OCR座標が無い（ocr_cards.py を実行）")
        if not c.get("dist_state"):
            errors.append(f"{cid}: dist_state が無い（extract_distribution.py を実行）")
        if "dist_addresses" not in c:
            errors.append(f"{cid}: dist_addresses が無い（extract_distribution.py を実行）")

    # ---- ID の重複チェック（同じIDのカードがあると画像も上書きされる）----
    from collections import Counter
    id_counts = Counter(c.get("ocr_id") for c in cards_base if c.get("ocr_id"))
    for k, n in id_counts.items():
        if n > 1:
            errors.append(f"ocr_id が重複: {k} ×{n}")

    if errors:
        print(f"=== エラー {len(errors)}件（master を生成できません）===")
        for e in errors[:40]:
            print("  ", e)
        if len(errors) > 40:
            print(f"   ... 他 {len(errors)-40} 件")
        sys.exit(1)

    # ---- prefectures: 全48件（マスタ一覧として常に全件出す）----
    prefectures_out = [
        {"id": f"{int(code):03d}", "name": name}
        for code, name in sorted(PREF_BY_CODE.items())
    ]

    # ---- volumes: 登場する弾から導出 ----
    vols = {}
    for c in cards_base:
        vid = volume_id_of(c.get("edition"))
        if vid is None:
            warnings.append(f"{c['card_id']}: 弾名が解釈できない: {c.get('edition')!r}")
            continue
        vols[vid] = c["edition"].strip()
    volumes_out = [{"id": k, "name": v} for k, v in sorted(vols.items())]

    # ---- cards ----
    cards_out = []
    n_points = 0
    for c in cards_base:
        cid = c["card_id"]
        fs_id = c["ocr_id"]

        # マンホール座標（OCR確定のDMS -> 10進）
        lat = parse_dms_string(c["ocr_lat_dms"])
        lon = parse_dms_string(c["ocr_lon_dms"])
        ok, reason = validate_jp_latlon(lat, lon)
        if not ok:
            warnings.append(f"{cid} ({fs_id}) マンホール座標NG: {reason}")

        # 配布場所の座標（住所 -> geocode_cache）
        points = []
        for addr in c.get("dist_addresses", []):
            g = geocache.get(addr)
            if not g:
                warnings.append(f"{cid} ({fs_id}) 未ジオコーディング: {addr}")
                continue
            if g.get("status") != "OK":
                warnings.append(f"{cid} ({fs_id}) ジオコーディング失敗({g.get('status')}): {addr}")
                continue
            if not g.get("jp_ok", True):
                warnings.append(f"{cid} ({fs_id}) 座標が日本範囲外: {addr}")
                continue
            points.append(geopoint(g["lat"], g["lon"]))
        n_points += len(points)

        pref_id = f"{int(c['pref_code']):03d}"
        vol_id = volume_id_of(c.get("edition")) or ""

        cards_out.append({
            "id": fs_id,
            "name": c["municipality"],
            "prefecture_id": pref_id,
            "volume_id": vol_id,
            "publication_date": c["issued_date"],
            "location": geopoint(lat, lon),
            "image": f"{image_dir}/{fs_id}.jpg",
            "distribution_place_html": c.get("distribution_html", ""),
            "distribution_points": points,
            "stock_html": c.get("stock_html", ""),
            "distribution_state": c["dist_state"],
        })

    out = {
        "version": args.version,
        "prefectures": prefectures_out,
        "volumes": volumes_out,
        "cards": cards_out,
    }
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

    from collections import Counter as C2
    st = C2(c["distribution_state"] for c in cards_out)
    no_point = sum(1 for c in cards_out if not c["distribution_points"])

    print(f"master JSON 生成完了 -> {args.out}")
    print(f"  画像パス   : {image_dir}/{{id}}.jpg")
    print(f"  cards      : {len(cards_out)}")
    print(f"  prefectures: {len(prefectures_out)}")
    print(f"  volumes    : {len(volumes_out)}  ({volumes_out[0]['name']} 〜 {volumes_out[-1]['name']})")
    print(f"  配布場所座標: 延べ {n_points} / 座標0件のカード {no_point}")
    print(f"  配布状況    : {dict(st)}")
    if warnings:
        print(f"\n=== 警告 {len(warnings)}件 ===")
        for w in warnings[:30]:
            print("  ", w)
        if len(warnings) > 30:
            print(f"   ... 他 {len(warnings)-30} 件")


if __name__ == "__main__":
    main()
