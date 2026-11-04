---
name: cleanup-old-images
description: 旧バージョンのマンホールカード画像を Cloudflare R2（旧世代は Firebase Hosting）から削除する後片付け作業。新しい master バージョンへ全端末が移行しきった後（数日〜）に、不要になった旧バージョンの画像を消してストレージを整理する。/update-master とは別タイミングで実行する。
---

# cleanup-old-images — 旧バージョン画像の後片付け

新 master バージョン公開後、全端末が移行しきったら、不要になった旧バージョンの画像を削除する。

配信先は世代で分かれている。**どちらの世代の画像かで使うスクリプトが違う。**

| master バージョン | 画像の配信元 | 削除に使うスクリプト |
|---|---|---|
| 0005 以降（`image_url` = R2 のフルURL） | Cloudflare R2 | `tools/delete_images_from_r2.py` |
| 0004 以前（`image` = パス。アプリがベースURLを前置） | Firebase Hosting | `tools/delete_images_from_hosting.py` |

## いつ実行するか（重要）

**新バージョン公開の「直後」ではなく、全端末が新バージョンへ移行しきった「後」に実行する。**

- master バージョンの切り替えは Remote Config（`inquired_master_version`）で行うが、端末側は次回の fetchAndActivate まで旧バージョンを参照し続ける。
- **旧アプリ（`image_url` 非対応、〜1.4.0+9）向けに Remote Config のアプリバージョン条件で
  旧 master（0004）を返し続けている間は、その世代の画像も現役**。Hosting 側の 0004 は消さない。
  旧アプリの利用者が十分減って条件を撤去した後に、Hosting の画像ごと片付ける。
- 新バージョン公開直後に旧画像を消すと、まだ旧バージョンを見ている端末で画像が 404 になる。
- そのため削除は「その世代を参照する端末が居なくなった後」に行う。
- 容量は全カードで約200MB弱。R2 の無料枠は 10GB、Hosting も 10GB。数世代残しても余裕があるので
  **急いで消す必要はない**。ロールバックの可能性を考えると、むしろ数世代残す方が安全。

## 前提

- 作業ディレクトリ: `/Users/zwtin/Documents/github/manhole_card_navi`
- 認証:
  - R2: 環境変数 `R2_ACCOUNT_ID` / `R2_ACCESS_KEY_ID` / `R2_SECRET_ACCESS_KEY`（`boto3` が必要）
  - Hosting（旧世代を片付ける場合）: `firebase login` 済み
- 削除する旧バージョン番号を決める（例: 現行が 0006 なら、2世代以上前の 0004 を消す等）。以下 `{OLD_VERSION}`。
- **その世代を参照している端末・アプリ世代が本当に居ないか**を Remote Config の条件で確認する。

## 手順（R2 世代 = 0005 以降）

### 1. 削除対象の確認

```bash
cd /Users/zwtin/Documents/github/manhole_card_navi

# dev / prod それぞれで対象を確認（削除はしない）
python3 tools/delete_images_from_r2.py --version {OLD_VERSION} --project dev --dry-run
python3 tools/delete_images_from_r2.py --version {OLD_VERSION} --project prod --dry-run
```

対象キー接頭辞（`master/v{OLD_VERSION}/`）とオブジェクト数を確認する。バージョン番号を間違えていないか必ず確認する。

### 2. 削除

```bash
# dev
python3 tools/delete_images_from_r2.py --version {OLD_VERSION} --project dev

# 問題なければ prod
python3 tools/delete_images_from_r2.py --version {OLD_VERSION} --project prod
```

- 対象バージョンのオブジェクトを 1000 件ずつまとめて削除し、最後に残件を再一覧して 0 を確認する。
- スクリプトは削除前に「バージョン文字列の形」と「対象パスに `master/v{OLD_VERSION}` が含まれるか」を
  安全確認し、**バージョン番号の入力を求める**（`--yes` でスキップ可）。

### 3. 確認

削除後、現行バージョンの画像配信に影響が無いことを確認する。

```bash
# 現行バージョンの画像が引き続き 200 / image/jpeg で返るか
curl -s -o /dev/null -w "%{http_code} %{content_type}\n" \
  {配信ベースURL}/master/v{現行VERSION}/images/{ID}.jpg
```

アプリでも現行カード画像が表示できることを確認する。

## 手順（Hosting 世代 = 0004 以前）

旧アプリ向けの旧 master を引退させた後に実行する。

```bash
python3 tools/delete_images_from_hosting.py --version {OLD_VERSION} --project dev --dry-run
python3 tools/delete_images_from_hosting.py --version {OLD_VERSION} --project dev --deploy

# 問題なければ prod
python3 tools/delete_images_from_hosting.py --version {OLD_VERSION} --project prod --deploy
```

- 対象バージョンの画像ディレクトリを削除し、`firebase deploy --only hosting` で反映する。
- スクリプトは削除前に「パスに master/v{OLD_VERSION} が含まれるか」を安全確認する。
- Hosting から全 master バージョンが消えたら、Hosting での画像配信は役目を終える
  （`deploy_images_to_hosting.py` / `delete_images_from_hosting.py` もその時点で撤去してよい）。

## 注意

- **現行バージョンや、まだ参照されうる直近バージョンは絶対に削除しない。** 削除するのは「全端末・全アプリ世代が移行しきったと確信できる、古いバージョン」だけ。
- **R2 の削除は即時で、取り消せない**（Hosting のように以前のデプロイへ戻せば復活する、ということが無い）。
  ただし gk-p.jp から再取得できるので、必要なら `/update-master` の手順9で再アップロードできる。
