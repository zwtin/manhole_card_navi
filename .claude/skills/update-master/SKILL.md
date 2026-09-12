---
name: update-master
description: gk-p.jp の最新マンホールカードデータで新しい master バージョンを発行する。全カード画像を gk-p.jp から取得し、カード記載のID・座標を二重OCRで正確に読み取り、利用者からの申告と突き合わせ、画像を Cloudflare R2 と Firebase Hosting の2か所に配置し、master データを Firestore に投入するまでの一連の作業を行う。マンホールカードの新弾が出たとき（約3ヶ月ごと）のリリース作業で使う。
---

# update-master — 新 master バージョンの発行

gk-p.jp の最新データで、画像（Cloudflare R2 + Firebase Hosting）と master データ（Firestore）を
新バージョンに更新する。

## このスキルの原則（重要）

**情報源は gk-p.jp のサイトのみ。人力データや機械推定は使わない。**
過去に人力で付けたIDには誤りと重複があり、画像URLからの推定も不正確だったため、
すべて**サイトから取得し、AI/OCR で確定し、二重読みで検証する**。

| データ | 取得方法 |
|---|---|
| カード記載ID（例 `00-101-A001`） | **カード画像のOCR**（二重読み） |
| マンホールの度分秒座標 | **カード画像のOCR**（二重読み） |
| 配布場所の住所 | **配布場所HTMLからAI抽出**（二重読み） |
| 在庫状況（配布中/停止/不明） | **AI分類＋キーワードルールで相互検算** |
| 配布場所の緯度経度 | 住所を Google Geocoding API で変換 |

**利用者からの申告は「サイトを見に行く理由」として使う（手順2・手順8）。**
gk-p.jp 側の更新が遅れて、現地の実態とサイトがズレることがある。利用者の申告は
サイトとは独立した情報源なので必ず突き合わせる。ただし**申告をそのまま master に書かない**。
真偽は gk-p.jp の該当ページ（必要ならカード画像）を見て判断する。上の原則は変えない。

**master は毎回まるごと再生成する。** 既存 master を引き継がないので、弾の追加・カードの
増減・在庫状況の変化がすべて自動で反映される。

**バージョン番号をどこにもハードコードしない。** 手順0 の `master_version.py` で毎回調べる。
手順書に「次は 0007」と書くと発行のたびに書き換えが要るうえ、書き換え忘れると
1つ前のバージョンを上書きしてしまう。以下 `{VERSION}` と表記する。

**`card_id` は恒久IDではない。** `parse_cards.py` が振る `card_id`（`card_0001`…）は
gk-p.jp の行順の連番にすぎない。新弾のカードは都道府県ごとの途中に挿入されるため、
**新弾が出ると挿入位置より後ろの card_id が全部シフトする**（0004 発行時は24枚の追加で
1265件中1231件がズレた）。前回の中間成果物（OCR結果・配布場所抽出・DL済み画像）を
そのまま使い回すと、**カードと画像・座標の対応が入れ替わる**。しかも二重OCRでは検出できない。
再パースしたら必ず手順3の移送を先に通す。カードの恒久的な同一性は **`image_url`** で判断する。

**画像は同じパスで2か所に置く（主系と代替）。**

| | 配信元 | master のフィールド | アプリの使い方 |
|---|---|---|---|
| 主系 | Cloudflare R2（egress 無料） | `image_url` | 常にこちらを先に引く |
| 代替 | Firebase Hosting（`*.web.app`） | `image_sub_url` | 主系の取得に失敗したときだけ |

パス（`master/v{VERSION}/images/{ID}.jpg`）は両者で完全に同一で、URL のベース部分だけが違う。
R2 の配信ドメイン `cdn.manholecardnavi.com` が経路上のフィルタリング装置に遮断される端末が
あるため（新規取得ドメインでカテゴリ未分類。`*.web.app` は Google のドメインなので許可
リストに入っている）。**両方に置き、master に両方のURLを入れること。** 片方でも欠けると、
遮断されている利用者には画像が出ないままになる。

**master 構造（3コレクション）**:
- `cards/{ocr_id}` — 自治体名・都道府県ID・弾ID・発行日・マンホール座標(GeoPoint)・
  画像URL（`image_url` = R2 / `image_sub_url` = Hosting、いずれも配信フルURL）・
  配布場所HTML・配布場所座標(GeoPoint配列)・配布時間HTML・在庫状況HTML・配布状態
- `prefectures/{id}` — 都道府県マスタ
- `volumes/{id}` — 弾マスタ

配布場所は施設名/住所/電話の分離をせず、**HTMLのまま保持してアプリで表示**する。
地図表示に必要な座標だけを別途持つ。

## 前提

- 作業ディレクトリ: `/Users/zwtin/Documents/github/manhole_card_navi`
- 画像の配置先（定義は `tools/r2_utils.py` / `tools/hosting_utils.py`。dev / prod で分かれている）:
  - 主系 Cloudflare R2（バケットと配信ドメイン）
  - 代替 Firebase Hosting（別リポジトリのローカルディレクトリに置いて `firebase deploy`）
