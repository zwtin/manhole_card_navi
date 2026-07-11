---
name: update-master
description: gk-p.jp の最新マンホールカードデータで新しい master バージョンを発行する。全カード画像を gk-p.jp から取得し、カード記載のID・座標を二重OCRで正確に読み取り、画像を Firebase Hosting に配置し、master データを Firestore に投入するまでの一連の作業を行う。マンホールカードの新弾が出たとき（約3ヶ月ごと）のリリース作業で使う。
---

# update-master — 新 master バージョンの発行

gk-p.jp の最新データで、Firebase Hosting（画像）と Firestore（master データ）を新バージョンに更新する。

## このスキルのスコープ（重要）

**今回のスコープは「画像を Hosting に配置」＋「ID・座標を OCR で正確に確定」まで。** master データ構造は既存のまま（cards / contacts / images / prefectures / volumes）。配布場所の構造刷新やアプリ側対応は別作業。

**情報源は gk-p.jp のサイトのみ。** カード記載のID（例 `00-101-A001`）と度分秒座標は、人力データや画像URLからの推定ではなく、**カード画像のOCR**を正とする。誤読を防ぐため全カードを二重読み（2エージェント独立読み）し、一致したものだけ確定、不一致は人間が確認する。

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

```bash
cd /Users/zwtin/Documents/github/manhole_card_navi
curl -s -A "Mozilla/5.0" "https://www.gk-p.jp/mhcard/?pref=zenkoku" -o tools/data/zenkoku.html
python3 tools/parse_cards.py    # → tools/data/cards_base.json（全カードの基礎データ + image_url）
```

`cards_base.json` の件数を確認する（前回より増えていれば新弾が反映されている）。

### 2. 全カード画像の二重OCR

**目的**: 各カードの記載ID（`ocr_id`）と度分秒座標（`ocr_lat_dms` / `ocr_lon_dms`）を、誤読なく確定する。

**画像の入手**: OCRには画像実体が要る。`tools/download_images.py` で gk-p.jp から取得する（Referer付き・冪等）。

```bash
python3 tools/download_images.py   # → tools/images/{card_id}.jpg
```

**二重読みの実施**:
1. 全カードを 10 件程度のバッチに分割する（card_id のリストを作る）。
2. 各バッチについて、**2つの独立したサブエージェント（読み手Aと読み手B）**に、記録値を見せずに画像から読み取らせる。各エージェントには次を渡す:
   - 対象 card_id のリスト
   - 画像パス `/Users/zwtin/Documents/github/manhole_card_navi/tools/images/{card_id}.jpg`
   - 読み取る項目: カード右上のID（`NN-NNN-XNNN` 形式）、下部の緯度DMS（`度°分'秒"N`）、経度DMS（`度°分'秒"E`）
   - 返す形式は `{card_id: {id, lat_dms, lon_dms}}` の JSON のみ
   - 数字・英字・記号（° ' " と N/E）を1文字ずつ丁寧に読むこと
3. 読み手Aと読み手Bの結果を集約し、`tools/data/ocr_raw.json` を組み立てる:
   ```json
   { "<card_id>": {
       "read1": {"id": "...", "lat_dms": "...", "lon_dms": "..."},
       "read2": {"id": "...", "lat_dms": "...", "lon_dms": "..."}
     }, ... }
   ```

**参考規模**: 全約1265件を10件バッチなら約127バッチ、読み手2人で約254エージェント。並列で回す。1件あたり実測 約2,200トークンで、Max プランの枠内に収まる。

### 3. OCR結果の確定と不一致の解消

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

### 4. master データ生成

```bash
python3 tools/build_master.py --version {VERSION} --out tools/data/firestore/master_{VERSION}.json
```

- `color_original` は `master/v{VERSION}/images/{ocr_id}.jpg` 形式で出力される。
- 座標は `ocr_lat_dms` / `ocr_lon_dms` から（`ocr_*` があればそれを優先、無ければ従来値）。
- 警告が出たら内容を確認する。

### 5. 画像を Firebase Hosting へ配置・デプロイ

```bash
# dev で検証
python3 tools/deploy_images_to_hosting.py --version {VERSION} --project dev --dry-run   # 件数確認
python3 tools/deploy_images_to_hosting.py --version {VERSION} --project dev --deploy    # DL→配置→deploy

# 問題なければ prod
python3 tools/deploy_images_to_hosting.py --version {VERSION} --project prod --deploy
```

- gk-p.jp から全画像をDLし、`{ocr_id}.jpg` で `public/master/v{VERSION}/images/` に配置してデプロイする。
- 「ID未確定でスキップ」が出たら、そのカードはOCR未確定 → 手順3に戻る。
- 「配置ID重複」が出たら、`ocr_id` に重複がある → 手順3で解消する。
- DL失敗があればデプロイ前に原因を確認する。

### 6. Firestore に master 投入

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

### 7. Remote Config の切り替え（手動）

Firestore と Hosting の準備ができたら、**Firebase コンソールで Remote Config の `inquired_master_version` を `{VERSION}` に更新**するようユーザーに案内する。これで全端末が新バージョンを参照し始める。

- dev で動作確認 → prod、の順で切り替える。
- 切り替え後、実機で画像・地図が正しく表示されるか確認する。

## 完了後の注意

- 旧バージョンの画像は**まだ削除しない**。全端末が新バージョンへ移行しきるまで残す。後片付けは別スキル `/cleanup-old-images` で、移行完了後（数日〜）に行う。
- 中間ファイル（`ocr_raw.json`, `ocr_resolved.json`）は次回のために残しても、消してもよい。

## トラブル時

- gk-p.jp が 403: Referer が必要。`download_images.py` / `deploy_images_to_hosting.py` は Referer 付きで取得している。
- OCRの不一致が多い: 画像が不鮮明な可能性。該当画像を目視して `ocr_resolved.json` で確定する。
- 座標が日本範囲外で弾かれる: 読み取り誤り（緯度経度の取り違え等）。目視で確定する。
