#!/usr/bin/env python3
"""
配布場所の住所と在庫状況（distribution_state）を AI 抽出結果から確定し、
cards_base.json に書き込む。

背景:
  gk-p.jp の「配布場所」欄は施設名・リンク・住所・電話・問合せ先・注記が
  混在した HTML で、正規表現では住所を正しく取り出せない（施設名や問合せ先を
  誤って住所と判定する）。地図マーカーの座標を誤ると実害が大きいため、
  カード画像の OCR と同様に AI で抽出し、二重読みで検証する。

  在庫状況（distribution_state）も同じ AI パスで分類し、さらにキーワードルールで
  独立に判定して相互検算する（AI とルールが食い違ったら人間が確認）。

distribution_state の分類ルール（ユーザー定義）:
  - 「こちらからご確認ください」等 …………… distributing
  - 「（電話番号）までお問い合わせください」等 … notClear
  - 「配布終了」「一時中止」等 ………………… stopped
  ※ 停止と問合せが併記される場合は stopped を優先する。

入力:
  tools/data/dist_raw.json      : 二重読みの生結果
    { "<card_id>": {
        "read1": {"addresses": ["東京都北区赤羽台1-4-50", ...], "state": "distributing"},
        "read2": {"addresses": [...], "state": "distributing"}
      }, ... }
  tools/data/dist_resolved.json : 人間が不一致を解決した確定値（任意・最優先）
    { "<card_id>": {"addresses": [...], "state": "..."}, ... }

出力:
  tools/data/cards_base.json    : 各カードに dist_addresses / dist_state を追記
  tools/out/dist_conflicts.json : 不一致カード（二重読みズレ / AI とルールの食い違い）

判定:
  - dist_resolved に card_id があれば、その値を確定として採用（人間確定が最優先）
  - なければ read1 と read2 を比較し、addresses（順序無視）と state が一致すれば候補
  - さらにキーワードルールで state を独立判定し、AI と食い違えば conflict
    （ルールが分類不能な表現は AI を採用する。ルールの取りこぼしを AI が補う）

冪等: 同じ入力からは同じ結果。

使い方:
  python3 tools/extract_distribution.py --dry-run  # 確定/不一致の件数のみ
  python3 tools/extract_distribution.py            # cards_base.json を更新
"""
import argparse
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "data")
OUT = os.path.join(HERE, "out")
CARDS_PATH = os.path.join(DATA, "cards_base.json")
RAW_PATH = os.path.join(DATA, "dist_raw.json")
RESOLVED_PATH = os.path.join(DATA, "dist_resolved.json")
CONFLICTS_PATH = os.path.join(OUT, "dist_conflicts.json")

STATES = ("distributing", "stopped", "notClear")


def load(path, default=None):
    if not os.path.exists(path):
        return default
    return json.load(open(path, encoding="utf-8"))


def rule_state(stock_text):
    """在庫状況テキストからキーワードで state を判定する。

    AI 分類との相互検算に使う。判定できない表現は None を返す
    （その場合は AI の分類を採用する）。

    優先順位（重要）:
      1. stopped      … 配布終了・中止。他の表現と併記されても停止が優先。
      2. distributing … 「こちらからご確認ください」= 在庫確認リンクがある。
                        問合せ先が併記されていても、確認手段があるので配布中。
      3. notClear     … 確認リンクが無く、電話で問い合わせるしか手段がない。
    """
    t = (stock_text or "").strip()
    if not t:
        return None
    if ("配布終了" in t or "一時中止" in t or "配布を中止" in t
            or "配布しておりません" in t or "配布は終了" in t):
        return "stopped"
    if "こちらからご確認" in t or "こちらから確認" in t:
        return "distributing"
    if ("お問い合わせください" in t or "お問合せください" in t
            or "お問合わせください" in t or "ご連絡ください" in t
            or "問い合わせ先" in t or "問合せ先" in t):
        return "notClear"
    return None


def norm_addresses(addrs):
    """住所リストを比較用に正規化（前後空白除去・順序無視のためソート）。"""
    return sorted((a or "").strip() for a in (addrs or []) if (a or "").strip())


