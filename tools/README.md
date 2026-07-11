# マンホールカード スクレイピング＆Firestore投入ツール

[gk-p.jp のマンホールカード一覧](https://www.gk-p.jp/mhcard/?pref=zenkoku)をスクレイピングし、
カード情報・マンホール座標・配布場所を抽出して、新しい `master` バージョンとして
Firestore に投入するための一連のスクリプト群。

## 機密情報について

**このディレクトリの `*.py` にキー・シークレット・認証情報は一切含まれない。**

- Google Geocoding API キー … 実行時に環境変数 `GOOGLE_GEOCODING_API_KEY` から読む
- Firestore / Storage の認証 … `gcloud auth` のアクセストークンを使う

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
5. ocr_cards.py                    全カード画像を二重OCR → ID・座標を確定（cards_base に ocr_*）
6. extract_distribution.py         配布場所HTMLをAI抽出 → 住所・在庫状況を確定（cards_base に dist_*）
7. geocode.py                      配布場所の住所 → 緯度経度（Google Geocoding API・キャッシュ）
8. build_master.py                 全カードを毎回まるごと再生成 → master_{version}.json
9. deploy_images_to_hosting.py     gk-p.jp から画像取得 → {ocr_id}.jpg で Hosting 配置・デプロイ
10. upload_master_to_firestore.py  master_{version}.json を Firestore の master/{version} へ
```

### スキルで実行する（推奨）

一連の作業は Claude Code のスキルにまとめてある。手順を覚えずに実行できる。

- **`/update-master`** — gk-p.jp の最新データで新 master バージョンを発行する（上記の全手順 ＋ Remote Config 案内）。マンホールカードの新弾が出たとき（約3ヶ月ごと）に実行。
- **`/cleanup-old-images`** — 旧バージョンの画像を Hosting から削除する後片付け。全端末が新バージョンへ移行しきった後に、別タイミングで実行。

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

**配布場所は分離しない。** 施設名・住所・電話が混在した HTML をそのまま保持し、アプリで
表示する。地図表示に必要な座標だけを別途 GeoPoint の配列として持つ。

### master 構造（3コレクション）

`master/{version}/` 配下:

```
cards/{ocr_id}
  id, name, prefecture_id, volume_id, publication_date
  location                : GeoPoint      マンホール座標（OCR確定）
  image                   : string        master/v{version}/images/{id}.jpg
  distribution_place_html : string        配布場所HTML（サイトのまま）
  distribution_points     : [GeoPoint]    配布場所の座標（0〜複数）
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

### 画像配信について（Firebase Hosting）

カード画像は **Firebase Hosting（Fastly CDN・10GB/月まで無料）** から配信する。

- master データには配信 URL ではなくパス `master/v{version}/images/{ocr_id}.jpg` のみを保持する。
  ベース URL（`https://{projectId}.web.app`）はアプリ側で付与するため、開発／本番で
  自動的に配信先が切り替わる。
- バージョンをパスに含めることで、master バージョン更新のたびに URL が変わり、
  アプリのキャッシュ（`cached_network_image`）を引かずに画像を差し替えできる。
  画像ファイルには `Cache-Control: public, max-age=31536000, immutable` を付与する
  （`firebase.json` の hosting.headers で設定）。
- 画像は gk-p.jp から取得して Hosting に配置する（`deploy_images_to_hosting.py`）。
- 旧バージョンの画像は、全端末が新バージョンへ移行しきるまで残す
  （`delete_images_from_hosting.py` / `/cleanup-old-images` で後片付け）。

## セットアップ

```bash
# Python標準ライブラリのみで動作（追加パッケージ不要）。画像サイズ確認に PIL を使う箇所は任意。
# gcloud CLI で認証しておく（Firestore/Storage 操作時）
gcloud auth login
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
python3 tools/build_master.py --version 0004
#    OCR や AI抽出が未実行のカードがあれば、何が足りないかを表示して中断する

# 5) gk-p.jp から画像取得 → {ocr_id}.jpg で Firebase Hosting に配置
python3 tools/deploy_images_to_hosting.py --version 0004 --project prod --dry-run  # 件数確認
python3 tools/deploy_images_to_hosting.py --version 0004 --project prod --deploy   # DL→配置+デプロイ

# 6) Firestore へ投入（指定version以外には触れない・冪等batch write）
#    --replace: 投入前に master/{version} を全削除。既存バージョンの上書き更新で
#               古いカードや旧構造の残骸を残さない（新規バージョンなら無害）
python3 tools/upload_master_to_firestore.py \
  --project manhole-card-navi \
  --input tools/data/firestore/master_0004.json \
  --target-version 0004 --replace
python3 tools/upload_master_to_firestore.py ... --replace --dry-run   # 件数確認のみ

# 7) Remote Config の inquired_master_version を新バージョンに更新（アプリが新masterを参照）
```

#### 旧バージョン画像の後片付け（別スキル `/cleanup-old-images`）

全端末が新バージョンへ移行しきった後に、旧バージョンの画像を Hosting から削除する。

```bash
python3 tools/delete_images_from_hosting.py --version 0002 --project prod --dry-run
python3 tools/delete_images_from_hosting.py --version 0002 --project prod --deploy
```

### スキーマ上の注意点

- `prefecture_id` は都道府県コードを3桁ゼロ埋め（`000`=国機関 … `047`=沖縄県）。
  `volume_id` は弾番号−1 を4桁ゼロ埋め（第01弾=`0000` … 第28弾=`0027`）。
  どちらも `cards_base` から決定論的に導出するのでハードコードしない。
- 座標は Firestore の **GeoPoint** で持つ（`location` と `distribution_points`）。
  中間 JSON では `{"_geopoint": {"lat": …, "lon": …}}` というセンチネル形式で表し、
  `upload_master_to_firestore.py` が `geoPointValue` に変換する（定義は `geo_utils.py`）。
- 配布場所が 0 個のカードもある（`distribution_points` が空配列）。
- 画像は加工せず原本JPEGをそのまま Hosting の `master/v{version}/images/{id}.jpg` へ配置する。
  カードの `image` フィールドは Hosting 上のパスのみを保持する
  （配信 URL のベース `https://{projectId}.web.app` はアプリ側で付与）。

## ファイル一覧

| スクリプト | 役割 |
|---|---|
| `parse_cards.py` | 一覧HTML → カード基礎データ（cards_base.json） |
| `download_images.py` | カード画像DL（Referer付き・冪等） |
| `ocr_cards.py` | 画像の二重OCR結果を確定 → cards_base に `ocr_id` / `ocr_lat_dms` / `ocr_lon_dms` |
| `extract_distribution.py` | 配布場所のAI抽出結果を確定 → cards_base に `dist_addresses` / `dist_state`（キーワードルールで相互検算） |
| `geocode.py` | 住所→座標（Google Geocoding API・キャッシュ） |
| `geo_utils.py` | DMS→10進変換・日本範囲バリデーション・GeoPoint中間表現 |
| `build_master.py` | 全カードを毎回まるごと再生成 → 投入用JSON（3コレクション・GeoPoint） |
| `deploy_images_to_hosting.py` | gk-p.jp から画像取得 → {ocr_id}.jpg で Hosting 配置・デプロイ |
| `delete_images_from_hosting.py` | 旧バージョン画像を Hosting から削除（後片付け） |
| `upload_master_to_firestore.py` | master バージョンを Firestore へ投入（GeoPoint/配列対応・`--replace`） |
| `build_csv.py` | 中間データ → 正規化CSV 2ファイル（分析用・パイプライン外） |
