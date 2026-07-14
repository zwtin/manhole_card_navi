---
name: update-master
description: gk-p.jp の最新マンホールカードデータで新しい master バージョンを発行する。全カード画像を gk-p.jp から取得し、カード記載のID・座標を二重OCRで正確に読み取り、画像を Firebase Hosting に配置し、master データを Firestore に投入するまでの一連の作業を行う。マンホールカードの新弾が出たとき（約3ヶ月ごと）のリリース作業で使う。
---

# update-master — 新 master バージョンの発行

gk-p.jp の最新データで、Firebase Hosting（画像）と Firestore（master データ）を新バージョンに更新する。

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

**master は毎回まるごと再生成する。** 既存 master を引き継がないので、弾の追加・カードの
増減・在庫状況の変化がすべて自動で反映される。

**`card_id` は恒久IDではない。** `parse_cards.py` が振る `card_id`（`card_0001`…）は
gk-p.jp の行順の連番にすぎない。新弾のカードは都道府県ごとの途中に挿入されるため、
**新弾が出ると挿入位置より後ろの card_id が全部シフトする**（0004 発行時は24枚の追加で
1265件中1231件がズレた）。前回の中間成果物（OCR結果・配布場所抽出・DL済み画像）を
そのまま使い回すと、**カードと画像・座標の対応が入れ替わる**。しかも二重OCRでは検出できない。
再パースしたら必ず手順2の移送を先に通す。カードの恒久的な同一性は **`image_url`** で判断する。

**master 構造（3コレクション）**:
- `cards/{ocr_id}` — 自治体名・都道府県ID・弾ID・発行日・マンホール座標(GeoPoint)・
  画像パス・配布場所HTML・配布場所座標(GeoPoint配列)・配布時間HTML・在庫状況HTML・配布状態
- `prefectures/{id}` — 都道府県マスタ
- `volumes/{id}` — 弾マスタ

配布場所は施設名/住所/電話の分離をせず、**HTMLのまま保持してアプリで表示**する。
地図表示に必要な座標だけを別途持つ。

## 前提

- 作業ディレクトリ: `/Users/zwtin/Documents/github/manhole_card_navi`
- Firebase プロジェクトのローカルディレクトリ:
  - prod: `~/Documents/github/firebase/manhole_card_navi`
  - dev: `~/Documents/github/firebase/manhole_card_navi_dev`
- 認証: `gcloud auth login`（Firestore投入）、`firebase login`（Hostingデプロイ）が済んでいること
- 新しいバージョン番号を決める（既存の最新が 0003 なら 0004）。以下 `{VERSION}` と表記。

## 手順

### 0. バージョン番号と対象を確認

ユーザーに新バージョン番号（例 `0004`）と、まず dev で検証するか prod まで行くかを確認する。**必ず dev で先に通しで検証してから prod へ。**

### 1. gk-p.jp のHTML取得とパース

**前回の `cards_base.json` を必ず退避してから**再パースする（手順2の移送に要る）。

```bash
cd /Users/zwtin/Documents/github/manhole_card_navi
cp tools/data/cards_base.json tools/data/cards_base_prev.json
curl -s -A "Mozilla/5.0" "https://www.gk-p.jp/mhcard/?pref=zenkoku" -o tools/data/zenkoku.html
python3 tools/parse_cards.py    # → tools/data/cards_base.json（全カードの基礎データ + image_url）
```

`cards_base.json` の件数を確認する（前回より増えていれば新弾が反映されている）。

### 2. 中間成果物を新 card_id へ移送する（新弾があれば必須）

`card_id` は行順の連番なので、新弾が挿入されると既存カードの card_id がシフトする（原則の項を参照）。
**安定キー `image_url` を介して、前回の中間成果物を新しい card_id へ移送する。**

```bash
python3 tools/remap_card_ids.py --dry-run   # 移送件数・新規カード・消滅カードの確認
python3 tools/remap_card_ids.py             # 移送を実行
```

移送されるもの: `ocr_raw.json` / `ocr_resolved.json` / `dist_raw.json` / `dist_resolved.json` /
`download_status.json` / `tools/images/{card_id}.jpg`（拡張子は保つ）。
今回の新規カードは `tools/data/new_card_ids.json` に書き出される。

**移送後は必ず検証する**（黙って壊れるのが一番怖い箇所）。0004 では次の3つで裏付けを取った:
- OCR済みカードの `ocr_id` の先頭部（`NN-NNN-X`）が、`image_url` のファイル名の先頭部と一致するか。
  → 大半が一致すれば移送は正しい。**少数の不一致はカード側の印字が正**なので、画像を目視して確認する
  （0004 では大郷町・いわき市・長岡市の3件が該当し、いずれもカードの印字どおりで OCR が正しかった）。
- `ocr_id` が サイト由来の `serial`・`pref_code` と全件一致するか。
- 移送後の `ocr_id` の集合が、**前バージョンの master の cards のIDと完全一致**するか。

### 3. 新規カード画像の二重OCR

**目的**: 各カードの記載ID（`ocr_id`）と度分秒座標（`ocr_lat_dms` / `ocr_lon_dms`）を、誤読なく確定する。

