#!/usr/bin/env python3
"""
gk-p.jp のマンホールカード一覧HTMLをパースし、カード基礎データを cards_base.json に出力する。

対象: tools/data/zenkoku.html （https://www.gk-p.jp/mhcard/?pref=zenkoku を保存したもの）
テーブル: <table class="table1 cr"> 全1265行 / 1行=1カード / 7列固定
  列: [0]市町村 [1]カード画像 [2]弾数 [3]発行年月日 [4]配布場所 [5]配布時間 [6]在庫状況

出力される各カードのフィールド:
  card_id            : 連番ゼロ埋め (card_0001 ...)
  pref_code          : 画像ファイル名先頭2桁 (00=国機関, 01=北海道 ... 47=沖縄)
  prefecture         : 都道府県名（pref_code から解決。00 は空文字）
  municipality       : 自治体名（整理番号・注記を除いた本体）
  serial             : 整理番号（例 A001。無ければ空文字）
  edition            : 弾数（例 第17弾）
  issued_date        : 発行年月日（YYYY/MM/DD の生テキスト）
  image_url          : 正規化後の画像URL（https化・末尾ゴミ除去・拡張子補完）
  image_url_raw      : HTML中の生 src
  distribution_html  : 配布場所セルの生HTML（後段でAI構造化する）
  distribution_time  : 配布時間セルのテキスト（brは改行に）
  stock_html         : 在庫状況セルの生HTML
  stock_text         : 在庫状況セルのテキスト

このスクリプトはネットワークアクセスしない。純粋にHTML→JSON。冪等。
"""
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
HTML_PATH = os.path.join(HERE, "data", "zenkoku.html")
OUT_PATH = os.path.join(HERE, "data", "cards_base.json")

# 画像ファイル名先頭2桁 -> 都道府県名。00 は国の機関（都道府県なし）。
PREF_BY_CODE = {
    "00": "",  # 国の機関・全国組織
    "01": "北海道", "02": "青森県", "03": "岩手県", "04": "宮城県", "05": "秋田県",
    "06": "山形県", "07": "福島県", "08": "茨城県", "09": "栃木県", "10": "群馬県",
    "11": "埼玉県", "12": "千葉県", "13": "東京都", "14": "神奈川県", "15": "新潟県",
    "16": "富山県", "17": "石川県", "18": "福井県", "19": "山梨県", "20": "長野県",
    "21": "岐阜県", "22": "静岡県", "23": "愛知県", "24": "三重県", "25": "滋賀県",
    "26": "京都府", "27": "大阪府", "28": "兵庫県", "29": "奈良県", "30": "和歌山県",
    "31": "鳥取県", "32": "島根県", "33": "岡山県", "34": "広島県", "35": "山口県",
    "36": "徳島県", "37": "香川県", "38": "愛媛県", "39": "高知県", "40": "福岡県",
    "41": "佐賀県", "42": "長崎県", "43": "熊本県", "44": "大分県", "45": "宮崎県",
    "46": "鹿児島県", "47": "沖縄県",
}


