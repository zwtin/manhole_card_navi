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
- Firebase Hosting（代替配信元）の認証 … `firebase login` 済みの CLI を使う。
  配信ベース URL とローカルディレクトリは `hosting_utils.py` の定数に持つ

生成データ（`data/`）とカード画像（`images/`）は `.gitignore` で除外している
（DBダンプ・他者著作物・API結果・容量のため）。いずれも下記の手順で再生成できる。

**利用者からの申告CSV（`data/support_requests.csv`）にはメールアドレスが入る。**
`data/` は除外済みだが、リポジトリの他の場所へコピーしないこと。

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
0. master_version.py               現行の最新バージョンを実地で調べ、次の番号を算出（番号はハードコードしない）
1. remap_card_ids.py               新弾でシフトした card_id へ前回の中間成果物・画像を移送（再パース直後に必須）
2. review_support_requests.py      利用者からの申告CSV → 前回発行日以降の「確認すべきカード」を洗い出す
3. ocr_cards.py                    新規カード画像を二重OCR → ID・座標を確定（cards_base に ocr_*）
4. extract_distribution.py         配布場所HTMLをAI抽出 → 住所・在庫状況を確定（cards_base に dist_*）
5. geocode.py                      配布場所の住所 → 緯度経度（Google Geocoding API・キャッシュ）
6. build_master.py                 全カードを毎回まるごと再生成 → master_{version}_{project}.json
7. deploy_images.py                gk-p.jp から1回取得 → R2（主系）と Hosting（代替）の両方へ配置
8. upload_master_to_firestore.py   master_{version}.json を Firestore の master/{version} へ
9. master_releases.json            発行日を追記（次回の申告の洗い出しがここを見る）
```

### スキルで実行する（推奨）

一連の作業は Claude Code のスキルにまとめてある。手順を覚えずに実行できる。

- **`/update-master`** — gk-p.jp の最新データで新 master バージョンを発行する（上記の全手順 ＋ Remote Config 案内）。マンホールカードの新弾が出たとき（約3ヶ月ごと）に実行。
- **`/cleanup-old-images`** — 旧バージョンの画像を R2 と Hosting の両方から削除する後片付け。全端末が新バージョンへ移行しきった後に、別タイミングで実行。

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
  image_url               : string        主系 {R2ベースURL}/master/v{version}/images/{id}.jpg
  image_sub_url           : string        代替 {HostingベースURL}/master/v{version}/images/{id}.jpg
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

### 画像配信について（主系 Cloudflare R2 ＋ 代替 Firebase Hosting）

カード画像は**同じパスで2か所に置き、master は両方の配信 URL を持つ**。
Cloud Storage（egress 課金）→ Firebase Hosting → R2 と移してきた経緯があり、
現在は R2 が主系、Hosting が代替（フォールバック先）。

| | 配信元 | master のフィールド | アプリの使い方 |
|---|---|---|---|
| 主系 | Cloudflare R2（egress 無料） | `image_url` | 常にこちらを先に引く |
| 代替 | Firebase Hosting（`*.web.app`） | `image_sub_url` | 主系の取得に失敗したときだけ |

**なぜ2か所に置くのか**: 2026-07-27 に R2 へ移行したところ「画像が表示されない」という
問い合わせが来た。配信ドメイン `cdn.manholecardnavi.com` が経路上のフィルタリング装置に
遮断される端末がある（Crashlytics に `HandshakeException: WRONG_VERSION_NUMBER`。
SNI を見て平文を返す装置が割り込んでいる）。新規取得ドメインでカテゴリ未分類のため既定で
遮断する製品があるのに対し、`*.web.app` は Google のドメインで許可リストに入っている。
影響は該当世代の約 0.6% だが、その端末では全画像が出ない。
アプリ側のフォールバックは `lib/app/service/image_fallback.dart`。

- master データには**配信 URL をフルで**持たせる。アプリはその値をそのまま画像 URL として
  使う（旧アプリのようにアプリ側でベース URL を組み立てない）。
- パスは両者で完全に同一（`master/v{version}/images/{ocr_id}.jpg`）。**URL のベース部分だけが違う。**
- dev / prod で配信ドメインが別。**そのため master JSON も `--project` ごとに生成する**
  （`master_{version}_dev.json` / `master_{version}_prod.json`）。定義は
  `r2_utils.py` の `BUCKETS` / `PUBLIC_BASE_URLS` と `hosting_utils.py` の
  `PUBLIC_BASE_URLS` / `LOCAL_DIRS`。
- パスにバージョンを含めるので、master バージョン更新のたびに URL が変わり、アプリの
  キャッシュ（`cached_network_image`）を引かずに画像を差し替えできる。
  `Cache-Control: public, max-age=31536000, immutable` を付ける（R2 はアップロード時に明示、
  Hosting は各 Firebase プロジェクトの `firebase.json` の headers で設定済み）。
  R2 は拡張子から Content-Type を推測しないので `Content-Type: image/jpeg` の明示も必須。
- 配置は `deploy_images.py` が両方まとめて行う。**gk-p.jp からの取得は1回だけ**で、
  取得済みの画像があればそれを再利用するため、主系と代替はバイト単位で一致する。
- Hosting は**フォールバックのときしか踏まれない**ので、転送量課金（Spark は 10GB/月まで無料、
  Blaze は $0.15/GB）は実質的に問題にならない。R2 に移した意味（egress 無料）は保たれる。
- 旧バージョンの画像は、全端末が新バージョンへ移行しきるまで残す
  （`delete_images_from_r2.py` / `delete_images_from_hosting.py` / `/cleanup-old-images`）。
  **R2 と Hosting は同じバージョンを揃えて片付ける。** 片方だけ消すとフォールバックが壊れる。
- **アプリ世代の移行**: Remote Config の `inquired_master_version` にアプリバージョン条件を
  付けて新旧 master を出し分けられる。現在どう設定されているかは `master_version.py` で
  実地に読むこと（条件は付いている時期と付いていない時期がある）。
  ただし `inquired_app_version` による強制アップデートがあるため、`image` パス世代のような
  古い読み方をするアプリはすでに使えなくなっている。**旧世代のための出し分けは考慮不要。**

### 利用者からの申告を突き合わせる

gk-p.jp 側の更新が遅れて、現地の実態とサイトがズレることがある（配布終了が反映されていない等）。
アプリのサポートページ（Google Forms）に届いた申告は**サイトとは独立した情報源**なので、
master を作る前に必ず突き合わせる。`review_support_requests.py` が、前回の発行日
（`master_releases.json`）以降の申告をカード単位に紐づけて洗い出す。

**ただし申告をそのまま master に書かない。** 申告は「gk-p.jp を見に行く理由」であって、
真偽の判定はサイトの該当ページ（必要ならカード画像）を見て行う。サイトが直っていなければ
master も直さない（情報源が二重になり、次回の再生成で戻ってしまうため）。

## セットアップ

```bash
# ほぼ Python標準ライブラリのみで動作する。
# deploy_images.py が Pillow（非JPEG画像のJPEG変換）と boto3（R2 の S3互換API）を使う
pip3 install --user Pillow boto3