- 認証:
  - `gcloud auth login` … Firestore 投入・Remote Config の読み取り
  - `firebase login` … Hosting へのデプロイ
  - R2 の認証情報を環境変数で渡す（`~/.zshenv` などに export しておく。**リポジトリには置かない**）:
    `R2_ACCOUNT_ID` / `R2_ACCESS_KEY_ID` / `R2_SECRET_ACCESS_KEY`
  - `boto3` と `Pillow` が必要（未導入なら `pip3 install --user boto3 Pillow`）
  - `GOOGLE_GEOCODING_API_KEY`（`~/.zshenv` に設定済み）

## 手順

### 0. バージョン番号と対象を確認

**番号は必ず実地で調べる。** Firestore・R2・Hosting を見て、次の番号を算出する。

```bash
cd /Users/zwtin/Documents/github/manhole_card_navi
python3 tools/master_version.py --project prod
python3 tools/master_version.py --project dev
```

- 「次のバージョン」として出た値を以降 `{VERSION}` として使う。
- **dev と prod で最新が食い違っていないか確認する。** 食い違っていたら、どちらに合わせるかを
  決めてから進む（通常は prod が正）。
- 「Firestore に無いのに画像がある」と出たら、前回の発行が途中で止まった残骸の可能性がある。
  中身を確認してから番号を決める（黙って上書きしない）。
- 同時に表示される Remote Config の `inquired_master_version` が、**いま端末が参照している
  バージョン**。手順13 で切り替える対象なので控えておく。
- ユーザーに `{VERSION}` と、まず dev で検証するか prod まで行くかを確認する。
  **必ず dev で先に通しで検証してから prod へ。**

### 1. gk-p.jp のHTML取得とパース

**前回の `cards_base.json` を必ず退避してから**再パースする（手順3の移送に要る）。

```bash
cp tools/data/cards_base.json tools/data/cards_base_prev.json
curl -s -A "Mozilla/5.0" "https://www.gk-p.jp/mhcard/?pref=zenkoku" -o tools/data/zenkoku.html
python3 tools/parse_cards.py    # → tools/data/cards_base.json（全カードの基礎データ + image_url）
```

`cards_base.json` の件数を確認する（前回より増えていれば新弾が反映されている）。

### 2. 利用者からの申告を取り込む

アプリのサポートページ（Google Forms）に届いた申告のうち、**前回の master 発行日以降**のものを
確認対象として洗い出す。それ以前は前回の master で対応済みとみなす。

1. Google Forms の回答をCSVでダウンロードし、`tools/data/support_requests.csv` に置く。
   **`tools/data/` は .gitignore 済み。CSV にはメールアドレスが入るので commit しないこと。**
2. 仕分けする（対象期間は `tools/master_releases.json` の最新 `released_at` から自動で決まる）:

```bash
python3 tools/review_support_requests.py --csv tools/data/support_requests.csv \
    --cards tools/data/cards_base_prev.json \
    --out tools/data/support_review.json
```

**`--cards` に `cards_base_prev.json` を指定すること。** 手順1 で再パースした直後の
`cards_base.json` にはまだ `ocr_*` / `dist_*` が入っていないので、そのままだと
「現在の値」が空で表示される。前回 master 時点の値を見たいので退避した方を渡す。

出力は3つに分かれる:

- **A. カードを特定できた申告** — 該当カードの現在の master 値（在庫状況・配布場所・座標）が
  並べて表示される。各件に「どの手順で確認するか」の観点が付く。
- **B. データの話だがカードを特定できなかった申告** — 自治体名が書かれていない等。1件ずつ人が読む。
- **C. その他（アプリの機能要望・不具合報告に見えるもの）** — master とは別件。ただし
  **データ起因が紛れていることがあるので必ず目を通す**（「地図にマンホールが出ない」が
  画像配信の遮断だった、という例が実際にある）。

**この時点では判断しない。** ここで作るのは「gk-p.jp を見に行く宿題リスト」。
真偽の確定は手順8 で行う。A・B で名指しされたカードの `card_id` を控えておき、
手順6 の抽出対象に**差分の有無にかかわらず必ず含める**。

### 3. 中間成果物を新 card_id へ移送する（新弾があれば必須）

`card_id` は行順の連番なので、新弾が挿入されると既存カードの card_id がシフトする（原則の項を参照）。
**安定キー `image_url` を介して、前回の中間成果物を新しい card_id へ移送する。**

```bash
python3 tools/remap_card_ids.py --dry-run   # 移送件数・新規カード・消滅カードの確認
python3 tools/remap_card_ids.py             # 移送を実行
```

移送されるもの: `data/ocr_raw.json` / `data/dist_raw.json` / `data/download_status.json` /
`tools/images/{card_id}.jpg`（拡張子は保つ）、および人手確定の `tools/ocr_resolved.json` /
`tools/dist_resolved.json`（tools/ 直下・commit 対象なので、移送結果は `git diff` で確認できる）。
今回の新規カードは `tools/data/new_card_ids.json` に書き出される。

**移送後は必ず検証する**（黙って壊れるのが一番怖い箇所）。0004 では次の3つで裏付けを取った:
- OCR済みカードの `ocr_id` の先頭部（`NN-NNN-X`）が、`image_url` のファイル名の先頭部と一致するか。
  → 大半が一致すれば移送は正しい。**少数の不一致はカード側の印字が正**なので、画像を目視して確認する
  （0004 では大郷町・いわき市・長岡市の3件が該当し、いずれもカードの印字どおりで OCR が正しかった）。
