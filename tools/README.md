# マンホールカード スクレイピング＆Firestore投入ツール

[gk-p.jp のマンホールカード一覧](https://www.gk-p.jp/mhcard/?pref=zenkoku)をスクレイピングし、
カード情報・マンホール座標・配布場所を抽出して、新しい `master` バージョンとして
Firestore に投入するための一連のスクリプト群。

## 機密情報について

**このディレクトリの `*.py` にキー・シークレット・認証情報は一切含まれない。**

- Google Geocoding API キー … 実行時に環境変数 `GOOGLE_GEOCODING_API_KEY` から読む
- Firestore / Storage の認証 … `gcloud auth` のアクセストークンを使う
- Cloudflare R2（画像配信）の認証 … 実行時に環境変数から読む
  （`R2_ACCOUNT_ID` / `R2_ACCESS_KEY_ID` / `R2_SECRET_ACCESS_KEY`）。
  バケット名と配信ベース URL は機密ではないので `r2_utils.py` の定数に持つ

生成データ（`data/`）とカード画像（`images/`）は `.gitignore` で除外している
（DBダンプ・他者著作物・API結果・容量のため）。いずれも下記の手順で再生成できる。

## 全体パイプライン

```
1. parse_cards.py              一覧HTML → カード基礎データ(JSON)
2. download_images.py          カード画像をDL（https+Referer必須・冪等）
   ├ 画像からマンホール座標(DMS)を目視/AIで読取 → manhole_coords_*.json
   │  （DMS→10進変換・日本範囲バリデーションは geo_utils.py）
   └ 配布場所HTMLをAIで構造化 → distribution_*.json
3. geocode.py                  配布場所住所 → 緯度経度（Google Geocoding API）
4. build_csv.py                中間データ → cards.csv / distribution_locations.csv
```

Firestore へ投入する場合はさらに:

```
0. remap_card_ids.py               新弾でシフトした card_id へ前回の中間成果物・画像を移送（再パース直後に必須）
5. ocr_cards.py                    新規カード画像を二重OCR → ID・座標を確定（cards_base に ocr_*）
6. extract_distribution.py         配布場所HTMLをAI抽出 → 住所・在庫状況を確定（cards_base に dist_*）
7. geocode.py                      配布場所の住所 → 緯度経度（Google Geocoding API・キャッシュ）
8. build_master.py                 全カードを毎回まるごと再生成 → master_{version}_{project}.json
9. deploy_images_to_r2.py          gk-p.jp から画像取得 → {ocr_id}.jpg で Cloudflare R2 にアップロード
10. upload_master_to_firestore.py  master_{version}.json を Firestore の master/{version} へ
```

### スキルで実行する（推奨）

一連の作業は Claude Code のスキルにまとめてある。手順を覚えずに実行できる。

- **`/update-master`** — gk-p.jp の最新データで新 master バージョンを発行する（上記の全手順 ＋ Remote Config 案内）。マンホールカードの新弾が出たとき（約3ヶ月ごと）に実行。
- **`/cleanup-old-images`** — 旧バージョンの画像を R2（旧世代は Hosting）から削除する後片付け。全端末が新バージョンへ移行しきった後に、別タイミングで実行。

### データの正の情報源は「gk-p.jp のサイトのみ」

人力データや機械推定は使わない。過去に人力で付けたIDには誤りと重複があり、画像URLからの
推定も不正確だった。すべてサイトから取得し、AI/OCR で確定して二重読みで検証する。

| データ | 取得方法 |
|---|---|
| カード記載ID（例 `00-101-A001`） | カード画像の**OCR**（二重読み） |
| マンホールの度分秒座標 | カード画像の**OCR**（二重読み） |
| 配布場所の住所 | 配布場所HTMLから**AI抽出**（二重読み） |
| 在庫状況（配布中/停止/不明） | **AI分類＋キーワードルールで相互検算** |
| 配布場所の緯度経度 | 住所を Google Geocoding API で変換（キャッシュ） |

一致したものだけ確定し、不一致は人間が目視で確定する
（`out/ocr_conflicts.json` / `out/dist_conflicts.json` に出力される）。

**配布場所・配布時間・在庫状況は分離しない。** サイトのセルの HTML をそのまま保持し、
アプリで表示する。地図表示に必要な配布場所の座標だけを別途 GeoPoint の配列として持つ。

### master 構造（3コレクション）

`master/{version}/` 配下:

```
cards/{ocr_id}
  id, name, prefecture_id, volume_id, publication_date
  location                : GeoPoint      マンホール座標（OCR確定）
  image_url               : string        {R2ベースURL}/master/v{version}/images/{id}.jpg
  distribution_place_html : string        配布場所HTML（サイトのまま）
  distribution_points     : [GeoPoint]    配布場所の座標（0〜複数）
  distribution_time_html  : string        配布時間HTML（サイトのまま）
  stock_html              : string        在庫状況HTML（サイトのまま）
  distribution_state      : string        distributing / stopped / notClear
prefectures/{id} : {id, name}
volumes/{id}     : {id, name}
```

- **毎回まるごと再生成する**（既存 master を引き継がない）。弾の追加・カードの増減・
  在庫状況の変化がすべて自動で反映される。都道府県IDと弾IDは決定論的に導出する。
- 旧構造の `contacts` / `images` コレクションと `cards/{id}/contact_id` サブコレクションは
  廃止した。配布場所と画像はカードに埋め込む。
  → master 取得時の読み取りが約5,500件・1,268クエリから、約1,340件・3クエリに減る。

### 画像配信について（Cloudflare R2）

カード画像は **Cloudflare R2（egress 無料）** から配信する。
Cloud Storage（egress 課金）→ Firebase Hosting → R2 と移してきた。

- master データには **配信 URL をフルで**持たせる（`image_url`）。アプリはその値をそのまま
  画像 URL として使う（旧アプリのようにアプリ側でベース URL を組み立てない）。
- バケットは dev / prod で分け、配信ドメインも別。**そのため master JSON も
  `--project` ごとに生成する**（`master_{version}_dev.json` / `master_{version}_prod.json`）。
  定義は `r2_utils.py` の `BUCKETS` / `PUBLIC_BASE_URLS`。
- オブジェクトキーにバージョンを含める（`master/v{version}/images/{ocr_id}.jpg`）ので、
  master バージョン更新のたびに URL が変わり、アプリのキャッシュ（`cached_network_image`）を
  引かずに画像を差し替えできる。アップロード時に
  `Cache-Control: public, max-age=31536000, immutable` と `Content-Type: image/jpeg` を付ける
  （R2 は拡張子から Content-Type を推測しないので明示が必須）。
- 画像は gk-p.jp から取得して R2 にアップロードする（`deploy_images_to_r2.py`）。
- 旧バージョンの画像は、全端末が新バージョンへ移行しきるまで残す
  （`delete_images_from_r2.py` / `/cleanup-old-images` で後片付け）。
- **アプリ世代の移行**: 旧アプリ（〜1.4.0+9）は `image` パス＋Hosting 配信を前提にしている。
  Remote Config の `inquired_master_version` をアプリバージョン条件で出し分け、
  旧アプリには旧 master（`image` パス）、新アプリには新 master（`image_url`）を返す。
  旧アプリの利用者が減るまで Hosting の旧画像も残す（`deploy_images_to_hosting.py` /
  `delete_images_from_hosting.py` は旧世代用として残置）。

## セットアップ

```bash
# ほぼ Python標準ライブラリのみで動作する。
# deploy_images_to_r2.py が Pillow（非JPEG画像のJPEG変換）と boto3（R2 の S3互換API）を使う
pip3 install --user Pillow boto3

# gcloud CLI で認証しておく（Firestore 操作時）
gcloud auth login

# R2 の認証情報を export しておく（~/.zshenv 等。リポジトリには置かない）
export R2_ACCOUNT_ID=xxxxx
export R2_ACCESS_KEY_ID=xxxxx
export R2_SECRET_ACCESS_KEY=xxxxx
```

## 使い方

### 1. HTMLの取得とパース

```bash
# data/zenkoku.html を用意（curl で保存）
curl -s -A "Mozilla/5.0" "https://www.gk-p.jp/mhcard/?pref=zenkoku" -o tools/data/zenkoku.html
python3 tools/parse_cards.py          # → data/cards_base.json
```

### 2. 画像ダウンロード

```bash
python3 tools/download_images.py                 # 全件
python3 tools/download_images.py --limit 30      # 先頭30件（試作）
python3 tools/download_images.py --ids card_0001,card_0004
# https強制・Referer付き・404は欠損フラグ化・冪等（DL済みはスキップ）
```

### 3. 座標読取・配布場所構造化

- **マンホール座標**: カード左下に印字された度分秒（例 `43°03'44.8"N`）を読み取り
  `data/manhole_coords_*.json` に `{card_id: {lat_dms, lon_dms, printed_id}}` 形式で保存。
  `geo_utils.py` が DMS→10進変換と日本範囲バリデーションを行う。
- **配布場所**: 配布場所セルのHTMLをAIで構造化し `data/distribution_*.json` に保存。
  問合せ先の除外、複数配布場所の分離、都道府県省略の補完、施設リンク(`name_url`)抽出を行う。

### 4. ジオコーディング

```bash
export GOOGLE_GEOCODING_API_KEY=xxxxx
python3 tools/geocode.py --input tools/data/distribution_new.json
python3 tools/geocode.py --input ... --dry-run   # APIを呼ばず対象確認のみ
# 住所をキーにキャッシュ(data/geocode_cache.json)。冪等・差分実行。
```

### 5. CSV出力

```bash
python3 tools/build_csv.py --coords manhole_coords_pilot.json --dist distribution_pilot.json --only-processed
# → tools/out/cards.csv, tools/out/distribution_locations.csv
```

## Firestore 投入（新 master バージョン作成）

**通常は `/update-master` スキルで実行する**（下記は個別コマンドの参考）。

```bash
# 1) 全カード画像を二重OCR → cards_base に ocr_id / ocr_lat_dms / ocr_lon_dms を確定
#    （2エージェント独立読み → data/ocr_raw.json を作ってから実行）
python3 tools/ocr_cards.py --dry-run   # 確定/不一致の件数
python3 tools/ocr_cards.py             # 確定分を cards_base へ、不一致を out/ocr_conflicts.json へ
#    不一致は data/ocr_resolved.json に人手で確定値を書いて再実行

# 2) 配布場所をAI抽出 → cards_base に dist_addresses / dist_state を確定
#    （2エージェント独立読み → data/dist_raw.json を作ってから実行）
python3 tools/extract_distribution.py --dry-run
python3 tools/extract_distribution.py  # 不一致は out/dist_conflicts.json へ
#    不一致は data/dist_resolved.json に人手で確定値を書いて再実行

# 3) 配布場所の住所をジオコーディング（キャッシュ済みは再問い合わせしない）
export GOOGLE_GEOCODING_API_KEY=xxxxx
python3 tools/geocode.py --dry-run     # 問い合わせ件数の確認
python3 tools/geocode.py

# 4) 投入データ生成（全カードを毎回まるごと再生成）
#    dev / prod で R2 の配信ドメインが違うので project ごとに作る
python3 tools/build_master.py --version 0005 --project dev
python3 tools/build_master.py --version 0005 --project prod
#    OCR や AI抽出が未実行のカードがあれば、何が足りないかを表示して中断する

# 5) gk-p.jp から画像取得 → {ocr_id}.jpg で Cloudflare R2 にアップロード
python3 tools/deploy_images_to_r2.py --version 0005 --project prod --dry-run  # 件数・R2の差分
python3 tools/deploy_images_to_r2.py --version 0005 --project prod --limit 3  # 疎通確認
python3 tools/deploy_images_to_r2.py --version 0005 --project prod           # 全件（既存はスキップ）

# 6) Firestore へ投入（指定version以外には触れない・冪等batch write）
#    --replace: 投入前に master/{version} を全削除。既存バージョンの上書き更新で
#               古いカードや旧構造の残骸を残さない（新規バージョンなら無害）
python3 tools/upload_master_to_firestore.py \
  --project manhole-card-navi \
  --input tools/data/firestore/master_0005_prod.json \
  --target-version 0005 --replace
python3 tools/upload_master_to_firestore.py ... --replace --dry-run   # 件数確認のみ

# 7) Remote Config の inquired_master_version を新バージョンに更新（アプリが新masterを参照）
#    新アプリ公開時はアプリバージョン条件で新旧 master を出し分ける（画像配信についての項を参照）
```

#### 旧バージョン画像の後片付け（別スキル `/cleanup-old-images`）

全端末が新バージョンへ移行しきった後に、旧バージョンの画像を削除する。

```bash
# R2 世代（0005 以降）
python3 tools/delete_images_from_r2.py --version 0003 --project prod --dry-run
python3 tools/delete_images_from_r2.py --version 0003 --project prod

# Hosting 世代（0004 以前）。旧アプリ向けの旧 master を引退させた後
python3 tools/delete_images_from_hosting.py --version 0004 --project prod --dry-run
python3 tools/delete_images_from_hosting.py --version 0004 --project prod --deploy
```

#### R2 移行（一度きり・0004 → 0005）

新アプリ（PR #14 以降）は `image_url` を読むため、公開前に `image_url` を持つ master が要る。
新弾を待たずに用意するため、**0004 の中身をそのまま引き継いだ 0005** を作る。
カードの中身（座標・配布場所・在庫状況）は 0004 と完全に同一で、画像フィールドだけ差し替わる。

```bash
# 1) Firestore の master/0004 から image_url 版 0005 を生成（dev / prod で配信ドメインが違う）
python3 tools/migrate_master_to_r2.py --source-version 0004 --target-version 0005 --project dev
python3 tools/migrate_master_to_r2.py --source-version 0004 --target-version 0005 --project prod

# 2) Hosting v0004 の確定JPEG を R2 の master/v0005/images/ へコピー
#    （gk-p.jp から取り直さないので、現行ユーザーが見ている画像とバイト同一）
python3 tools/deploy_images_to_r2.py --version 0005 --project dev \
  --cards tools/data/firestore/image_copy_0004.json --sleep 0

# 3) Firestore へ投入 → Remote Config をアプリバージョン条件で出し分け（/update-master 手順11）
```

次回の新弾からは通常ルート（`/update-master` → `build_master.py`）に戻る。

### スキーマ上の注意点

- `prefecture_id` は都道府県コードを3桁ゼロ埋め（`000`=国機関 … `047`=沖縄県）。
  `volume_id` は弾番号−1 を4桁ゼロ埋め（第01弾=`0000` … 第29弾=`0028`）。
  どちらも `cards_base` から決定論的に導出するのでハードコードしない。
- 座標は Firestore の **GeoPoint** で持つ（`location` と `distribution_points`）。
  中間 JSON では `{"_geopoint": {"lat": …, "lon": …}}` というセンチネル形式で表し、
  `upload_master_to_firestore.py` が `geoPointValue` に変換する（定義は `geo_utils.py`）。
- 配布場所が 0 個のカードもある（`distribution_points` が空配列）。
- 画像は原本をそのまま R2 の `master/v{version}/images/{id}.jpg` へアップロードする。
  ただし gk-p.jp には拡張子が `.png` のカードがあり（柏市 `12-217-A001`）、**非JPEGだけ
  JPEG に変換してから**アップロードし、`Content-Type: image/jpeg` を明示する
  （R2 は拡張子から Content-Type を推測しない）。
  カードの `image_url` フィールドは R2 の配信 URL をフルで保持する（アプリはそのまま使う）。
  なお `cards_base.json` にも `image_url` があるが、あちらは gk-p.jp 上のソース画像 URL で別物。

### `card_id` は恒久IDではない（重要）

`parse_cards.py` が振る `card_id`（`card_0001`…）は gk-p.jp の**行順の連番**にすぎない。
新弾のカードは都道府県ごとの途中に挿入されるため、**新弾が出ると挿入位置より後ろの card_id が
全部シフトする**（0004 発行時は24枚の追加で1265件中1231件がズレた）。

前回の中間成果物（`ocr_raw.json` / `dist_raw.json` / `images/{card_id}.jpg` など）をそのまま
使い回すと、カードと画像・座標の対応が入れ替わる。しかも二重OCRでは検出できない。
再パースしたら **`remap_card_ids.py` で安定キー `image_url` を介して移送する**。
カードの恒久的な同一性は `image_url` で判断すること。

## ファイル一覧

| スクリプト | 役割 |
|---|---|
| `parse_cards.py` | 一覧HTML → カード基礎データ（cards_base.json） |
| `remap_card_ids.py` | 新弾でシフトした `card_id` に、前回の中間成果物と画像を `image_url` 経由で移送 |
| `download_images.py` | カード画像DL（Referer付き・冪等） |
| `ocr_cards.py` | 画像の二重OCR結果を確定 → cards_base に `ocr_id` / `ocr_lat_dms` / `ocr_lon_dms` |
| `extract_distribution.py` | 配布場所のAI抽出結果を確定 → cards_base に `dist_addresses` / `dist_state`（キーワードルールで相互検算） |
| `geocode.py` | 住所→座標（Google Geocoding API・キャッシュ） |
| `geo_utils.py` | DMS→10進変換・日本範囲バリデーション・GeoPoint中間表現 |
| `build_master.py` | 全カードを毎回まるごと再生成 → 投入用JSON（3コレクション・GeoPoint・`--project` ごと） |
| `r2_utils.py` | R2 の接続設定（バケット・配信ベースURL・認証）とオブジェクトキー計算 |
| `deploy_images_to_r2.py` | gk-p.jp から画像取得 → {ocr_id}.jpg で R2 にアップロード（既存はスキップ） |
| `delete_images_from_r2.py` | 旧バージョン画像を R2 から削除（後片付け） |
| `migrate_master_to_r2.py` | 【R2移行用・一度きり】既存 master を土台に image → image_url の新バージョンを生成＋画像コピー用JSON出力 |
| `deploy_images_to_hosting.py` | 【旧世代用】gk-p.jp から画像取得 → {ocr_id}.jpg で Hosting 配置・デプロイ |
| `delete_images_from_hosting.py` | 【旧世代用】旧バージョン画像を Hosting から削除（後片付け） |
| `upload_master_to_firestore.py` | master バージョンを Firestore へ投入（GeoPoint/配列対応・`--replace`） |
| `build_csv.py` | 中間データ → 正規化CSV 2ファイル（分析用・パイプライン外） |
