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
5. build_master_0003.py            既存master(0002) + 新規カード → master_0003.json
6. upload_images_to_storage.py     新規カード画像を Storage へ（color/original・無加工）
7. upload_master_to_firestore.py   master_0003.json を Firestore の master/0003 へ
```

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

```bash
# 1) 投入データ生成（既存master/0002を引き継ぎ + 新規カードを追記）
python3 tools/build_master_0003.py
#    --bucket <bucket>   画像URLに使うStorageバケット
#    --out <path>        出力先

# 2) 新規カード画像を Storage へ（color/original のみ・無加工でアップ）
python3 tools/upload_images_to_storage.py --bucket manhole-card-navi.appspot.com
python3 tools/upload_images_to_storage.py --dry-run   # 対象確認のみ

# 3) Firestore へ投入（既存versionには触れず新versionを作る・冪等batch write）
python3 tools/upload_master_to_firestore.py \
  --project manhole-card-navi \
  --input tools/data/firestore/master_0003.json \
  --target-version 0003
python3 tools/upload_master_to_firestore.py ... --dry-run   # 件数確認のみ
```

### スキーマ上の注意点

- `prefecture_id` は画像先頭2桁を3桁ゼロ埋め（例 `01` → `001`）
- `volume_id` は弾数の4桁ID（`0000`=第01弾 … 新弾は連番追加）
- `cards.latitude/longitude` は必ず `double` で投入する
  （既存データに経度が整数値のカード（明石=135, 鎌ケ谷=140）があり、
  文字列化しないよう float に正規化している）
- 画像は既存挙動に合わせ、加工せず原本JPEGをそのまま `images/color/original/{id}.jpg` へ。
  `frame_*` 等の加工画像はアプリで未使用のためアップしない。

## ファイル一覧

| スクリプト | 役割 |
|---|---|
| `parse_cards.py` | 一覧HTML → カード基礎データ |
| `download_images.py` | カード画像DL（Referer付き・冪等） |
| `geo_utils.py` | DMS→10進変換・日本範囲バリデーション |
| `geocode.py` | 住所→座標（Google Geocoding API・キャッシュ） |
| `build_csv.py` | 中間データ → 正規化CSV 2ファイル |
| `build_master_0003.py` | 既存master + 新規 → 投入用JSON生成 |
| `upload_images_to_storage.py` | 新規画像を Storage へ |
| `upload_master_to_firestore.py` | master バージョンを Firestore へ投入 |