- `ocr_id` が サイト由来の `serial`・`pref_code` と全件一致するか。
- 移送後の `ocr_id` の集合が、**前バージョンの master の cards のIDと完全一致**するか。

### 4. 新規カード画像の二重OCR

**目的**: 各カードの記載ID（`ocr_id`）と度分秒座標（`ocr_lat_dms` / `ocr_lon_dms`）を、誤読なく確定する。

**OCRは新規カードだけでよい。** 手順3で移送済みの既存カードは、画像が同じ（`image_url` が同じ）なら
読み直す必要がない。対象は `tools/data/new_card_ids.json`。
**ただし手順2 で「カードのデザイン・画像が違う」「カード番号が違う」と申告されたカードは、
既存でも対象に加えて読み直す。**

**画像の入手**: OCRには画像実体が要る。`tools/download_images.py` で gk-p.jp から取得する（Referer付き・冪等）。

```bash
python3 tools/download_images.py   # → tools/images/{card_id}.jpg（新規分だけDLされる）
```

**二重読みの実施**:
1. 対象カードを 10 件程度のバッチに分割する（card_id のリストを作る）。
2. 各バッチについて、**2つの独立したサブエージェント（読み手Aと読み手B）**に、記録値を見せずに画像から読み取らせる。各エージェントには次を渡す:
   - 対象 card_id のリスト
   - 画像パス `/Users/zwtin/Documents/github/manhole_card_navi/tools/images/{card_id}.jpg`
   - 読み取る項目: カード右上のID（`NN-NNN-XNNN` 形式）、下部の緯度DMS（`度°分'秒"N`）、経度DMS（`度°分'秒"E`）
   - 返す形式は `{card_id: {id, lat_dms, lon_dms}}` の JSON のみ
   - 数字・英字・記号（° ' " と N/E）を1文字ずつ丁寧に読むこと
   - **推測・補完をさせない**。「自治体コードから考えてこうあるべき」と推論させず、印字どおりに読ませる
     （カード自体が誤植していることがある。後段のクロスチェックで拾う）
   - 結果は読み手ごとに別ファイル（`tools/data/ocr_parts/*_readA.json` / `*_readB.json`）へ Write させる
3. 読み手Aと読み手Bの結果を集約し、`tools/data/ocr_raw.json` に**マージ**する（既存カードの分は残す）:
   ```json
   { "<card_id>": {
       "read1": {"id": "...", "lat_dms": "...", "lon_dms": "..."},
       "read2": {"id": "...", "lat_dms": "...", "lon_dms": "..."}
     }, ... }
   ```

**参考規模**: 新弾のみなら数十件（0004 は24件＝3バッチ×読み手2人＝6エージェント）で済む。
全1311件を初回から読む場合は10件バッチで約132バッチ、読み手2人で約264エージェント。並列で回す
（サブエージェントの同時実行は20体まで）。1件あたり実測 約2,200トークン。

### 5. OCR結果の確定と不一致の解消

```bash
python3 tools/ocr_cards.py --dry-run   # 確定/不一致の件数を確認
python3 tools/ocr_cards.py             # cards_base.json に ocr_* を書き込み、不一致を out/ocr_conflicts.json へ
```

- `read1` と `read2` が完全一致し、座標が日本範囲内なら **確定** → `cards_base.json` に `ocr_id` / `ocr_lat_dms` / `ocr_lon_dms` を追記。
- 不一致（二重読みズレ、座標範囲外）は `tools/out/ocr_conflicts.json` に出る。
- **不一致カードは人間が画像を目視**し、正しい値を `tools/ocr_resolved.json`（`tools/data/` ではない）に書く:
  ```json
  { "<card_id>": {"id": "...", "lat_dms": "...", "lon_dms": "..."}, ... }
  ```
  その後 `python3 tools/ocr_cards.py` を再実行（`ocr_resolved.json` が最優先で採用される）。
  **書いたら commit する。** 人手で確かめた判断なので次回に残す。
- **全カードが確定するまで**（`ocr_cards.py` が「不一致なし」を出すまで）繰り返す。

確定後、`ocr_id` の重複が無いことを確認する（別カードが同じIDだと画像が上書きされる）。`ocr_cards.py` が重複を警告する。

**既知の印字誤植（`ocr_resolved.json` で補正済み）**: `27-226-B001`（大阪府藤井寺市）は
カードの経度印字が誤植（秒が60を超える `135°59'74.7"E`）。そのまま解釈すると地図ピンが57km飛ぶ。
補正値は手順3の移送で引き継がれるが、**gk-p.jp が画像を直していないかを毎回確認する**
（該当画像を目視。直っていれば `ocr_resolved.json` から外す）。0004 時点ではまだ誤植のまま。

**「カード番号が違う」という申告が来ても、印字が正**。実例: 新潟県長岡市D（`15-205-D001`）に
「正しくは `15-202-D001`」という申告が来ているが、配布場所は旧川口町域（長岡市川口中山）で、
カードには合併前の自治体コードが印字されている。**カードの印字どおりにするのが原則**なので
master は変えない。こういう申告は手順8 で「申告どおりにしない」と決着させて記録する。

### 6. 配布場所の AI 抽出（住所 + 在庫状況）

**目的**: 各カードの配布場所HTMLから「実際にカードを配布している場所の住所」を抽出し、
在庫状況から `distribution_state` を分類する。