**OCRは新規カードだけでよい。** 手順2で移送済みの既存カードは、画像が同じ（`image_url` が同じ）なら
読み直す必要がない。対象は `tools/data/new_card_ids.json`。

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
全1265件を初回から読む場合は10件バッチで約127バッチ、読み手2人で約254エージェント。並列で回す。
1件あたり実測 約2,200トークン。

### 4. OCR結果の確定と不一致の解消

```bash
python3 tools/ocr_cards.py --dry-run   # 確定/不一致の件数を確認
python3 tools/ocr_cards.py             # cards_base.json に ocr_* を書き込み、不一致を out/ocr_conflicts.json へ
```

- `read1` と `read2` が完全一致し、座標が日本範囲内なら **確定** → `cards_base.json` に `ocr_id` / `ocr_lat_dms` / `ocr_lon_dms` を追記。
- 不一致（二重読みズレ、座標範囲外）は `tools/out/ocr_conflicts.json` に出る。
- **不一致カードは人間が画像を目視**し、正しい値を `tools/data/ocr_resolved.json` に書く:
  ```json
  { "<card_id>": {"id": "...", "lat_dms": "...", "lon_dms": "..."}, ... }
  ```
  その後 `python3 tools/ocr_cards.py` を再実行（`ocr_resolved.json` が最優先で採用される）。
- **全カードが確定するまで**（`ocr_cards.py` が「不一致なし」を出すまで）繰り返す。

確定後、`ocr_id` の重複が無いことを確認する（別カードが同じIDだと画像が上書きされる）。`ocr_cards.py` が重複を警告する。

**既知の印字誤植（`ocr_resolved.json` で補正済み）**: `27-226-B001`（大阪府藤井寺市）は
カードの経度印字が誤植（秒が60を超える `135°59'74.7"E`）。そのまま解釈すると地図ピンが57km飛ぶ。
補正値は手順2の移送で引き継がれるが、**gk-p.jp が画像を直していないかを毎回確認する**
（該当画像を目視。直っていれば `ocr_resolved.json` から外す）。0004 時点ではまだ誤植のまま。

### 5. 配布場所の AI 抽出（住所 + 在庫状況）

**目的**: 各カードの配布場所HTMLから「実際にカードを配布している場所の住所」を抽出し、
在庫状況から `distribution_state` を分類する。

配布場所欄は施設名・リンク・住所・電話・問合せ先・注記が混在しており、**正規表現では
施設名や問合せ先を住所と誤判定する**（実証済み）。地図マーカーの座標を誤ると実害が
大きいので、画像OCRと同様に **AIで抽出し二重読みで検証**する。

**対象は「新規カード」＋「配布場所/在庫HTMLが前回から変わった既存カード」だけでよい。**
`cards_base_prev.json` と突き合わせて `distribution_html` / `stock_text` の差分を取る
（0004 では新規24件＋変更1件＝25件だった）。在庫状況の変化を取りこぼさないよう、差分検出は必ず行う。

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
  `tools/data/dist_resolved.json` に確定値を書いて再実行する。
- **全カードが確定するまで**繰り返す。
- 住所0件のカードが出たら、それが `stopped`（配布終了）かを確認する。配布中なのに住所が
  無いのは抽出漏れ（0004 では住所0件の7件すべてが `stopped` だった）。

### 6. 配布場所のジオコーディング

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

### 7. 座標のクロスチェック（master 生成前・必須）

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

### 8. master データ生成

```bash
python3 tools/build_master.py --version {VERSION}
```

- **全カードを cards_base.json から毎回まるごと再生成する**（既存 master は引き継がない）。
  弾の追加・カードの増減・在庫状況の変化がすべて自動で反映される。
- 出力構造は 3コレクション（cards / prefectures / volumes）。カードは配布場所HTML・
  配布場所座標（GeoPoint配列）・配布時間HTML・在庫状況HTML・画像パスを直接持つ。
- OCR や AI抽出が未実行のカードがあると、**どのカードの何が足りないかを表示して中断**する。
- 警告（未ジオコーディングの住所・日本範囲外の座標など）が出たら内容を確認する。

生成したら、**前バージョンの master JSON と差分を取り、変化がすべて説明できるか確認する**。
0004 では「新規カード24件・弾+1」「全件の `image` パスが v0003→v0004」「全件の
`distribution_time_html` が埋まった（0003 は当該フィールド追加前に生成されていて全件 None だった）」
「`distribution_place_html` が1件変化」。**説明のつかない差分があれば、移送か抽出のミスを疑う。**

### 9. 画像を Firebase Hosting へ配置・デプロイ

```bash
# dev で検証
python3 tools/deploy_images_to_hosting.py --version {VERSION} --project dev --dry-run   # 件数確認
python3 tools/deploy_images_to_hosting.py --version {VERSION} --project dev --deploy    # DL→配置→deploy

# 問題なければ prod
python3 tools/deploy_images_to_hosting.py --version {VERSION} --project prod --deploy
```

