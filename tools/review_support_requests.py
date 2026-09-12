#!/usr/bin/env python3
"""アプリ利用者から届いた要望（Google Forms の回答CSV）を、master 更新で確認すべき
「カード単位の宿題」に変換する。

なぜ要るのか:
  master は gk-p.jp をそのまま写して作る。だが gk-p.jp 側の更新が遅れることがあり
  （配布終了が反映されていない等）、サイトだけ見ていると現地の実態とズレる。
  「配布中の表示を信じて遠方から行ったら終了していた」という申告が実際に来ている。
  利用者の申告は**サイトとは独立した情報源**なので、master を作る前に必ず突き合わせる。

  ただし**申告をそのまま master に書かない**。申告は「gk-p.jp を見に行く理由」であって、
  真偽の判定は gk-p.jp の該当ページと、必要ならカード画像を見て行う。
  情報源は gk-p.jp のみ、という原則は変えない。

対象期間:
  前回 master を発行した日（tools/master_releases.json の最新 released_at）以降。
  それ以前の申告は、その master で対応済みとみなす。--since で上書きできる。

入力CSV:
  Google Forms の回答をダウンロードしたもの。列名は自動判定する
  （タイムスタンプ / 問い合わせ内容を選択… / 詳細 / メールアドレス）。
  ※ CSV にはメールアドレスが入る。既定では出力しない（--show-email で表示）。
    置き場所は tools/data/（.gitignore 済み）にすること。リポジトリに commit しない。

出力:
  A. カードを特定できた申告  … 該当カードの現在の master 値を並べて表示する
  B. データの話だがカード未特定 … 人が読んで判断する
  C. それ以外（アプリの機能要望・不具合報告に見えるもの） … 参考表示

  --out を付けると同じ内容を JSON で書き出す。

使い方:
  python3 tools/review_support_requests.py --csv tools/data/support_requests.csv
  python3 tools/review_support_requests.py --csv ~/Downloads/xxx.csv --since 2026-07-29
  python3 tools/review_support_requests.py --csv tools/data/support_requests.csv \
      --out tools/data/support_review.json
"""
import argparse
import csv
import datetime
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "data")
CARDS_PATH = os.path.join(DATA, "cards_base.json")
RELEASES_PATH = os.path.join(HERE, "master_releases.json")

# Google Forms のタイムスタンプ: "2026/08/09 12:11:00 午後 GMT+9"
TS_RE = re.compile(r"(\d{4})/(\d{1,2})/(\d{1,2})\s+(\d{1,2}):(\d{2}):(\d{2})\s*(午前|午後|AM|PM)?")

# カード記載ID（例 09-208-B001）と、その省略形（例 09-208-B）
CARD_ID_RE = re.compile(r"\b(\d{2}-\d{3}-[A-Z]\d{3})\b")
CARD_ID_LOOSE_RE = re.compile(r"\b(\d{2}-\d{3}-[A-Z])\b")

# 申告を「master のどの工程で確かめるか」に振り分けるための手掛かり。
# あくまで人が読む前の仕分け。判定はしない。
TOPIC_RULES = [
    ("在庫状況（手順6で確認）",
     # 「配布は終了したとのこと」のように語が離れる書き方があるので少し間を許す
     re.compile(r"配布[^。\n]{0,4}(終了|中止|停止|休止|再開)|終了(しました|したとのこと|して(い)?ました)|"
                r"配布していな|配布しておりません|配布は終わ|もらえなかった|在庫")),
    ("カードの欠落・追加（手順1で確認）",
     # 「感謝しかありません」のような挨拶に当たらないよう、カード/データの文脈を要求する
     re.compile(r"(カード|マンホール|リスト|一覧|データ|情報)[^。\n]{0,12}"
                r"(ありません|ございません|見当たら|抜け|載って(い)?ない|掲載されて|不足)|"
                r"抜けて(い)?ます|もう一枚|新し(い|く)カード")),
    ("カード記載ID（手順5で確認）",
     re.compile(r"カード番号|番号(の)?誤|IDが|ID(の)?誤|違う番号")),
    ("配布場所の情報・座標（手順6/7で確認）",
     re.compile(r"配布場所|受け取|移転|住所|場所が(違|異)|場所の表示|ずれて|ズレて|"
                r"表示場所|別の場所")),
    ("マンホールの座標（手順9で確認）",
     re.compile(r"設置場所|マンホールの場所|蓋の場所|座標|緯度|経度")),
    ("カードのデザイン・画像（手順4で確認）",
     re.compile(r"デザインが違|画像が違|別のカード|写真が違")),
]