配布場所欄は施設名・リンク・住所・電話・問合せ先・注記が混在しており、**正規表現では
施設名や問合せ先を住所と誤判定する**（実証済み）。地図マーカーの座標を誤ると実害が
大きいので、画像OCRと同様に **AIで抽出し二重読みで検証**する。

**対象**:
1. 新規カード
2. 配布場所/在庫HTMLが前回から変わった既存カード
   （`cards_base_prev.json` と突き合わせて `distribution_html` / `stock_text` の差分を取る。
   0004 では新規24件＋変更1件＝25件だった）
3. **手順2 で申告のあったカード（差分が出ていなくても必ず含める）**

3 を入れるのは、gk-p.jp 側の更新漏れと、こちらの差分検出漏れを切り分けるため。
再抽出した結果が前回と同じなら「サイトがまだ直っていない」と確定できる。

**二重読みの実施**:
1. 対象カードを 20〜30 件程度のバッチに分割する。
2. 各バッチについて、**2つの独立したサブエージェント（読み手Aと読み手B）**に、
   `cards_base.json` の `distribution_html` と `stock_text` を渡して抽出させる。
   各エージェントに渡す指示:
   - **住所の抽出**: 実際にカードを配布している場所の住所だけを抜き出す。
     - 施設名・電話番号・問合せ先・注記（震災による変更のお知らせ等）は**含めない**
     - 都道府県名が省略されている場合は補う（カードの `prefecture` を使う）
     - 配布場所が複数あれば複数返す。配布場所が読み取れなければ空リスト
   - **在庫状況の分類**（`distribution_state`）:
     - 「配布終了」「一時中止」「配布しておりません」等 → `stopped`（最優先）
     - 「こちらからご確認ください」等、在庫確認リンクがある → `distributing`
       （問合せ先が併記されていても、確認手段があるので配布中）
     - 確認リンクが無く電話問合せのみ → `notClear`
   - 返す形式は `{card_id: {addresses: [...], state: "..."}}` の JSON のみ
   - **申告の内容はエージェントに渡さない**（HTMLだけを読ませる。先入観を与えない）
3. 読み手Aと読み手Bの結果を集約し、`tools/data/dist_raw.json` を組み立てる:
   ```json
   { "<card_id>": {
       "read1": {"addresses": ["東京都北区赤羽台1-4-50"], "state": "distributing"},
       "read2": {"addresses": ["東京都北区赤羽台1-4-50"], "state": "distributing"}
     }, ... }
   ```

**確定と不一致の解消**:

```bash
python3 tools/extract_distribution.py --dry-run   # 確定/不一致の件数
python3 tools/extract_distribution.py             # cards_base.json に dist_* を書き込み
```

- 二重読みが一致し、かつ**キーワードルールによる state 判定とも一致**すれば確定。
  （ルールは全カードを分類できるので、AIとルールの相互検算になる）
- 不一致は `tools/out/dist_conflicts.json` に出る。目視で確認し
  `tools/dist_resolved.json`（`tools/data/` ではない）に確定値を書いて再実行する。書いたら commit する。
- **全カードが確定するまで**繰り返す。
- 住所0件のカードが出たら、それが `stopped`（配布終了）かを確認する。配布中なのに住所が
  無いのは抽出漏れ（0004 では住所0件の7件すべてが `stopped` だった）。

### 7. 配布場所のジオコーディング

抽出した住所を緯度経度に変換する。地図のピン表示に使う。

```bash
export GOOGLE_GEOCODING_API_KEY=xxxxx
python3 tools/geocode.py --dry-run    # 問い合わせ件数の確認（キャッシュ済みは除外）
python3 tools/geocode.py              # 未キャッシュの住所だけ問い合わせ
```

- 住所をキーに `tools/data/geocode_cache.json` にキャッシュされる（冪等・差分実行）。
  キャッシュのキーは住所文字列なので、card_id のシフトの影響を受けない。
- 初回は約1,500件の新規問い合わせが発生する（Google Geocoding API: $5/1000件 → 約$8）。
  2回目以降は新規住所だけ（0004 は25件）。
- API キーは `~/.zshenv` の `GOOGLE_GEOCODING_API_KEY` に設定済み。
- 日本範囲外に落ちた住所は `jp_ok: false` としてフラグ化される。
**解決精度を必ず監査する（ピンずれの主因）。**

キャッシュの各エントリには Google が返した `location_type` が入っている。
`ROOFTOP` は番地まで解決できた印。**`APPROXIMATE` で、かつ `formatted_address` に
郵便番号（`〒`）が付かないものは、市区町村の重心に落ちている**＝ピンが数百m〜数km ずれる。

```bash
python3 - <<'EOF'
import json
cards = json.load(open("tools/data/cards_base.json"))
cache = json.load(open("tools/data/geocode_cache.json"))
used = {a for c in cards for a in c.get("dist_addresses", [])}
coarse = [a for a in used
          if cache.get(a, {}).get("location_type") == "APPROXIMATE"
          and "〒" not in cache[a].get("formatted_address", "")]
print(f"市区町村レベルどまり: {len(coarse)} 件")
for a in sorted(coarse):
    print(f"  {a}\n      -> {cache[a]['formatted_address']}")
EOF
```