def strip_tags_to_text(html):
    """br系を改行に、その他タグを除去してテキスト化。連続改行/空白を整理。"""
    t = re.sub(r"<br\s*/?>", "\n", html, flags=re.I)
    t = re.sub(r"<[^>]+>", "", t)
    # HTMLエンティティの最低限
    t = (t.replace("&amp;", "&").replace("&nbsp;", " ")
          .replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", '"'))
    lines = [ln.strip() for ln in t.split("\n")]
    lines = [ln for ln in lines if ln]  # 空行除去
    return "\n".join(lines).strip()


def normalize_image_url(raw):
    """
    生srcを正規化:
      - http -> https
      - 末尾の余分な '.' や空白を除去
      - 拡張子が無い場合 .jpg を補完
    実在性はここでは判定しない（DL時に404判定）。
    """
    url = raw.strip()
    url = re.sub(r"^http://", "https://", url, flags=re.I)
    url = url.rstrip(". \t")  # 末尾のピリオド・空白
    # uploads/mhc/ 以降のファイル名に拡張子が無ければ .jpg 補完
    if re.search(r"uploads/mhc/[^/]+$", url) and not re.search(r"\.(jpg|jpeg|png)$", url, re.I):
        url = url + ".jpg"
    return url


def parse_municipality(cell_html):
    """
    市町村セルから (自治体名, 整理番号) を取り出す。
    例:
      '日本下水道事業団'              -> ('日本下水道事業団', '')
      '札幌市<BR>（A001）'            -> ('札幌市', 'A001')
      '旭川市<br />\n(A001)'         -> ('旭川市', 'A001')
      'UR都市機構<br />\n(B001)'     -> ('UR都市機構', 'B001')
      '埼玉県 （流域下水道・A001）'    -> ('埼玉県 （流域下水道）', 'A001')
    整理番号は英大文字+数字（例 A001, B001, AA01 など）。括弧内に補足テキスト＋
    「・」区切りで整理番号が入る形式にも対応する。
    """
    text = strip_tags_to_text(cell_html)
    serial = ""
    # 整理番号トークン（英字1-3 + 数字2-4）を、括弧内の任意位置から抽出。
    # 例: （A001） / (B001) / （流域下水道・A001）
    m = re.search(r"[（(][^（）()]*?([A-Za-z]{1,3}\d{2,4})\s*[）)]", text)
    if m:
        serial = m.group(1).upper()
        # 括弧内から整理番号トークン（と直前の区切り「・」）だけを除去し、補足テキストは残す
        def _clean(mo):
            inner = mo.group(1)
            inner = re.sub(r"[・･]?\s*[A-Za-z]{1,3}\d{2,4}\s*", "", inner)
            inner = inner.strip("・･ 　")
            return f"（{inner}）" if inner else ""
        name = re.sub(r"[（(]([^（）()]*)[）)]", _clean, text)
    else:
        name = text
    name = name.replace("\n", " ").strip()
    name = re.sub(r"\s+", " ", name)
    return name, serial


def main():
    if not os.path.exists(HTML_PATH):
        sys.exit(f"HTMLが見つかりません: {HTML_PATH}")
    html = open(HTML_PATH, encoding="utf-8", errors="replace").read()

    m = re.search(r'<table[^>]*class="[^"]*table1[^"]*cr[^"]*"[^>]*>(.*?)</table>', html, re.S)
    if not m:
        sys.exit("table1 cr が見つかりません")
    body = m.group(1)
    rows = [r for r in re.findall(r"<tr[^>]*>(.*?)</tr>", body, re.S) if "<td" in r]

    cards = []
    warnings = []
    for i, r in enumerate(rows, start=1):
        tds = re.findall(r"<td[^>]*>(.*?)</td>", r, re.S)
        if len(tds) != 7:
            warnings.append(f"row {i}: 列数が7でない ({len(tds)})")
            continue

        muni_cell, img_cell, edi_cell, date_cell, dist_cell, time_cell, stock_cell = tds

        municipality, serial = parse_municipality(muni_cell)

        msrc = re.search(r'<img[^>]*src="([^"]+)"', img_cell, re.I)
        raw_url = msrc.group(1).strip() if msrc else ""
        image_url = normalize_image_url(raw_url) if raw_url else ""

        pref_code = ""
        mcode = re.search(r"uploads/mhc/(\d{2})-", image_url)
        if mcode:
            pref_code = mcode.group(1)
        prefecture = PREF_BY_CODE.get(pref_code, "")
        if pref_code and pref_code not in PREF_BY_CODE:
            warnings.append(f"row {i}: 未知の都道府県コード {pref_code}")

        card = {
            "card_id": f"card_{i:04d}",
            "row_index": i,
            "pref_code": pref_code,
            "prefecture": prefecture,
            "municipality": municipality,
            "serial": serial,
            "edition": strip_tags_to_text(edi_cell),
            "issued_date": strip_tags_to_text(date_cell),
            "image_url": image_url,
            "image_url_raw": raw_url,
            "distribution_html": dist_cell.strip(),
            "distribution_time": strip_tags_to_text(time_cell),
            "stock_html": stock_cell.strip(),
            "stock_text": strip_tags_to_text(stock_cell),
        }
        cards.append(card)

    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(cards, f, ensure_ascii=False, indent=2)

    print(f"パース完了: {len(cards)} 件 -> {OUT_PATH}")
    # サマリ
    from collections import Counter
    by_pref = Counter(c["prefecture"] or "(国機関)" for c in cards)
    print(f"都道府県数: {len([k for k in by_pref if k != '(国機関)'])}")
    print(f"整理番号あり: {sum(1 for c in cards if c['serial'])} / {len(cards)}")
    missing_serial_muni = sum(1 for c in cards if not c["municipality"])
    if missing_serial_muni:
        print(f"警告: 自治体名が空の行 {missing_serial_muni} 件")
    if warnings:
        print(f"\n=== 警告 {len(warnings)}件 ===")
        for w in warnings[:20]:
            print("  ", w)


if __name__ == "__main__":
    main()
