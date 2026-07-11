#!/usr/bin/env python3
"""
カード画像のOCR結果を cards_base.json に確定値として書き込む。

背景:
  カード記載のID（例 00-101-A001）と度分秒座標は、カード画像に印字されている。
  これらを正の情報源とするため、画像を2つのエージェントで独立に読み取り（二重読み）、
  一致したものだけを確定値として cards_base.json に書き込む。不一致は人間が確認する。

  ※ 既存の fs_card_id（画像URLから機械生成した推定ID）は不正確なため使わない。
    OCR確定値（ocr_id / ocr_lat_dms / ocr_lon_dms）を全処理の正とする。

入力:
  tools/data/ocr_raw.json      : 二重読みの生結果
    { "<card_id>": {
        "read1": {"id": "00-101-A001", "lat_dms": "35°46'34.7\"N", "lon_dms": "139°42'59.1\"E"},
        "read2": {"id": "00-101-A001", "lat_dms": "35°46'34.7\"N", "lon_dms": "139°42'59.1\"E"}
      }, ... }
  tools/data/ocr_resolved.json : 人間が不一致を解決した確定値（任意）
    { "<card_id>": {"id": "...", "lat_dms": "...", "lon_dms": "..."}, ... }
    （ocr_raw より優先される。不一致カードを人が目視で埋める用）

出力:
  tools/data/cards_base.json   : 各カードに ocr_id / ocr_lat_dms / ocr_lon_dms を追記
  tools/out/ocr_conflicts.json : read1≠read2 かつ ocr_resolved にも無い不一致カード一覧
                                 （人間がこれを見て ocr_resolved.json を埋める）

判定:
  - ocr_resolved に card_id があれば、その値を確定として採用（人間確定が最優先）
  - なければ read1 と read2 を比較し、id/lat_dms/lon_dms が完全一致なら確定
  - 一致しなければ conflicts に出力し、cards_base には書き込まない
  - 座標は geo_utils で日本範囲バリデーションし、範囲外は（一致していても）conflict 扱い

冪等: 何度実行しても同じ入力からは同じ結果。

使い方:
  python3 tools/ocr_cards.py            # ocr_raw.json を処理して cards_base.json 更新
  python3 tools/ocr_cards.py --dry-run  # 書き込まず、確定/不一致の件数のみ表示
"""
import argparse
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from geo_utils import parse_dms_string, validate_jp_latlon  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "data")
OUT = os.path.join(HERE, "out")
CARDS_PATH = os.path.join(DATA, "cards_base.json")
RAW_PATH = os.path.join(DATA, "ocr_raw.json")
RESOLVED_PATH = os.path.join(DATA, "ocr_resolved.json")
CONFLICTS_PATH = os.path.join(OUT, "ocr_conflicts.json")


def load(path, default=None):
    if not os.path.exists(path):
        return default
    return json.load(open(path, encoding="utf-8"))


def coords_ok(lat_dms, lon_dms):
    """DMS文字列2つが日本範囲内の座標としてパースできるか。"""
    lat = parse_dms_string(lat_dms)
    lon = parse_dms_string(lon_dms)
    ok, reason = validate_jp_latlon(lat, lon)
    return ok, reason


def resolve_card(card_id, raw_entry, resolved):
    """1カードのOCR結果を確定 or 不一致に分類する。

    戻り値: ("confirmed", {id, lat_dms, lon_dms})
            ("conflict", {reason, ...})
    """
    # 人間確定が最優先
    if card_id in resolved:
        r = resolved[card_id]
        ok, reason = coords_ok(r.get("lat_dms", ""), r.get("lon_dms", ""))
        if not ok:
            return "conflict", {"reason": f"人間確定値の座標NG: {reason}", "resolved": r}
        return "confirmed", {
            "id": r["id"], "lat_dms": r["lat_dms"], "lon_dms": r["lon_dms"],
        }

    if not raw_entry:
        return "conflict", {"reason": "OCR結果なし"}

    read1 = raw_entry.get("read1") or {}
    read2 = raw_entry.get("read2") or {}
    fields = ("id", "lat_dms", "lon_dms")
    mismatched = [f for f in fields if read1.get(f) != read2.get(f)]
    if mismatched:
        return "conflict", {
            "reason": f"二重読み不一致: {', '.join(mismatched)}",
            "read1": read1, "read2": read2,
        }

    # 一致 → 座標バリデーション
    ok, reason = coords_ok(read1.get("lat_dms", ""), read1.get("lon_dms", ""))
    if not ok:
        return "conflict", {
            "reason": f"座標が日本範囲外: {reason}",
            "read1": read1, "read2": read2,
        }

    return "confirmed", {
        "id": read1["id"], "lat_dms": read1["lat_dms"], "lon_dms": read1["lon_dms"],
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true",
                    help="書き込まず、確定/不一致の件数のみ表示")
    args = ap.parse_args()

    cards = load(CARDS_PATH)
    if cards is None:
        sys.exit(f"cards_base.json が見つかりません: {CARDS_PATH}")
    raw = load(RAW_PATH, default={})
    resolved = load(RESOLVED_PATH, default={})

    if not raw and not resolved:
        sys.exit(f"OCR結果がありません（{RAW_PATH} も {RESOLVED_PATH} も無い）")

    confirmed = {}
    conflicts = {}
    for card in cards:
        cid = card["card_id"]
        status, payload = resolve_card(cid, raw.get(cid), resolved)
        if status == "confirmed":
            confirmed[cid] = payload
        else:
            conflicts[cid] = payload

    print(f"対象カード: {len(cards)}")
    print(f"  確定: {len(confirmed)}")
    print(f"  不一致（要人間確認）: {len(conflicts)}")
    # 重複IDチェック（別カードが同じ ocr_id を持っていないか）
    from collections import Counter
    id_counts = Counter(v["id"] for v in confirmed.values())
    dup_ids = {k: c for k, c in id_counts.items() if c > 1}
    if dup_ids:
        print(f"  ⚠️ 確定分に重複ID: {len(dup_ids)} 種")
        for k in list(dup_ids)[:5]:
            print(f"     {k} ×{dup_ids[k]}")

    if args.dry_run:
        print("\n（--dry-run のため書き込みません）")
        if conflicts:
            print("不一致の例:")
            for cid, p in list(conflicts.items())[:5]:
                print(f"  {cid}: {p.get('reason')}")
        return

    # cards_base.json に確定値を追記
    for card in cards:
        cid = card["card_id"]
        if cid in confirmed:
            c = confirmed[cid]
            card["ocr_id"] = c["id"]
            card["ocr_lat_dms"] = c["lat_dms"]
            card["ocr_lon_dms"] = c["lon_dms"]
    with open(CARDS_PATH, "w", encoding="utf-8") as f:
        json.dump(cards, f, ensure_ascii=False, indent=2)
    print(f"\ncards_base.json を更新（{len(confirmed)} 件に ocr_* を追記）")

    # 不一致を人間確認用に出力
    os.makedirs(OUT, exist_ok=True)
    with open(CONFLICTS_PATH, "w", encoding="utf-8") as f:
        json.dump(conflicts, f, ensure_ascii=False, indent=2)
    if conflicts:
        print(f"不一致 {len(conflicts)} 件 -> {CONFLICTS_PATH}")
        print(f"  → 目視で確認し、{RESOLVED_PATH} に確定値を書いて再実行してください。")
    else:
        # 不一致ゼロなら空ファイルを残す（前回分の掃除）
        print("不一致なし。全カードが確定しました。")


if __name__ == "__main__":
    main()