**直し方: `tools/geocode_resolved.json` に「問い合わせ文字列の差し替え」を書く。**
座標は書かない（人力の座標を混ぜない、というこのリポジトリの原則を保つ）。

```json
{ "愛知県名古屋市千種区月が丘1-1-44": {
    "query": "愛知県名古屋市千種区月ケ丘1-1-44",
    "_note": "サイトは『月が丘』だが実在の町名は『月ケ丘』。約1.1kmずれていた。" } }
```

書いて `python3 tools/geocode.py` を再実行すると、その住所だけ差し替えた文字列で
引き直してキャッシュを更新する（キーはサイト表記の住所のままなので master 側は変わらない）。
差し替えを変えたら自動で引き直す（`query_used` を記録している）。

よくある原因と効く差し替え:

| 症状 | 差し替え方 |
|---|---|
| 施設名が無いと番地が引けない | `{施設名} {住所}` にする（**最も効く**） |
| サイトの町名表記が実在と違う | `月が丘`→`月ケ丘`、`東大道原田`→`東大道町原田`、`羽村4122`→`羽4122` など |
| 番地が漢数字表記 | `和歌山市1-3`→`和歌山市一番丁3` |

**採用の判断は「返答の番地が入力と一致するか」で行う。** `ROOFTOP` でも別の建物を
拾っていることがある（実例: `龍が崎`と書き換えたら『龍ヶ崎ビル』という無関係の建物に
当たった）。`formatted_address` を必ず目で確かめること。`無番地` のように番地が無い住所は
どう頑張っても町丁目の重心までなので、差し替えを足さずに放置してよい。

- **「配布場所のピンがずれている」という申告があったカードは、まずここを疑う。**
  住所が変わっていなければ再問い合わせは起きないので、キャッシュの `location_type` を見る。

### 8. 利用者からの申告を決着させる（master 生成前・必須）

手順2 で作った宿題リストを1件ずつ片付ける。**ここを飛ばすと、申告が届いているのに
同じ誤りのまま次の master を出すことになる。**

各件について:

1. **gk-p.jp の該当ページを開いて確かめる。** カード画像の確認が要るものは画像も見る。
2. 結果を3つのどれかに分類する:
   - **サイトが更新されていて、今回の再取得で既に直っている** → 何もしない。
     `cards_base.json` の該当カードが期待どおりの値になっていることを確認するだけ。
   - **サイトが申告どおりに更新されていない** → **master は直さない（サイトが正）。**
     利用者の観測が正しくても、こちらで手入力すると情報源が二重になり、次回の再生成で
     戻ってしまう。記録して次回に持ち越す。同じ自治体に複数件来ている・実害が大きい
     （遠方から訪ねて配布終了だった等）ものは、gk-p.jp への連絡を検討する。
   - **申告の側が誤り** → 直さない。理由を記録する
     （例: 手順5 の長岡市D。合併前の自治体コードが印字されているだけ）。
3. 決着をまとめる。`tools/data/support_review.json` の内容に、件ごとの判断と理由を書き足して
   残しておくと、次回「また同じ申告が来た」ときに判断を繰り返さずに済む。

**C（アプリ側に見えるもの）も最後にもう一度見る。** データ起因が紛れていることがある。
配信ドメインの遮断、画像URLの誤り、Remote Config の参照先バージョン間違いは、
利用者からは「地図にマンホールが表示されない」「カードが白黒のまま」として届く。

### 9. 座標のクロスチェック（master 生成前・必須）

**二重OCRは「読み間違い」しか検出できない。**読み手A/Bが同じ誤読をした場合や、カード自体の
印字が誤っている場合は素通りする。地図ピンの座標を誤ると実害が大きいので、
**独立した情報源との照合**を master 生成の前に必ず走らせる。

1. **座標の距離チェック** — OCRしたマンホール座標と、Googleがジオコーディングした配布場所座標
   （完全に独立した情報源）の距離を測り、**30km超**を洗い出す。藤井寺市の誤植はこれで見つかった。
   20〜30km は広域自治体（高山市・流域下水道・香美市）で正常なので誤検知しない。
   **離島に注意**: 0004 では薩摩川内市（46-215-B001）の座標が本土から約55km西だったが、
   配布場所が下甑島（下甑町長浜）で座標も下甑島を指しており、印字は正しかった。
   距離が出たら「配布場所の住所」と突き合わせて判断すること。
2. **ID の照合** — `ocr_id` を、サイトHTML由来の `serial`（整理番号）と `pref_code` と突き合わせる
   （0004 では全1289件で不一致ゼロ）。
3. **DMS の値域チェック** — 分・秒が60以上のものを洗い出す。ただし秒が `60.0` ちょうどのものは
   印字時の四捨五入（59.99…→60.0）で、パース結果は数学的に正しいので補正不要
   （0004 では 09-201-C001 と 38-402-A001 の2件が該当、いずれも補正不要）。

### 10. master データ生成

**dev と prod で配信ドメインが違うので、master JSON も `--project` ごとに作る。**

```bash
python3 tools/build_master.py --version {VERSION} --project dev
python3 tools/build_master.py --version {VERSION} --project prod
# → tools/data/firestore/master_{VERSION}_dev.json / master_{VERSION}_prod.json
```

