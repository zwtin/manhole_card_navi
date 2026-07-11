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
5. ocr_cards.py                    全カード画像を二重OCR → ID・座標を確定（cards_base.json に ocr_*）
6. build_master.py            既存master + 新規カード → master_{version}.json（ocr_id ベース）
7. deploy_images_to_hosting.py     gk-p.jp から画像取得 → {ocr_id}.jpg で Hosting 配置・デプロイ
8. upload_master_to_firestore.py   master_{version}.json を Firestore の master/{version} へ
```

### スキルで実行する（推奨）

一連の作業は Claude Code のスキルにまとめてある。手順を覚えずに実行できる。

- **`/update-master`** — gk-p.jp の最新データで新 master バージョンを発行する（上記1〜8 ＋ Remote Config 案内）。マンホールカードの新弾が出たとき（約3ヶ月ごと）に実行。
- **`/cleanup-old-images`** — 旧バージョンの画像を Hosting から削除する後片付け。全端末が新バージョンへ移行しきった後に、別タイミングで実行。

### ID・座標の正の情報源は「カード画像のOCR」

カード記載のID（例 `00-101-A001`）と度分秒座標は、カード画像に印字されている。これを正とする。

- **人力データや画像URLからの推定は使わない**（過去の人力IDには誤り・重複があった）。
- 誤読を防ぐため、全カードを**二重読み**（2エージェント独立読み）し、一致したものだけ確定。
  不一致は人間が目視で確定する（`ocr_cards.py` が不一致を `out/ocr_conflicts.json` に出す）。
- 確定値は `cards_base.json` に `ocr_id` / `ocr_lat_dms` / `ocr_lon_dms` として保存し、
  以降の全処理（build_master・deploy_images）はこの値を使う。

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

現行アプリのスキーマ: `master/{version}/` 配下に
`cards / contacts / images / prefectures / volumes` の各コレクションと、
`cards/{id}/contact_id/{cid}` サブコレクション（カード⇔配布場所の紐付け）。

**通常は `/update-master` スキルで実行する**（下記は個別コマンドの参考）。

```bash
# 1) 全カード画像を二重OCR → cards_base.json に ocr_id / ocr_lat_dms / ocr_lon_dms を確定
#    （2エージェント独立読み → ocr_raw.json を作り、以下を実行）
python3 tools/ocr_cards.py --dry-run   # 確定/不一致の件数
python3 tools/ocr_cards.py             # 確定分を cards_base.json へ、不一致を out/ocr_conflicts.json へ
#    不一致は ocr_resolved.json に人手で確定値を書いて再実行

# 2) 投入データ生成（既存masterを引き継ぎ + 新規カードを ocr_id ベースで追記）
#    images.color_original は master/v{version}/images/{ocr_id}.jpg 形式で出力される
python3 tools/build_master.py --version 0004 --out tools/data/firestore/master_0004.json
#    --version <ver>   master バージョン（画像パスに使う）

# 3) gk-p.jp から画像取得 → {ocr_id}.jpg で Firebase Hosting に配置
python3 tools/deploy_images_to_hosting.py --version 0004 --project prod --dry-run  # 件数確認
python3 tools/deploy_images_to_hosting.py --version 0004 --project prod --deploy   # DL→配置+デプロイ

# 4) Firestore へ投入（指定version以外には触れない・冪等batch write）
#    --replace: 投入前に master/{version} を全削除。既存バージョンの上書き更新で
#               古いカードの残存を防ぐ（新規バージョンなら無害なので常に付けてよい）
python3 tools/upload_master_to_firestore.py \
  --project manhole-card-navi \
  --input tools/data/firestore/master_0004.json \
  --target-version 0004 --replace
python3 tools/upload_master_to_firestore.py ... --replace --dry-run   # 件数確認のみ

# 5) Remote Config の inquired_master_version を新バージョンに更新（アプリが新masterを参照）
```

#### 旧バージョン画像の後片付け（別スキル `/cleanup-old-images`）

全端末が新バージョンへ移行しきった後に、旧バージョンの画像を Hosting から削除する。

```bash
python3 tools/delete_images_from_hosting.py --version 0002 --project prod --dry-run
python3 tools/delete_images_from_hosting.py --version 0002 --project prod --deploy
```

### スキーマ上の注意点

- `prefecture_id` は画像先頭2桁を3桁ゼロ埋め（例 `01` → `001`）
- `volume_id` は弾数の4桁ID（`0000`=第01弾 … 新弾は連番追加）
- `cards.latitude/longitude` は必ず `double` で投入する
  （既存データに経度が整数値のカード（明石=135, 鎌ケ谷=140）があり、
  文字列化しないよう float に正規化している）
- 画像は加工せず原本JPEGをそのまま Hosting の `master/v{version}/images/{id}.jpg` へ配置する。
  `frame_*` 等の加工画像はアプリで未使用のため配置しない。
- master の `images.color_original` には Hosting 上のパスのみを保持する
  （配信 URL のベースはアプリ側で付与）。

## ファイル一覧

| スクリプト | 役割 |
|---|---|
| `parse_cards.py` | 一覧HTML → カード基礎データ |
| `download_images.py` | カード画像DL（Referer付き・冪等） |
| `geo_utils.py` | DMS→10進変換・日本範囲バリデーション |
| `geocode.py` | 住所→座標（Google Geocoding API・キャッシュ） |
| `build_csv.py` | 中間データ → 正規化CSV 2ファイル |
| `ocr_cards.py` | 全カード画像の二重OCR結果を確定し cards_base.json に ocr_* を書き込み |
| `build_master.py` | 既存master + 新規 → 投入用JSON生成（ocr_id ベース） |
| `deploy_images_to_hosting.py` | gk-p.jp から画像取得 → {ocr_id}.jpg で Hosting 配置・デプロイ |
| `delete_images_from_hosting.py` | 旧バージョン画像を Hosting から削除（後片付け） |
| `upload_master_to_firestore.py` | master バージョンを Firestore へ投入 |