# 「master のデータではなくアプリ側の話」に見えるものの手掛かり。
# 除外はしない（C に振り分けて必ず目に入るようにする）。
APP_SIDE_RE = re.compile(
    r"表示されな|表示されませ|出てこな|映らな|アップデート|update|"
    r"カラー|白黒|色が|アイコン|バッジ|動きません|落ちる|クラッシュ|"
    r"機能|欲しい|ほしい|メモ|お気に入り|見にく|使いやす")

# 自治体名から落として照合する接尾辞（「加須C」「那須烏山C」のような書き方に当てるため）
SUFFIXES = ("市", "町", "村", "区", "郡")


def parse_ts(s):
    m = TS_RE.search(s or "")
    if not m:
        return None
    y, mo, d, h, mi, se, ap = m.groups()
    h = int(h)
    if ap in ("午後", "PM"):
        h = h % 12 + 12
    elif ap in ("午前", "AM"):
        h = h % 12
    try:
        return datetime.datetime(int(y), int(mo), int(d), h, int(mi), int(se))
    except ValueError:
        return None


def last_release():
    """master_releases.json の最新リリース（version, released_at）。無ければ None。"""
    if not os.path.exists(RELEASES_PATH):
        return None
    try:
        rel = json.load(open(RELEASES_PATH, encoding="utf-8")).get("releases") or []
    except Exception:  # noqa
        return None
    rel = [r for r in rel if r.get("released_at")]
    if not rel:
        return None
    return sorted(rel, key=lambda r: r["released_at"])[-1]


def pick_columns(fieldnames):
    """CSV の列名からタイムスタンプ / 分類 / 詳細 / メールの列を推定する。"""
    def find(*keys):
        for name in fieldnames:
            for k in keys:
                if k in name:
                    return name
        return None
    ts = find("タイムスタンプ", "Timestamp") or fieldnames[0]
    cat = find("問い合わせ内容を選択", "選択")
    detail = find("詳細", "内容を記入")
    email = find("メールアドレス", "Email")
    if detail is None:
        # 最後の列を詳細とみなす（Forms の並び）
        detail = fieldnames[-1]
    return ts, cat, detail, email


def build_place_index(cards):
    """(自治体名そのまま, 接尾辞を落とした形) の2つの索引を返す。

    2段構えにするのは誤爆を防ぐため。接尾辞を落とした形だけで引くと
    「戸田市役所休みの場合のさくらパル…」の "さくら" が さくら市 に当たってしまう。
    まず「戸田市」のような完全形で引き、当たらなかったときだけ短い形を試す
    （「加須C配布終了です」「那須烏山C配布終了です」のような書き方を拾うため）。
    """
    full, stem = {}, {}
    for c in cards:
        name = (c.get("municipality") or "").strip()
        if not name:
            continue
        full.setdefault(name, []).append(c)
        for suf in SUFFIXES:
            if name.endswith(suf) and len(name) - len(suf) >= 2:
                stem.setdefault(name[:-len(suf)], []).append(c)
    return full, stem


def _match_by_name(text, index):
    """索引に載っている地名が本文に含まれるカードを集める（長い名前から見る）。"""
    hits = []
    for name in sorted(index, key=len, reverse=True):
        if name in text:
            for c in index[name]:
                if c not in hits:
                    hits.append(c)
    return hits


