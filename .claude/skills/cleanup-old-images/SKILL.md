---
name: cleanup-old-images
description: 旧バージョンのマンホールカード画像を Firebase Hosting から削除して再デプロイする後片付け作業。新しい master バージョンへ全端末が移行しきった後（数日〜）に、不要になった旧バージョンの画像ディレクトリを消して Hosting の容量を整理する。/update-master とは別タイミングで実行する。
---

# cleanup-old-images — 旧バージョン画像の後片付け

新 master バージョン公開後、全端末が移行しきったら、不要になった旧バージョンの画像を Firebase Hosting から削除する。

## いつ実行するか（重要）

**新バージョン公開の「直後」ではなく、全端末が新バージョンへ移行しきった「後」に実行する。**

- master バージョンの切り替えは Remote Config（`inquired_master_version`）で行うが、端末側は次回の fetchAndActivate まで旧バージョンを参照し続ける。
- 新バージョン公開直後に旧画像を消すと、まだ旧バージョンを見ている端末で画像が 404 になる。
- そのため削除は「移行の猶予（数日〜）を置いた後」に行う。
- 容量は全カードで約200MB弱、Hosting 無料枠は 10GB。数世代残しても余裕があるので**急いで消す必要はない**。ロールバックの可能性を考えると、むしろ数世代残す方が安全。

## 前提

- 作業ディレクトリ: `/Users/zwtin/Documents/github/manhole_card_navi`
- 認証: `firebase login` 済み
- 削除する旧バージョン番号を決める（例: 現行が 0004 なら、2世代以上前の 0002 を消す等）。以下 `{OLD_VERSION}`。

## 手順

### 1. 削除対象の確認

```bash
cd /Users/zwtin/Documents/github/manhole_card_navi

# dev / prod それぞれで対象を確認（削除はしない）
python3 tools/delete_images_from_hosting.py --version {OLD_VERSION} --project dev --dry-run
python3 tools/delete_images_from_hosting.py --version {OLD_VERSION} --project prod --dry-run
```

対象ディレクトリ（`public/master/v{OLD_VERSION}`）と含まれるファイル数を確認する。バージョン番号を間違えていないか必ず確認する。

### 2. 削除して再デプロイ

```bash
# dev
python3 tools/delete_images_from_hosting.py --version {OLD_VERSION} --project dev --deploy

# 問題なければ prod
python3 tools/delete_images_from_hosting.py --version {OLD_VERSION} --project prod --deploy
```

- 対象バージョンの画像ディレクトリを削除し、`firebase deploy --only hosting` で反映する。
- スクリプトは削除前に「パスに master/v{OLD_VERSION} が含まれるか」を安全確認する。

### 3. 確認

削除後、現行バージョンの画像配信に影響が無いことを確認する（アプリで現行カード画像が表示できるか）。

## 注意

- **現行バージョンや、まだ参照されうる直近バージョンは絶対に削除しない。** 削除するのは「全端末が移行しきったと確信できる、古いバージョン」だけ。
- 削除は取り消せない（再デプロイで消える）。ただし gk-p.jp から再取得できるので、必要なら `/update-master` の手順5で再配置は可能。