# gcloud CLI で認証しておく（Firestore / Remote Config 読み取り時）
gcloud auth login

# firebase CLI で認証しておく（Hosting へのデプロイ時）
firebase login

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
#    dev / prod で配信ドメインが違うので project ごとに作る
#    バージョン番号は master_version.py で調べる（ハードコードしない）
VERSION=$(python3 tools/master_version.py --project prod --next-only)
python3 tools/build_master.py --version $VERSION --project dev
python3 tools/build_master.py --version $VERSION --project prod
#    OCR や AI抽出が未実行のカードがあれば、何が足りないかを表示して中断する
#    出力の image_url（主系）と image_sub_url（代替）が両方入っていることを確認する

# 5) gk-p.jp から1回取得 → R2（主系）と Hosting（代替）の両方へ配置
python3 tools/deploy_images.py --version $VERSION --project prod --dry-run  # 件数・両配信先の差分
python3 tools/deploy_images.py --version $VERSION --project prod --limit 3  # 疎通確認
python3 tools/deploy_images.py --version $VERSION --project prod --deploy   # 全件＋Hosting デプロイ
#    --deploy を忘れると image_sub_url が 404 になりフォールバックが効かない

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

**R2 と Hosting は同じバージョンを揃えて消す。** 片方だけ消すと、主系が遮断されている
端末のフォールバック先が無くなる。

```bash
# 主系（R2）
python3 tools/delete_images_from_r2.py --version 0003 --project prod --dry-run
python3 tools/delete_images_from_r2.py --version 0003 --project prod

# 代替（Hosting）。同じバージョンを消す
python3 tools/delete_images_from_hosting.py --version 0003 --project prod --dry-run
python3 tools/delete_images_from_hosting.py --version 0003 --project prod --deploy
```

旧アプリ向けに旧 master（`image` パス世代）を返し続けている間は、その世代の画像も現役。
Hosting の該当バージョンは消さないこと。

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
python3 tools/deploy_images.py --version 0005 --project dev --targets r2 \
  --cards tools/data/firestore/image_copy_0004.json --sleep 0

# 3) Firestore へ投入 → Remote Config を切り替え（/update-master 手順13）
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
- 画像は原本をそのまま `master/v{version}/images/{id}.jpg` へ置く（R2・Hosting とも同じパス）。
  ただし gk-p.jp には拡張子が `.png` のカードがあり（柏市 `12-217-A001`）、**非JPEGだけ
  JPEG に変換してから**配置し、R2 には `Content-Type: image/jpeg` を明示する
  （R2 は拡張子から Content-Type を推測しない。Hosting は `.jpg` から判定する）。
  カードの `image_url` / `image_sub_url` は配信 URL をフルで保持する（アプリはそのまま使う）。
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
| `image_layout.py` | 画像のパス計算（`master/v{version}/images/{id}.jpg`）と共通定数。R2 / Hosting で共有 |
| `r2_utils.py` | 主系 R2 の接続設定（バケット・配信ベースURL・認証） |
| `hosting_utils.py` | 代替 Firebase Hosting の設定（配信ベースURL・ローカルディレクトリ） |
| `deploy_images.py` | gk-p.jp から1回取得 → R2 と Hosting の両方へ配置（既存はスキップ・`--deploy` でデプロイ） |
| `delete_images_from_r2.py` | 旧バージョン画像を R2 から削除（後片付け） |
| `delete_images_from_hosting.py` | 旧バージョン画像を Hosting から削除（後片付け。R2 と同じバージョンを揃えて消す） |
| `migrate_master_to_r2.py` | 【R2移行用・一度きり】既存 master を土台に image → image_url の新バージョンを生成＋画像コピー用JSON出力 |
| `master_version.py` | Firestore / R2 / Hosting / Remote Config を見て現行最新と次のバージョン番号を出す |
| `review_support_requests.py` | 利用者の申告CSV → 前回発行日以降の確認対象をカード単位に紐づけて洗い出す |
| `upload_master_to_firestore.py` | master バージョンを Firestore へ投入（GeoPoint/配列対応・`--replace`） |
| `build_csv.py` | 中間データ → 正規化CSV 2ファイル（分析用・パイプライン外） |