- **全カードを cards_base.json から毎回まるごと再生成する**（既存 master は引き継がない）。
  弾の追加・カードの増減・在庫状況の変化がすべて自動で反映される。
- 出力構造は 3コレクション（cards / prefectures / volumes）。カードは配布場所HTML・
  配布場所座標（GeoPoint配列）・配布時間HTML・在庫状況HTML・画像URLを直接持つ。
- 画像URLは2本。**両方が出ていることを確認する**:
  - `image_url`（主系・R2） `{R2ベースURL}/master/v{VERSION}/images/{ID}.jpg`
  - `image_sub_url`（代替・Hosting） `{HostingベースURL}/master/v{VERSION}/images/{ID}.jpg`

  実行ログの「画像URL(主)」「画像URL(代)」がプロジェクトに対応したドメインになっているか見る。
- OCR や AI抽出が未実行のカードがあると、**どのカードの何が足りないかを表示して中断**する。
- 警告（未ジオコーディングの住所・日本範囲外の座標など）が出たら内容を確認する。

生成したら確認する:

```bash
# dev と prod の差は画像URLの2フィールドだけのはず
python3 - <<'EOF'
import json
a=json.load(open("tools/data/firestore/master_{VERSION}_prod.json"))
b=json.load(open("tools/data/firestore/master_{VERSION}_dev.json"))
d=set()
for x,y in zip(a["cards"],b["cards"]):
    d |= {k for k in x if x[k]!=y[k]}
print("dev/prod で差があるフィールド:", d)
print("image_sub_url 欠落:", sum(1 for c in a["cards"] if not c.get("image_sub_url")))
EOF
```

**前バージョンの master JSON と差分を取り、変化がすべて説明できるか確認する。**
0004 では「新規カード24件・弾+1」「全件の `image` パスが v0003→v0004」「全件の
`distribution_time_html` が埋まった」「`distribution_place_html` が1件変化」。
**説明のつかない差分があれば、移送か抽出のミスを疑う。**
手順8 で「直さない」と決めた件の値が変わっていないことも、ここで確認する。

**`image_sub_url` を入れた最初のバージョンでは、全件でそのフィールドが新規に増える**
（前バージョンには無い）。これは想定どおり。

### 11. 画像を R2 と Firebase Hosting へ配置

`tools/deploy_images.py` が **gk-p.jp から1回だけ取得して、主系（R2）と代替（Hosting）の
両方へ同じバイト列を配る**。R2 の認証情報が export されていることを確認してから実行する。

```bash
# dev で検証
python3 tools/deploy_images.py --version {VERSION} --project dev --dry-run   # 件数・両配信先の既存差分
python3 tools/deploy_images.py --version {VERSION} --project dev --limit 3   # まず3件で疎通確認
python3 tools/deploy_images.py --version {VERSION} --project dev --deploy    # 全件＋Hosting デプロイ

# 問題なければ prod
python3 tools/deploy_images.py --version {VERSION} --project prod --dry-run
python3 tools/deploy_images.py --version {VERSION} --project prod --deploy
```

- 全1311件で15〜20分かかるのでバックグラウンドで回す。
- **既に置いてあるものはスキップする**ので、中断しても再実行すれば続きから進む
  （やり直したいときは `--overwrite`）。
- 取得元は安い順に選ばれる（Hosting ローカル → R2 → gk-p.jp）。実行ログの「取得元」で
  gk-p.jp を何件叩いたか分かる。再実行時はほとんど 0 になるはず。
  **この仕組みのおかげで主系と代替はバイト単位で一致する。**
- gk-p.jp には拡張子が `.png` のカードがある（柏市 `12-217-A001`）。R2 は拡張子から
  Content-Type を推測しないので、**非JPEGは JPEG に変換し、`Content-Type: image/jpeg` を
  明示してアップロードする**（スクリプトが自動でやる。ログに `[変換]` と出る）。
- `Cache-Control: public, max-age=31536000, immutable` を付ける（Hosting 側は各 Firebase
  プロジェクトの `firebase.json` の headers で設定済み）。URL に master バージョンが
  入っており同じURLの中身は変わらないので、長期キャッシュしてよい。
- `--deploy` を付けないと Hosting はローカル配置だけで終わる。**デプロイを忘れると
  `image_sub_url` が 404 になり、フォールバックが効かない。**
- 「ocr_id が無くスキップ」が出たら、そのカードはOCR未確定 → 手順5に戻る。
- 「配置ID重複」が出たら、`ocr_id` に重複がある → 手順5で解消する。
- DL/配置の失敗があれば master 投入前に原因を確認する。

**検証（スクリプトが自動で出す）**:
- 配置後に R2 を再一覧し、Hosting はローカルを数え直して、**今回の対象が過不足なく存在するか**
  を照合する（`✅ 今回の対象はすべて…` が両方に出ること）。R2 に `余剰` が出たら旧IDの残骸を疑う。
- 1件について**主系・代替の配信URLを HEAD で叩き、`200` と `Content-Type: image/jpeg`** を表示する。
  代替が 404 のときは、デプロイ前なら正常（`--deploy` するか手動デプロイ）。
  デプロイ後も 404 なら、`firebase deploy` の対象プロジェクトを確認する。
- 手動で確認するときは:
  ```bash
  curl -s -o /dev/null -w "%{http_code} %{content_type}\n" {配信ベースURL}/master/v{VERSION}/images/{ID}.jpg
  ```