def resolve_card(card, raw_entry, resolved):
    """1カードの抽出結果を確定 or 不一致に分類する。

    戻り値: ("confirmed", {addresses, state})
            ("conflict", {reason, ...})
    """
    cid = card["card_id"]

    # 人間確定が最優先
    if cid in resolved:
        r = resolved[cid]
        st = r.get("state")
        if st not in STATES:
            return "conflict", {"reason": f"人間確定値の state が不正: {st!r}"}
        return "confirmed", {
            "addresses": norm_addresses(r.get("addresses")), "state": st,
        }

    if not raw_entry:
        return "conflict", {"reason": "AI抽出結果なし"}

    read1 = raw_entry.get("read1") or {}
    read2 = raw_entry.get("read2") or {}

    a1 = norm_addresses(read1.get("addresses"))
    a2 = norm_addresses(read2.get("addresses"))
    s1 = read1.get("state")
    s2 = read2.get("state")

    if a1 != a2:
        return "conflict", {
            "reason": "二重読み不一致: addresses",
            "read1_addresses": a1, "read2_addresses": a2,
        }
    if s1 != s2:
        return "conflict", {
            "reason": "二重読み不一致: state",
            "read1_state": s1, "read2_state": s2,
        }
    if s1 not in STATES:
        return "conflict", {"reason": f"state が不正: {s1!r}"}

    # ルールとの相互検算。ルールが判定できた場合のみ突き合わせる。
    rs = rule_state(card.get("stock_text"))
    if rs is not None and rs != s1:
        return "conflict", {
            "reason": f"AIとルールの不一致: AI={s1} / ルール={rs}",
            "stock_text": (card.get("stock_text") or "")[:120],
        }

    return "confirmed", {"addresses": a1, "state": s1}


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
        sys.exit(f"AI抽出結果がありません（{RAW_PATH} も {RESOLVED_PATH} も無い）")

    confirmed = {}
    conflicts = {}
    for card in cards:
        cid = card["card_id"]
        status, payload = resolve_card(card, raw.get(cid), resolved)
        if status == "confirmed":
            confirmed[cid] = payload
        else:
            conflicts[cid] = payload

    from collections import Counter
    st_counts = Counter(v["state"] for v in confirmed.values())
    n_addr = sum(len(v["addresses"]) for v in confirmed.values())
    no_addr = sum(1 for v in confirmed.values() if not v["addresses"])

    print(f"対象カード: {len(cards)}")
    print(f"  確定: {len(confirmed)}")
    print(f"  不一致（要人間確認）: {len(conflicts)}")
    print(f"  distribution_state: {dict(st_counts)}")
    print(f"  抽出住所: 延べ {n_addr} / 住所0件のカード {no_addr}")

    if args.dry_run:
        print("\n（--dry-run のため書き込みません）")
        if conflicts:
            print("不一致の例:")
            for cid, p in list(conflicts.items())[:5]:
                print(f"  {cid}: {p.get('reason')}")
        return

    for card in cards:
        cid = card["card_id"]
        if cid in confirmed:
            c = confirmed[cid]
            card["dist_addresses"] = c["addresses"]
            card["dist_state"] = c["state"]
    with open(CARDS_PATH, "w", encoding="utf-8") as f:
        json.dump(cards, f, ensure_ascii=False, indent=2)
    print(f"\ncards_base.json を更新（{len(confirmed)} 件に dist_* を追記）")

    os.makedirs(OUT, exist_ok=True)
    with open(CONFLICTS_PATH, "w", encoding="utf-8") as f:
        json.dump(conflicts, f, ensure_ascii=False, indent=2)
    if conflicts:
        print(f"不一致 {len(conflicts)} 件 -> {CONFLICTS_PATH}")
        print(f"  → 目視で確認し、{RESOLVED_PATH} に確定値を書いて再実行してください。")
    else:
        print("不一致なし。全カードが確定しました。")


if __name__ == "__main__":
    main()