def match_cards(text, cards_by_ocr_id, place_index):
    """申告文からカードを特定する。(matched_cards, how) を返す。

    確度の高い手掛かりから順に試し、当たった時点で打ち切る:
      カード記載ID > 枝番省略のID > 自治体名（完全形）> 自治体名（接尾辞なし）
    """
    full_index, stem_index = place_index

    hits = []
    for cid in CARD_ID_RE.findall(text):
        c = cards_by_ocr_id.get(cid)
        if c and c not in hits:
            hits.append(c)
    if hits:
        return hits, "カード記載ID"

    for stem in CARD_ID_LOOSE_RE.findall(text):
        for cid, c in cards_by_ocr_id.items():
            if cid.startswith(stem) and c not in hits:
                hits.append(c)
    if hits:
        return hits, "カード記載ID（枝番省略）"

    hits = _match_by_name(text, full_index)
    if hits:
        return hits, "自治体名"

    hits = _match_by_name(text, stem_index)
    if hits:
        return hits, "自治体名（接尾辞なし・誤爆しうる）"

    return [], None


def topics_of(text):
    return [label for label, rx in TOPIC_RULES if rx.search(text)]


def card_summary(c):
    return {
        "card_id": c.get("card_id"),
        "ocr_id": c.get("ocr_id"),
        "prefecture": c.get("prefecture"),
        "municipality": c.get("municipality"),
        "edition": c.get("edition"),
        "dist_state": c.get("dist_state"),
        "dist_addresses": c.get("dist_addresses") or [],
        "ocr_lat_dms": c.get("ocr_lat_dms"),
        "ocr_lon_dms": c.get("ocr_lon_dms"),
        "source_page": c.get("source_url") or c.get("page_url"),
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", required=True,
                    help="Google Forms の回答CSV（tools/data/ に置く。commit しないこと）")
    ap.add_argument("--since", default=None,
                    help="この日以降の申告を対象にする（YYYY-MM-DD）。"
                         "省略時は master_releases.json の最新 released_at")
    ap.add_argument("--cards", default=CARDS_PATH,
                    help="カードJSON（既定 tools/data/cards_base.json）")
    ap.add_argument("--out", default=None, help="仕分け結果を JSON で書き出す")
    ap.add_argument("--show-email", action="store_true",
                    help="申告者のメールアドレスも表示する（既定は伏せる）")
    args = ap.parse_args()

    # ---- 対象期間 ----
    rel = last_release()
    if args.since:
        since_str = args.since
        since_src = "--since 指定"
    elif rel:
        since_str = rel["released_at"]
        since_src = f"master {rel['version']} の発行日（master_releases.json）"
    else:
        sys.exit("対象期間が決まりません。--since を指定するか "
                 "tools/master_releases.json に前回の発行日を記録してください。")
    try:
        since = datetime.datetime.strptime(since_str, "%Y-%m-%d")
    except ValueError:
        sys.exit(f"--since は YYYY-MM-DD で指定してください: {since_str!r}")

    # ---- 入力 ----
    if not os.path.exists(args.csv):
        sys.exit(f"CSV が見つかりません: {args.csv}")
    cards = []
    if os.path.exists(args.cards):
        cards = json.load(open(args.cards, encoding="utf-8"))
    else:
        print(f"⚠️ カードJSON が見つかりません（{args.cards}）。カード特定はスキップします")
    cards_by_ocr_id = {c["ocr_id"]: c for c in cards if c.get("ocr_id")}
    place_index = build_place_index(cards)   # (完全形, 接尾辞なし)

    with open(args.csv, encoding="utf-8-sig", newline="") as f:
        rows = list(csv.DictReader(f))
    if not rows:
        sys.exit(f"CSV に行がありません: {args.csv}")
    ts_col, cat_col, detail_col, email_col = pick_columns(list(rows[0].keys()))

    print(f"CSV            : {args.csv}（{len(rows)} 件）")
    print(f"対象期間       : {since_str} 以降  （{since_src}）")
    print(f"カードJSON     : {len(cards)} 件 / ocr_id 確定 {len(cards_by_ocr_id)} 件")
    print()

    group_a, group_b, group_c = [], [], []
    n_old = n_unparsed = 0
    for r in rows:
        ts = parse_ts(r.get(ts_col, ""))
        if ts is None:
            n_unparsed += 1
            continue
        if ts < since:
            n_old += 1
            continue
        detail = (r.get(detail_col) or "").strip()
        category = (r.get(cat_col) or "").strip() if cat_col else ""
        text = f"{category}\n{detail}"
        matched, how = match_cards(detail, cards_by_ocr_id, place_index)
        topics = topics_of(text)
        item = {
            "timestamp": ts.strftime("%Y-%m-%d %H:%M"),
            "category": category,
            "detail": detail,
            "topics": topics,
            "matched_by": how,
            "cards": [card_summary(c) for c in matched],
        }
        if args.show_email and email_col:
            item["email"] = (r.get(email_col) or "").strip()
        if matched:
            group_a.append(item)
        elif topics:
            group_b.append(item)
        else:
            group_c.append(item)

    def dump(title, items, note):
        print("=" * 78)
        print(f"{title}: {len(items)} 件")
        print(note)
        print("=" * 78)
        for it in items:
            print(f"\n[{it['timestamp']}] {it['category']}")
            for line in it["detail"].splitlines():
                print(f"  {line}")
            if it.get("email"):
                print(f"  (返信先: {it['email']})")
            if it["topics"]:
                print(f"  観点: {' / '.join(it['topics'])}")
            for c in it["cards"]:
                print(f"  → {c['ocr_id']} {c['prefecture']}{c['municipality']} "
                      f"({c['edition']})  現在: dist_state={c['dist_state']} "
                      f"配布場所{len(c['dist_addresses'])}件")
                for a in c["dist_addresses"][:3]:
                    print(f"       住所: {a}")
                print(f"       座標: {c['ocr_lat_dms']} {c['ocr_lon_dms']}")
                if c.get("source_page"):
                    print(f"       gk-p: {c['source_page']}")
        print()

    dump("A. カードを特定できた申告（gk-p.jp の該当ページを必ず開いて確認する）", group_a,
         "  現在の値は前回 master 時点のもの。申告と食い違うならサイトを見て真偽を判断する。")
    dump("B. データの話だがカードを特定できなかった申告（人が読んで判断する）", group_b,
         "  自治体名が書かれていない・複数にまたがる等。放置せず1件ずつ当たること。")
    dump("C. その他（アプリの機能要望・不具合報告に見えるもの。master とは別件）", group_c,
         "  master 更新の対象外だが、データ起因が紛れていることがあるので目は通す。")

    print("-" * 78)
    print(f"対象期間内 {len(group_a) + len(group_b) + len(group_c)} 件 "
          f"（A={len(group_a)} / B={len(group_b)} / C={len(group_c)}）")
    print(f"対象期間より前でスキップ: {n_old} 件"
          + (f" / タイムスタンプを解釈できず: {n_unparsed} 件" if n_unparsed else ""))
    print("※ A・B は gk-p.jp を見て真偽を確かめる。申告をそのまま master に書かないこと。")
    print("※ gk-p.jp が申告どおりに直っていない場合は master も直さない"
          "（サイトが正）。判断に迷うものは記録して次回持ち越す。")

    if args.out:
        with open(args.out, "w", encoding="utf-8") as f:
            json.dump({
                "since": since_str,
                "since_source": since_src,
                "csv": os.path.abspath(args.csv),
                "groups": {"a_matched": group_a, "b_data_unmatched": group_b, "c_other": group_c},
            }, f, ensure_ascii=False, indent=2)
        print(f"\n書き出し: {args.out}")


if __name__ == "__main__":
    main()