- gk-p.jp から全画像をDLし、`{ocr_id}.jpg` で `public/master/v{VERSION}/images/` に配置してデプロイする。
  全1289件で15〜20分かかるのでバックグラウンドで回す。
- gk-p.jp には拡張子が `.png` のカードがある（柏市 `12-217-A001`）。Hosting は `.jpg` に対して
  `Content-Type: image/jpeg` を返すので、**非JPEGは JPEG に変換してから配置する**
  （`deploy_images_to_hosting.py` が自動でやる。ログに `[変換]` と出る）。
- 「ocr_id が無くスキップ」が出たら、そのカードはOCR未確定 → 手順4に戻る。
- 「配置ID重複」が出たら、`ocr_id` に重複がある → 手順4で解消する。
- DL失敗があればデプロイ前に原因を確認する。

**デプロイ前後の検証**:
- 配置ディレクトリの全ファイルが JPEG か（`file -b *.jpg | sort | uniq -c`）。
- master JSON が要求する画像名と、実際に配置されたファイルが過不足なく一致するか。
- デプロイ後、実URLを叩いて 200 と `Content-Type: image/jpeg` を確認する:
  `curl -s -o /dev/null -w "%{http_code} %{content_type}\n" https://manhole-card-navi-dev.web.app/master/v{VERSION}/images/{ID}.jpg`
- Hosting はコンテンツハッシュで重複排除するので、**新規アップロードが数十件しか出なくても正常**
  （既存バージョンと同じ内容の画像は再利用される）。

### 10. Firestore に master 投入

`--replace` を付けると、投入前に `master/{VERSION}` 配下の既存ドキュメントを全削除してから
投入する。**既存バージョンを上書き更新する場合に必須**（今回のデータに無くなった古いカード等の
残存を防ぐ）。新規バージョンなら削除対象が無いだけで無害なので、**常に付けてよい**。

```bash
# dev
python3 tools/upload_master_to_firestore.py --project manhole-card-navi-dev \
  --input tools/data/firestore/master_{VERSION}.json --target-version {VERSION} --replace --dry-run
python3 tools/upload_master_to_firestore.py --project manhole-card-navi-dev \
  --input tools/data/firestore/master_{VERSION}.json --target-version {VERSION} --replace

# prod
python3 tools/upload_master_to_firestore.py --project manhole-card-navi \
  --input tools/data/firestore/master_{VERSION}.json --target-version {VERSION} --replace
```

- 指定した `{VERSION}` 以外のバージョンには一切触れない。
- `--replace` 有り: `master/{VERSION}` を全削除 → 投入（既存バージョンの更新でも古いデータが残らない）。
- `--replace` 無し: 同一IDは上書きされるが、今回のデータに無い古いドキュメントは残る。

**投入後は Firestore から読み戻して検証する**（スクリプトは REST API を使うので、検証も
`gcloud auth print-access-token` + REST でよい。`google-cloud-firestore` は入っていない）:
- 各コレクションの件数（count 集計クエリ）が master JSON と一致するか。
- 新規カードを1件読み、`location`（GeoPoint）が正しい位置を指すか、`image` が
  `master/v{VERSION}/images/{ID}.jpg` か、`distribution_points` / `distribution_time_html` が入っているか。

### 11. Remote Config の切り替え（手動）

Firestore と Hosting の準備ができたら、**Firebase コンソールで Remote Config の `inquired_master_version` を `{VERSION}` に更新**するようユーザーに案内する。これで全端末が新バージョンを参照し始める。

- dev で動作確認 → prod、の順で切り替える。
- 切り替え後、実機で画像・地図が正しく表示されるか確認する。

## 完了後の注意

- 旧バージョンの画像は**まだ削除しない**。全端末が新バージョンへ移行しきるまで残す。後片付けは別スキル `/cleanup-old-images` で、移行完了後（数日〜）に行う。
- **中間ファイルは消さないこと。** `ocr_raw.json` / `ocr_resolved.json` / `dist_raw.json` /
  `dist_resolved.json` / `geocode_cache.json` / `tools/images/` / `cards_base.json` は次回の
  移送（手順2）と差分実行の土台になる。消すと全1289件の再OCRが必要になる。

## トラブル時

- gk-p.jp が 403: Referer が必要。`download_images.py` / `deploy_images_to_hosting.py` は Referer 付きで取得している。
- OCRの不一致が多い: 画像が不鮮明な可能性。該当画像を目視して `ocr_resolved.json` で確定する。
- 座標が日本範囲外で弾かれる: 読み取り誤り（緯度経度の取り違え等）。目視で確定する。
- **カードと画像・座標がちぐはぐ**: `card_id` のシフト（手順2の移送漏れ）を疑う。`cards_base_prev.json`
  を退避し忘れていると移送できないので、その場合は全件を再OCRするしかない。
- **座標が本土から大きく外れる**: 離島の可能性がある（配布場所の住所を見る）。離島でなければ
  カードの印字誤植を疑い、目視のうえ `ocr_resolved.json` で補正する。
- `download_status.json` が失敗を記録しているのに画像は存在する: 過去のタイムアウト記録が
  残っているだけ。実ファイルの有無で判断してよい。
