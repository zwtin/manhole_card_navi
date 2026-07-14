#!/usr/bin/env python3
"""
各段の中間データを結合して正規化2ファイルのCSVを出力する。

入力:
  data/cards_base.json           : HTMLパース結果（全カード基礎データ）
  data/manhole_coords_*.json     : card_id -> {lat_dms, lon_dms}（画像から読取）
  data/distribution_*.json       : card_id -> {distribution_status, contact, locations[]}
  data/geocode_cache.json        : 住所 -> {lat, lon, ...}
  data/download_status.json      : card_id -> {ok, ...}（画像欠損フラグ）

出力:
  out/cards.csv                  : 1カード1行
  out/distribution_locations.csv : 配布場所1地点1行（card_idで紐付け）

DMS→10進変換とバリデーションは geo_utils を利用。
--coords / --dist で試作用/全件用のファイルを切り替え。
"""
import argparse
import csv
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from geo_utils import parse_dms_string, validate_jp_latlon  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "data")
OUT = os.path.join(HERE, "out")


def load_json(path, default):
    if os.path.exists(path):
        return json.load(open(path, encoding="utf-8"))
    return default


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--coords", default="manhole_coords_pilot.json",
                    help="data/ 内のマンホール座標JSON")
    ap.add_argument("--dist", default="distribution_pilot.json",
                    help="data/ 内の配布場所構造化JSON")
    ap.add_argument("--only-processed", action="store_true",
                    help="座標or配布場所データがあるカードのみ出力（試作確認用）")
    args = ap.parse_args()

    os.makedirs(OUT, exist_ok=True)
    cards = load_json(os.path.join(DATA, "cards_base.json"), [])
    coords = load_json(os.path.join(DATA, args.coords), {})
    dist = load_json(os.path.join(DATA, args.dist), {})
    geocache = load_json(os.path.join(DATA, "geocode_cache.json"), {})
    dlstatus = load_json(os.path.join(DATA, "download_status.json"), {})

    cards_rows = []
    loc_rows = []

    for c in cards:
        cid = c["card_id"]
        processed = (cid in coords) or (cid in dist)
        if args.only_processed and not processed:
            continue

        # マンホール座標（画像読取 -> DMS -> 10進）
        mh_lat = mh_lon = None
        mh_flag = ""
        cc = coords.get(cid)
        if cc:
            mh_lat = parse_dms_string(cc.get("lat_dms", ""))
            mh_lon = parse_dms_string(cc.get("lon_dms", ""))
            ok, reason = validate_jp_latlon(mh_lat, mh_lon)
            if not ok:
                mh_flag = f"要確認: {reason}"
        else:
            mh_flag = "座標未取得"

        # 画像欠損フラグ
        dl = dlstatus.get(cid, {})
        image_missing = (not dl.get("ok", False)) if dl else False

        # 配布情報
        dd = dist.get(cid, {})
        dstatus = dd.get("distribution_status", "unknown")
        contact = dd.get("contact", "")
        locations = dd.get("locations", [])
        dist_stopped = 1 if dstatus in ("stopped", "ended") else 0
        no_location = 1 if not locations else 0

        cards_rows.append({
            "card_id": cid,
            "prefecture": c["prefecture"],
            "municipality": c["municipality"],
            "serial": c["serial"],
            "edition": c["edition"],
            "issued_date": c["issued_date"],
            "image_url": c["image_url"],
            "image_missing": 1 if image_missing else 0,
            "manhole_lat": mh_lat if mh_lat is not None else "",
            "manhole_lon": mh_lon if mh_lon is not None else "",
            "manhole_coord_flag": mh_flag,
            "distribution_time": c["distribution_time"].replace("\n", " / "),
            "stock_status": c["stock_text"].replace("\n", " / "),
            "distribution_status": dstatus,
            "distribution_stopped": dist_stopped,
            "no_location_flag": no_location,
            "contact": contact,
        })

        # 配布場所（1地点1行）
        for idx, loc in enumerate(locations, start=1):
            addr = (loc.get("address") or "").strip()
            g = geocache.get(addr, {})
            glat = g.get("lat", "")
            glon = g.get("lon", "")
            gflag = ""
            if addr:
                if g.get("status") == "OK":
                    if not g.get("jp_ok", True):
                        gflag = f"要確認: {g.get('jp_reason','')}"
                elif g:
                    gflag = f"ジオコーディング失敗: {g.get('status','')}"
                else:
                    gflag = "ジオコーディング未実行"
            else:
                gflag = "住所なし"
            loc_rows.append({
                "card_id": cid,
                "location_index": idx,
                "name": loc.get("name", ""),
                "address": addr,
                "tel": loc.get("tel", ""),
                "lat": glat if glat is not None else "",
                "lon": glon if glon is not None else "",
                "geocode_flag": gflag,
                "geocode_formatted": g.get("formatted_address", ""),
            })

    cards_csv = os.path.join(OUT, "cards.csv")
    with open(cards_csv, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(cards_rows[0].keys()))
        w.writeheader()
        w.writerows(cards_rows)

    loc_csv = os.path.join(OUT, "distribution_locations.csv")
    loc_fields = ["card_id", "location_index", "name", "address", "tel",
                  "lat", "lon", "geocode_flag", "geocode_formatted"]
    with open(loc_csv, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=loc_fields)
        w.writeheader()
        w.writerows(loc_rows)

    print(f"cards.csv                : {len(cards_rows)} 行 -> {cards_csv}")
    print(f"distribution_locations.csv: {len(loc_rows)} 行 -> {loc_csv}")
    # サマリ
    geocoded = sum(1 for r in loc_rows if r["lat"] not in ("", None))
    print(f"配布場所のうちジオコーディング済: {geocoded}/{len(loc_rows)}")
    coord_ng = sum(1 for r in cards_rows if r["manhole_coord_flag"].startswith("要確認"))
    if coord_ng:
        print(f"マンホール座標 要確認: {coord_ng} 件")


if __name__ == "__main__":
    main()
