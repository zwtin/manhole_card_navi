#!/usr/bin/env python3
"""
新しい master バージョンとして投入する完全なデータセットを生成する。

バージョン番号は --version で指定する（例 0004）。以下 {version} と表記。

構成方針:
  - 既存 master の cards / contacts / images / prefectures / volumes を「そのまま引き継ぐ」
    （ただし images.color_original は新形式 master/v{version}/images/{id}.jpg に正規化）
  - 新規カードを追記する:
      * cards      : 新IDで追加。座標・弾数ID・都道府県ID・image_id・distribution_* を設定
      * contacts   : 新規配布場所を連番採番して追加
      * images     : 新規画像を連番採番して追加
                     （color_original = Hosting パス master/v{version}/images/{id}.jpg）
      * volumes    : 新しい弾を追加
      * cards の contact_id 紐付け（サブコレクション）も生成
  - prefectures は変更なし（既存そのまま）

カードID・座標:
  - 新規カードのID・座標は cards_base.json の OCR確定値（ocr_id / ocr_lat_dms /
    ocr_lon_dms）を優先し、無ければ manhole_coords_new.json にフォールバックする。

画像配信:
  - 画像は Firebase Hosting（CDN）から配信する。master には配信 URL ではなく
    Hosting 上のパス（master/v{version}/images/{id}.jpg）のみを持たせ、ベース URL
    （https://{projectId}.web.app）はアプリ側で付与する。

出力: --out で指定（例 tools/data/firestore/master_{version}.json）
  {
    "version": "{version}",
    "prefectures": [...],
    "volumes": [...],
    "images": [...],
    "contacts": [...],
    "cards": [ {..., "contact_ids": [...]} ]
  }

入力:
  tools/data/firestore/{cards,contacts,images,volumes,prefectures}.json  (既存master/0002)
  tools/data/firestore/card_contact_map.json                            (既存cardのcontact_id紐付け)
  tools/data/cards_base.json                                            (全1265件の抽出データ)
  tools/data/manhole_coords_new.json                                   (新規76件の座標+printed_id)
  tools/data/distribution_new.json                                     (新規76件の配布場所構造化)
  tools/data/geocode_cache.json                                        (住所->座標)
"""
import argparse
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from geo_utils import parse_dms_string, validate_jp_latlon  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
FS = os.path.join(HERE, "data", "firestore")
DATA = os.path.join(HERE, "data")


def load(path):
    return json.load(open(path, encoding="utf-8"))