### 12. Firestore に master 投入

`--replace` を付けると、投入前に `master/{VERSION}` 配下の既存ドキュメントを全削除してから
投入する。**既存バージョンを上書き更新する場合に必須**（今回のデータに無くなった古いカード等の
残存を防ぐ）。新規バージョンなら削除対象が無いだけで無害なので、**常に付けてよい**。

**プロジェクトに対応する master JSON を入れる**（dev には `_dev`、prod には `_prod`）。
取り違えると dev の画像ドメインを prod のアプリが参照してしまうので、スクリプトが
`image_url` と `image_sub_url` のドメインを検査して不一致なら中止する。

```bash
# dev
python3 tools/upload_master_to_firestore.py --project manhole-card-navi-dev \
  --input tools/data/firestore/master_{VERSION}_dev.json --target-version {VERSION} --replace --dry-run
python3 tools/upload_master_to_firestore.py --project manhole-card-navi-dev \
  --input tools/data/firestore/master_{VERSION}_dev.json --target-version {VERSION} --replace

# prod
python3 tools/upload_master_to_firestore.py --project manhole-card-navi \
  --input tools/data/firestore/master_{VERSION}_prod.json --target-version {VERSION} --replace
```

- 指定した `{VERSION}` 以外のバージョンには一切触れない。
- `--replace` 有り: `master/{VERSION}` を全削除 → 投入（既存バージョンの更新でも古いデータが残らない）。
- `--replace` 無し: 同一IDは上書きされるが、今回のデータに無い古いドキュメントは残る。
- ドメイン検査で不一致が出たら、`--input` と `--project` の対応を間違えている。
- `image_sub_url` が無いと**警告は出るが中止はしない**（アプリは空なら主系のみで取得する）。
  ただし今回はフォールバックを効かせる前提なので、**警告が出たら手順10に戻ること。**

**投入後は Firestore から読み戻して検証する**（スクリプトは REST API を使うので、検証も
`gcloud auth print-access-token` + REST でよい。`google-cloud-firestore` は入っていない）:
- 各コレクションの件数（count 集計クエリ）が master JSON と一致するか。
  `python3 tools/master_version.py --project prod` でも最新バージョンの cards 件数と
  `image_sub_url` の有無が確認できる。
- 新規カードを1件読み、`location`（GeoPoint）が正しい位置を指すか、`image_url` / `image_sub_url` が
  プロジェクトに対応したドメインの `.../master/v{VERSION}/images/{ID}.jpg` か、
  `distribution_points` / `distribution_time_html` が入っているか。
- 読み戻した **両方の URL** をそのまま curl して 200 / `image/jpeg` が返るか。

### 13. Remote Config の切り替え（手動）

Firestore と画像の準備ができたら、**Firebase コンソールで Remote Config の
`inquired_master_version` を `{VERSION}` に更新**するようユーザーに案内する。
これで端末が新バージョンを参照し始める（アプリは `FirebaseRemoteConfig.getString('inquired_master_version')`
で参照先の master バージョンを決めている）。

**切り替える前に、いまの設定を必ず実地で読む。**

```bash
python3 tools/master_version.py --project prod   # Remote Config の現在値（既定値と条件値）が出る
```

- 既定値のほかに**アプリバージョン条件が付いている時期がある**。条件が付いているなら、
  どの条件をどのバージョンに向けるかを、下の注意に照らして決める。条件が無ければ既定値だけを更新する。
- dev で動作確認 → prod、の順で切り替える。
- 切り替え後、実機で画像・地図が正しく表示されるか確認する。

**旧世代アプリのことは気にしなくてよい**

Remote Config の `inquired_app_version` による強制アップデートがあり、これを下回るアプリは
起動時にアップデート案内が出て実質使えない。**`image` パス世代のような古い読み方をするアプリは
すでにその下に落ちている**ので、「旧世代のために旧 master を残す／出し分ける」という考慮は不要。

`inquired_app_version` の現在値はここには書かない（リリースのたびに動く）。必要なら
`master_version.py` の出力か Firebase コンソールで実地に読むこと。

**それでもアプリ世代と master の対応は確認する（重要）**

- **master が持っていないフィールドを読むアプリに、その master を向けてはいけない。**
  現行アプリは `doc.data()['image_url'] as String`（`card_repository_impl.dart`）で読むため、
  `image_url` を持たない古い master を返すと画像が出ないどころか**カード取得自体が失敗する**。
  `DocumentSnapshot` はフィールドが無いと例外を投げるので、静かな劣化ではなく全滅として出る。
- 逆に、**master にフィールドが増える分には古いアプリでも問題ない**（読まないだけ）。
  そのため新しい master を全端末に向けることは基本的に安全で、条件で出し分ける必然性は薄い。
  出し分けるのは「新アプリが世に出るまで新 master を見せたくない」等の慎重策を取る場合だけ。
- `image_sub_url` は `?? ''` で読むので、**持たない master を返しても落ちない**
  （フォールバックが働かないだけ）。
- 条件設定を変えたら、対象になる世代それぞれで実機確認する。
- アプリは `setDefaults` を使っておらず、起動時に `fetchAndActivate()` を待ってから
  参照バージョンを決める（`main.dart`）。アプリ内に旧バージョンが焼き込まれてはいない。

