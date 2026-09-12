#!/usr/bin/env python3
"""
配布場所の住所を Google Geocoding API で緯度経度化する。

入力: distribution_*.json （card_id -> {distribution_status, contact, locations:[{name,address,tel}]}）
出力: geocode_cache.json （住所文字列 -> {lat, lon, formatted_address, location_type, status}）

特徴:
  - APIキーは環境変数 GOOGLE_GEOCODING_API_KEY から読む（ハードコードしない）
  - 住所文字列をキーにキャッシュ。冪等・差分実行（同じ住所は再問い合わせしない）
  - 日本国内バリデーション（geo_utils）で誤ジオコーディングを検出しフラグ化
  - components=country:JP でバイアス、language=ja, region=jp

使い方:
  export GOOGLE_GEOCODING_API_KEY=xxxxx
  python3 tools/geocode.py --input tools/data/distribution_pilot.json
  python3 tools/geocode.py --input tools/data/distribution_all.json   # 全件
  python3 tools/geocode.py --input ... --dry-run   # APIを呼ばずキャッシュ状況だけ表示
"""
import argparse
import json
import os
import sys
import time
import urllib.parse
import urllib.request

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from geo_utils import validate_jp_latlon  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
CACHE_PATH = os.path.join(HERE, "data", "geocode_cache.json")
# data/ ではなく tools/ 直下に置く（data/ は .gitignore 済みで、人手の判断が消えるため）。
RESOLVED_PATH = os.path.join(HERE, "geocode_resolved.json")
API_URL = "https://maps.googleapis.com/maps/api/geocode/json"


def load_cache():
    if os.path.exists(CACHE_PATH):
        return json.load(open(CACHE_PATH, encoding="utf-8"))
    return {}


def save_cache(cache):
    with open(CACHE_PATH, "w", encoding="utf-8") as f:
        json.dump(cache, f, ensure_ascii=False, indent=2)


def load_resolved():
    """人手で確定した「問い合わせ文字列の差し替え」表。

    gk-p.jp の住所表記のままだと Google が番地まで解決できず、市区町村や区の重心
    （location_type=APPROXIMATE）を返してしまうことがある。地図ピンが数百m〜数km
    ずれるので、そういう住所だけ**問い合わせに使う文字列**を人手で差し替える。

    置き場所は `tools/geocode_resolved.json`（`tools/data/` ではない）。人手で確かめた判断
    なので、中間成果物と違ってリポジトリに残す。

    形式（キーはサイト表記の住所そのまま）:
      { "愛知県名古屋市千種区月が丘1-1-44": {
            "query": "愛知県名古屋市千種区月ケ丘1-1-44",
            "_note": "サイトは『月が丘』だが実際は『月ケ丘』。..." } }

    **座標は書かない。** 差し替えるのは問い合わせ文字列だけで、座標は必ず Google から
    取る（人力の座標を混ぜない、というこのリポジトリの原則を保つため）。
    結果はサイト表記の住所をキーにキャッシュされるので、build_master 側の参照は変わらない。
    """
    if os.path.exists(RESOLVED_PATH):
        return json.load(open(RESOLVED_PATH, encoding="utf-8"))
    return {}


def geocode_one(address, api_key):
    """Google Geocoding APIを1回叩く。戻り値は結果dict。"""
    params = {
        "address": address,
        "key": api_key,
        "language": "ja",
        "region": "jp",
        "components": "country:JP",
    }
    url = API_URL + "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={"User-Agent": "manhole-card-geocoder/1.0"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read().decode("utf-8"))

    status = data.get("status")
    if status == "OK" and data.get("results"):
        r = data["results"][0]
        loc = r["geometry"]["location"]
        lat, lon = loc["lat"], loc["lng"]
        jp_ok, jp_reason = validate_jp_latlon(lat, lon)
        return {
            "status": status,
            "lat": lat,
            "lon": lon,
            "formatted_address": r.get("formatted_address", ""),
            "location_type": r["geometry"].get("location_type", ""),
            "jp_ok": jp_ok,
            "jp_reason": jp_reason,
        }
    return {
        "status": status,
        "lat": None, "lon": None,
        "formatted_address": "",
        "location_type": "",
        "jp_ok": False,
        "jp_reason": data.get("error_message", "no result"),
    }