def image_filename(color_original):
    """画像の color_original 値からファイル名（{id}.jpg）を取り出す。

    旧形式の GCS 絶対 URL
    （https://storage.googleapis.com/.../images/color/original/{id}.jpg）でも、
    新形式のパス（master/v{version}/images/{id}.jpg）でも、末尾のファイル名を返す。
    """
    return color_original.rstrip("/").rsplit("/", 1)[-1]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True,
                    help="master バージョン（例 0004）。画像パス master/v{version}/images/ に使う")
    ap.add_argument("--out", default=None,
                    help="出力先JSONパス（省略時は data/firestore/master_{version}.json）")
    args = ap.parse_args()
    if args.out is None:
        args.out = os.path.join(FS, f"master_{args.version}.json")
    # 画像は Firebase Hosting から配信する。マスターデータには配信 URL ではなく
    # Hosting 上のパスのみを持たせ、ベース URL（https://{projectId}.web.app）は
    # アプリ側で付与する。バージョンをパスに含めることで、バージョン更新のたびに
    # URL が変わり、クライアントのキャッシュを引かずに画像を差し替えできる。
    image_dir = f"master/v{args.version}/images"

    # --- 既存 master/0002 ---
    ex_cards = load(os.path.join(FS, "cards.json"))
    ex_contacts = load(os.path.join(FS, "contacts.json"))
    ex_images = load(os.path.join(FS, "images.json"))
    ex_volumes = load(os.path.join(FS, "volumes.json"))          # {id: name}
    ex_prefectures = load(os.path.join(FS, "prefectures.json"))  # {id: name}
    card_contact_map = load(os.path.join(FS, "card_contact_map.json"))  # {cardId: [contactId]}

    # --- 新規 ---
    cards_base = {c["card_id"]: c for c in load(os.path.join(DATA, "cards_base.json"))}
    new_coords = load(os.path.join(DATA, "manhole_coords_new.json"))
    new_dist = load(os.path.join(DATA, "distribution_new.json"))
    geocache = load(os.path.join(DATA, "geocode_cache.json"))

    # ---- volumes: 弾名 -> id の逆引き。第27,28弾を追加 ----
    vol_name2id = {v: k for k, v in ex_volumes.items()}
    volumes_out = dict(ex_volumes)
    next_vol = max(int(k) for k in ex_volumes) + 1
    for edition in ["第27弾", "第28弾"]:
        if edition not in vol_name2id:
            vid = f"{next_vol:04d}"
            volumes_out[vid] = edition
            vol_name2id[edition] = vid
            next_vol += 1

    # ---- 採番の起点 ----
    next_contact = max(int(c["id"]) for c in ex_contacts) + 1
    next_image = max(int(i["id"]) for i in ex_images) + 1

    warnings = []

    def to_float(v):
        """lat/lon を必ず float にする。既存データで整数座標が文字列/整数で
        入っているケース（例: 明石市の経度135, 鎌ケ谷市の経度140）を数値に正規化。"""
        try:
            return float(v)
        except (TypeError, ValueError):
            return None

    # 既存をそのまま引き継ぐ（contacts の lat/lon も float に正規化）
    contacts_out = []
    for c in ex_contacts:
        cc = dict(c)
        for k in ("latitude", "longitude"):
            fv = to_float(cc.get(k))
            cc[k] = fv if fv is not None else 0.0
        contacts_out.append(cc)
    # 既存 images（旧 master から引き継ぐ分）も、color_original を新形式の
    # Hosting パス master/v{version}/images/{id}.jpg に正規化して引き継ぐ。
    images_out = []
    for i in ex_images:
        ci = dict(i)
        ci["color_original"] = f"{image_dir}/{image_filename(i['color_original'])}"
        images_out.append(ci)

    cards_out = []
    for c in ex_cards:
        cc = dict(c)
        cc["contact_ids"] = card_contact_map.get(c["id"], [])
        # lat/lon を float に正規化（投入時に必ず doubleValue で書かれるようにする）
        for k in ("latitude", "longitude"):
            fv = to_float(cc.get(k))
            if fv is None:
                warnings.append(f"{c['id']} {k} が数値化できない: {cc.get(k)!r}")
            else:
                cc[k] = fv
        cards_out.append(cc)

    # ---- 新規76件を追加 ----
    for card_id, coord in new_coords.items():
        base = cards_base[card_id]

        # カードID・座標は OCR確定値（二重読み検証済みの ocr_*）を優先し、
        # 無ければ従来の manhole_coords_new.json の値にフォールバックする。
        # ocr_id はカード画像に印字された正規化ID（例 00-101-A001）。
        fs_id = base.get("ocr_id") or coord["printed_id"]
        lat_dms = base.get("ocr_lat_dms") or coord["lat_dms"]
        lon_dms = base.get("ocr_lon_dms") or coord["lon_dms"]

        # 座標
        lat = parse_dms_string(lat_dms)
        lon = parse_dms_string(lon_dms)
        ok, reason = validate_jp_latlon(lat, lon)
        if not ok:
            warnings.append(f"{card_id} 座標NG: {reason}")

        # 都道府県ID（画像先頭2桁 -> 3桁ゼロ埋め）
        pref_id = f"{int(base['pref_code']):03d}" if base["pref_code"] else "000"
        # 弾数ID
        vol_id = vol_name2id.get(base["edition"])
        if not vol_id:
            warnings.append(f"{card_id} 弾数ID不明: {base['edition']}")
            vol_id = ""

        # 画像を新規登録
        image_id = f"{next_image:06d}"
        next_image += 1
        images_out.append({
            "id": image_id,
            "color_original": f"{image_dir}/{fs_id}.jpg",
        })

        # 配布場所（contacts）を新規登録し、contact_id を紐付け
        dist = new_dist.get(card_id, {})
        contact_ids = []
        for loc in dist.get("locations", []):
            addr = (loc.get("address") or "").strip()
            g = geocache.get(addr, {})
            c_lat = g.get("lat")
            c_lon = g.get("lon")
            if addr and (c_lat is None):
                warnings.append(f"{card_id} 配布場所ジオコーディング欠落: {addr}")
            cid = f"{next_contact:06d}"
            next_contact += 1
            contacts_out.append({
                "id": cid,
                "name": loc.get("name", ""),
                "name_url": loc.get("name_url", ""),
                "address": addr,
                "phone_number": loc.get("tel", ""),
                "latitude": c_lat if c_lat is not None else 0.0,
                "longitude": c_lon if c_lon is not None else 0.0,
                "time": "",
                "time_other": "",
                "other": dist.get("contact", ""),
            })
            contact_ids.append(cid)

        # 在庫状況テキスト（既存スキーマの distribution_* を埋める）
        stock_html = base.get("stock_html", "")
        link_m = re.search(r'href="([^"]+)"', stock_html, re.I)
        link_text_m = re.search(r'>([^<]+)</a>', stock_html, re.I)
        distribution_link_url = link_m.group(1) if link_m else ""
        distribution_link_text = link_text_m.group(1) if link_text_m else ""
        distribution_text = re.sub(r"<[^>]+>", "", stock_html).replace(distribution_link_text, "").strip()

        cards_out.append({
            "id": fs_id,
            "name": base["municipality"],
            "prefecture_id": pref_id,
            "volume_id": vol_id,
            "image_id": image_id,
            "publication_date": base["issued_date"],
            "latitude": lat,
            "longitude": lon,
            "distribution_state": "distributing",  # 新規は全て配布中
            "distribution_text": distribution_text,
            "distribution_link_text": distribution_link_text,
            "distribution_link_url": distribution_link_url,
            "distribution_other": "",
            "contact_ids": contact_ids,
        })

    prefectures_out = [{"id": k, "name": v} for k, v in sorted(ex_prefectures.items())]
    volumes_final = [{"id": k, "name": v} for k, v in sorted(volumes_out.items())]

    out = {
        "version": args.version,
        "prefectures": prefectures_out,
        "volumes": volumes_final,
        "images": images_out,
        "contacts": contacts_out,
        "cards": cards_out,
    }
    out_path = args.out
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

    print(f"master JSON 生成完了 -> {out_path}")
    print(f"  画像パス   : {image_dir}/{{id}}.jpg")
    print(f"  cards      : {len(cards_out)} (既存{len(ex_cards)} + 新規{len(new_coords)})")
    print(f"  contacts   : {len(contacts_out)} (既存{len(ex_contacts)} + 新規{len(contacts_out)-len(ex_contacts)})")
    print(f"  images     : {len(images_out)} (既存{len(ex_images)} + 新規{len(images_out)-len(ex_images)})")
    print(f"  volumes    : {len(volumes_final)} (第27・28弾を追加)")
    print(f"  prefectures: {len(prefectures_out)}")
    if warnings:
        print(f"\n=== 警告 {len(warnings)}件 ===")
        for w in warnings[:30]:
            print("  ", w)


if __name__ == "__main__":
    main()