### 14. 発行を記録する

`tools/master_releases.json` の `releases` に1件足す。**手順2 の「前回の発行日以降」は
ここを見て決まる**ので、書き忘れると次回の申告の洗い出しが効かなくなる。

```json
{ "version": "{VERSION}", "released_at": "YYYY-MM-DD", "note": "第NN弾までを反映。NNNN件。…" }
```

`released_at` は **prod の Remote Config を切り替えた日**（利用者に届いた日）を書く。

## 完了後の注意

- 旧バージョンの画像は**まだ削除しない**。全端末が新バージョンへ移行しきるまで残す。後片付けは別スキル `/cleanup-old-images` で、移行完了後（数日〜）に行う。
  - **R2 と Hosting は同じバージョンを揃えて片付ける。** 片方だけ消すと、主系が遮断されている
    端末のフォールバック先が無くなる（あるいは代替だけ残って主系が消える）。
  - 旧アプリ向けに旧 master を返し続けている間は、その世代の画像も現役なので消さない。
- **中間ファイルは消さないこと。** `ocr_raw.json` / `dist_raw.json` / `geocode_cache.json` /
  `tools/images/` / `cards_base.json` は次回の移送（手順3）と差分実行の土台になる。
  消すと全1311件の再OCRが必要になる。
- `tools/data/support_requests.csv`（メールアドレスを含む）は **commit しない**。
  `tools/data/` は .gitignore 済みだが、別の場所へコピーしないこと。
- 逆に、**人手で確かめた判断は `tools/` 直下に置いて commit する**
  （`ocr_resolved.json` / `dist_resolved.json` / `geocode_resolved.json` / `master_releases.json`）。
  `tools/data/` に置くと .gitignore で消えて、次に同じ調べ直しをする羽目になる。

## トラブル時

- gk-p.jp が 403: Referer が必要。`download_images.py` / `deploy_images.py` は Referer 付きで取得している。
- R2 で認証エラー（`InvalidAccessKeyId` / `SignatureDoesNotMatch`）: 環境変数の
  `R2_ACCOUNT_ID` / `R2_ACCESS_KEY_ID` / `R2_SECRET_ACCESS_KEY` を確認する。
  アカウントIDはエンドポイント `https://{ACCOUNT_ID}.r2.cloudflarestorage.com` に使われる。
- R2 で `NoSuchBucket` / `AccessDenied`: バケット名（`tools/r2_utils.py` の `BUCKETS`）と
  API トークンの対象バケット・権限（Object Read & Write）を確認する。
- 主系の配信URLが 404: バケットにカスタムドメインが接続されていない、またはパスが違う。
  `--dry-run` でキー（`master/v{VERSION}/images/{ID}.jpg`）を確認する。
- **代替（Hosting）の配信URLが 404**: `--deploy` を付け忘れてローカル配置で止まっている可能性が高い。
  `cd {hostingディレクトリ} && firebase deploy --only hosting` を実行する。
  ディレクトリは `tools/hosting_utils.py` の `LOCAL_DIRS`。
- 配信URLの `Content-Type` が `image/jpeg` でない: アップロード時に明示していない古い
  オブジェクトの可能性。`--overwrite` で置き直す。
- 配信URLが 403: Cloudflare が User-Agent で弾いている。`Python-urllib/3.9`（Python の
  既定UA）は 403 になる。**検証スクリプトはブラウザ相当の UA を付けること**
  （`deploy_images.py` は付けている）。curl の既定UA や Flutter の
  `Dart/x.x (dart:io)` は 200 なので、アプリ側の実害は無い（0005 移行時に実測確認済み）。
- Remote Config が 403（`SERVICE_DISABLED` / quota project）: `gcloud` の ADC には課金先
  プロジェクトが無いので、`x-goog-user-project` ヘッダが要る（`master_version.py` は付けている）。
  それでも取れなければ Firebase コンソールで直接確認する。
- OCRの不一致が多い: 画像が不鮮明な可能性。該当画像を目視して `ocr_resolved.json` で確定する。
- 座標が日本範囲外で弾かれる: 読み取り誤り（緯度経度の取り違え等）。目視で確定する。
- **カードと画像・座標がちぐはぐ**: `card_id` のシフト（手順3の移送漏れ）を疑う。`cards_base_prev.json`
  を退避し忘れていると移送できないので、その場合は全件を再OCRするしかない。
- **座標が本土から大きく外れる**: 離島の可能性がある（配布場所の住所を見る）。離島でなければ
  カードの印字誤植を疑い、目視のうえ `ocr_resolved.json` で補正する。
- **配布場所のピンがずれている**: 住所が変わっていなければジオコーディングは再実行されない。
  `geocode_cache.json` から該当住所を消して `geocode.py` を再実行する。
- `download_status.json` が失敗を記録しているのに画像は存在する: 過去のタイムアウト記録が
  残っているだけ。実ファイルの有無で判断してよい。
- 「地図にマンホールが出ない」「カードが白黒のまま」という申告が多発: master のデータではなく
  **画像が取得できていない**可能性が高い。Crashlytics の非重大に
  `HandshakeException: WRONG_VERSION_NUMBER` が出ていれば、主系ドメインの遮断。
  `image_sub_url` が master に入っていて、かつ Hosting にその世代の画像が置かれているかを確認する。