def collect_addresses(data):
    """入力から住所文字列のユニークリストを取り出す。2形式を自動判別する。

    - cards_base.json 形式（list）: 各カードの dist_addresses（AI抽出の確定住所）
    - distribution_*.json 形式（dict）: card_id -> {locations: [{address}]}（旧形式）
    """
    addrs = []
    seen = set()

    def add(a):
        a = (a or "").strip()
        if a and a not in seen:
            seen.add(a)
            addrs.append(a)

    if isinstance(data, list):
        # cards_base.json
        for card in data:
            for a in card.get("dist_addresses", []):
                add(a)
    else:
        # distribution_*.json（旧形式）
        for v in data.values():
            for loc in v.get("locations", []):
                add(loc.get("address"))
    return addrs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input",
                    default=os.path.join(HERE, "data", "cards_base.json"),
                    help="cards_base.json（dist_addresses を使う）または "
                         "distribution_*.json（旧形式）")
    ap.add_argument("--dry-run", action="store_true", help="APIを呼ばずキャッシュ状況のみ表示")
    ap.add_argument("--sleep", type=float, default=0.05, help="リクエスト間の待機秒")
    ap.add_argument("--retry-failed", action="store_true", help="前回失敗した住所も再試行")
    args = ap.parse_args()

    dist = json.load(open(args.input, encoding="utf-8"))
    addresses = collect_addresses(dist)
    cache = load_cache()
    resolved = load_resolved()

    def query_for(a):
        return (resolved.get(a) or {}).get("query") or a

    def needs_query(a):
        if a not in cache:
            return True
        if args.retry_failed and cache[a].get("status") != "OK":
            return True
        # 差し替えを足した / 変えた住所は、キャッシュが古い問い合わせの結果なので取り直す
        return cache[a].get("query_used", a) != query_for(a)

    need = [a for a in addresses if needs_query(a)]
    cached_ok = sum(1 for a in addresses if a in cache and cache[a].get("status") == "OK")
    n_rewritten = sum(1 for a in addresses if query_for(a) != a)
    print(f"住所ユニーク数: {len(addresses)} / キャッシュ済OK: {cached_ok} / 今回問い合わせ: {len(need)}")
    if n_rewritten:
        print(f"  問い合わせ文字列を差し替える住所: {n_rewritten} 件"
              f"（geocode_resolved.json）")

    if args.dry_run:
        print("（--dry-run のためAPIは呼びません）")
        return

    api_key = os.environ.get("GOOGLE_GEOCODING_API_KEY", "").strip()
    if not api_key:
        sys.exit("環境変数 GOOGLE_GEOCODING_API_KEY が未設定です。"
                 "\n  export GOOGLE_GEOCODING_API_KEY=xxxxx を実行してから再度お試しください。")

    n_ok = n_fail = n_outside = 0
    for i, a in enumerate(need, start=1):
        q = query_for(a)
        try:
            res = geocode_one(q, api_key)
        except Exception as e:  # noqa
            res = {"status": "EXCEPTION", "lat": None, "lon": None,
                   "formatted_address": "", "location_type": "",
                   "jp_ok": False, "jp_reason": f"{type(e).__name__}: {e}"}
        # どの文字列で引いた結果かを残す（差し替えを変えたら取り直せるように）
        res["query_used"] = q
        cache[a] = res
        if q != a:
            print(f"  [差し替え] {a}\n        -> 問い合わせ: {q}\n"
                  f"        -> {res.get('formatted_address')} ({res.get('location_type')})")
        if res["status"] == "OK":
            if res["jp_ok"]:
                n_ok += 1
            else:
                n_outside += 1
                print(f"  [範囲外] {a} -> ({res['lat']},{res['lon']}) {res['jp_reason']}")
        else:
            n_fail += 1
            print(f"  [失敗] {a} -> {res['status']} {res['jp_reason']}")
        if i % 25 == 0:
            save_cache(cache)
            print(f"  ... {i}/{len(need)} 件処理")
        time.sleep(args.sleep)

    save_cache(cache)
    print(f"\n完了: OK(日本国内)={n_ok} / 範囲外={n_outside} / 失敗={n_fail}")
    print(f"キャッシュ総数: {len(cache)} -> {CACHE_PATH}")


if __name__ == "__main__":
    main()
