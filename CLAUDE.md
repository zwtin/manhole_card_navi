# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際の Claude Code (claude.ai/code) へのガイダンスを提供します。

## 重要な指示
**このリポジトリで作業する際は、常に日本語で応答してください。**

## プロジェクト概要

マンホールカードナビ - 日本全国のマンホールカードを収集・ナビゲーションするためのFlutterモバイルアプリケーション。

## 開発コマンド

### Flutterコマンド
**重要:** すべてのFlutterコマンドで `flutter` の代わりに `fvm flutter` を使用してください。

```bash
# 依存関係の取得
fvm flutter pub get

# アプリの実行（開発環境）
fvm flutter run --dart-define-from-file=dart_defines/development.env

# アプリの実行（本番環境）
fvm flutter run --dart-define-from-file=dart_defines/production.env

# APKのビルド（本番環境）
fvm flutter build apk --dart-define-from-file=dart_defines/production.env

# iOSのビルド（本番環境）
fvm flutter build ios --dart-define-from-file=dart_defines/production.env

# コード解析
fvm flutter analyze

# テストの実行
fvm flutter test

# コード生成（Freezed、JsonSerializableなど）
fvm flutter pub run build_runner build --delete-conflicting-outputs

# アプリアイコンの生成
fvm flutter pub run flutter_launcher_icons -f flutter_launcher_icons-production.yaml

# ネイティブスプラッシュ画面の生成
fvm flutter pub run flutter_native_splash:create
```

## アーキテクチャ

### クリーンアーキテクチャレイヤー

1. **プレゼンテーション層** (`lib/app/`)
   - `view/` - UI画面とページ
   - `view_model/` - Riverpodによる状態管理
   - `view_data/` - UI専用のデータモデル
   - `widget/` - 再利用可能なUIコンポーネント
   - `mapper/` - ドメインとビューデータ間の変換
   - `provider/` - Riverpodプロバイダー

2. **ドメイン層** (`lib/domain/`)
   - `entity/` - ビジネスエンティティ
   - `repository/` - リポジトリインターフェース

3. **ユースケース層** (`lib/use_case/`)
   - `use_case/` - ビジネスロジックの実装
   - `dto/` - データ転送オブジェクト
   - `query_service/` - クエリサービスインターフェース

4. **インフラストラクチャ層** (`lib/infra/`)
   - `dao/` - データアクセスオブジェクト（Firestore、Realm）
   - `mapper/` - インフラストラクチャとドメイン間のデータマッピング

### 状態管理
- Riverpod + Flutter Hooksを使用した状態管理
- ViewModelがビジネスロジックと状態を処理
- プロバイダーは `lib/app/provider/` に集約

### データ層
- **リモート:** クラウドデータ用のFirebase Firestore
- **ローカル:** オフラインストレージ用のRealmデータベース
- **コード生成:** イミュータブルモデル用のFreezed、JSONパース用のJsonSerializable

### 主要な依存関係
- Firebaseスイート（Auth、Firestore、Storage、Analytics、Crashlyticsなど）
- Google Maps統合
- ローカルデータベース用のRealm
- 状態管理用のRiverpod + Flutter Hooks
- データモデル用のFreezed + JsonSerializable

## 環境設定

### ビルドフレーバー
- **開発環境:** `dart_defines/development.env`
- **本番環境:** `dart_defines/production.env`

各環境には個別のFirebaseプロジェクトと設定があります。

## Firebase統合
- Firebaseオプションは `lib/firebase_options.dart` で設定
- 開発環境と本番環境で個別のFirebaseプロジェクトを使用
- Firebase Auth、Firestore、Storage、Analytics、Crashlytics、Performance、Messaging、Remote Config、Cloud Functionsを使用

## コード生成
モデルはFreezedとJsonSerializableを使用。モデル変更後は以下を実行：
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

生成されるファイル：
- `*.freezed.dart` - Freezedイミュータブルクラス
- `*.g.dart` - JsonSerializable JSONパース
- `*.realm.dart` - Realmデータベースモデル

## ワークツリーでの動作確認

Claude Code のワークツリーは `.claude/worktrees/` 配下に作られます。git 管理外のファイル（`.idea/`、`dart_defines/*.env`、`firebase.json`、Android の署名ファイルと `google-services.json`、iOS の `GoogleService-Info.plist`、`*.freezed.dart` / `*.g.dart` / `*.realm.dart`、`.dart_tool/`、`ios/Pods/`）はワークツリーに引き継がれないため、そのままではビルドできません。

### セットアップ
動作確認（ビルド・実機デプロイ）をする場合は、**Android Studio / Xcode で開く前に**ワークツリーのルートで以下を実行してください。順序を逆にすると、未解決 import だらけの状態で Gradle Sync やインデックスが走って無駄になります。

```bash
./scripts/setup_worktree.sh
```

スクリプトは冪等で、以下を行います：
- **設定ファイル・署名ファイルを本体のチェックアウトから symlink**: 次のファイルは gitignore されているためワークツリーに存在しない。コピーではなく symlink なのは、本体側で更新されたときにワークツリー側が古いまま気づけない事故を防ぐため
  - `dart_defines/development.env` / `production.env`: 実行構成が `--dart-define-from-file` で渡す
  - `android/key.properties`、`android/app/signingConfigs/`: release 署名。`signingConfigs/` はディレクトリごと張る。ルートの `.gitignore` の該当行は末尾スラッシュなし（`**/android/app/signingConfigs`）で、これに末尾スラッシュを付けてはいけない。付けるとディレクトリにしか一致せず、git がファイル扱いする symlink が untracked に見えて、誤ってコミットする経路になる
  - `android/app/src/{development,production}/google-services.json`: Gradle の `selectGoogleServicesJson` が flavor に応じて `android/app/` にコピーする元
  - `ios/{development,production}/GoogleService-Info.plist`: Xcode のビルドフェーズが flavor に応じて `ios/Runner/` にコピーする元。`.gitignore` がファイル名まで指定しているため、ディレクトリではなくファイル単位で張る
  - `firebase.json`: iOS の `flutterfire upload-crashlytics-symbols` ビルドフェーズが参照する。ないと iOS ビルドが落ちる
- **`fvm install` で Flutter SDK を `.fvmrc` のバージョンに固定**: `.fvm/` は gitignore されているため、ワークツリーごとに SDK の紐付けが必要
- **`fvm flutter pub get`**: `.dart_tool/` が存在しないため、依存関係の解決が必要
- **`build_runner build --delete-conflicting-outputs`**: 生成ファイルは gitignore されているため、生成しないとコンパイルできない
- **（macOS のみ）`fvm flutter build ios --config-only`**: `pod install` と、Xcode 用のビルド設定（`ios/Flutter/Generated.xcconfig`）の生成。flavor は development を入れる

**ビルド時にコピー先として書き込まれるファイルは symlink してはいけません。** 書き込みが symlink を辿って本体側のファイルを上書きします。該当するのは `android/app/google-services.json`、`ios/Runner/GoogleService-Info.plist`、`ios/Flutter/Dart-Defines.xcconfig` の 3 つで、いずれもビルドのたびに上のファイルから生成されます。

**ワークツリーでは `ios/Podfile.lock` の差分が出ますが、コミットしないでください。** realm の podspec がチェックアウトの絶対パスを埋め込むため、`SPEC CHECKSUMS` の `realm:` の行がチェックアウトの場所ごとに変わります。`git checkout` で戻すと `ios/Pods/Manifest.lock` と食い違い、Xcode のビルドが `The sandbox is not in sync with the Podfile.lock` で落ちるので、戻さずに残してコミット対象から外します。Pod を追加・更新してコミットする場合も、`realm:` の行だけは `git add -p` などでコミットから外してください。

`.fvmrc` は末尾改行なしで管理しています。`fvm install` がこの形式で書き直すため、末尾改行を付けるとワークツリーごとに差分が出ます。

ドキュメント修正のみの場合はセットアップ不要です。

### Android Studio での実行
実行構成（development / production）は `.run/` にコミット済みなので、ワークツリーでもそのまま使えます。`.idea/workspace.xml` に保存された構成は `.idea/` が gitignore されているため引き継がれません。

Android Studio から iOS シミュレータ・実機を選んで実行する場合も同じ実行構成を使います。`flutter run` が実行のたびに `Generated.xcconfig` を実行構成の env で書き直し、必要なら `pod install` も行います。

### Xcode での実行（iOS）
実機への署名やネイティブ側のデバッグなど、Xcode から直接実行する場合は `ios/Runner.xcworkspace` を開きます。flavor は `Generated.xcconfig` の `DART_DEFINES` で決まり、セットアップ直後は development です。production で実行したいときは、Xcode でビルドする前に以下を実行してください。

```bash
fvm flutter build ios --config-only --debug --no-codesign --dart-define-from-file=dart_defines/production.env
```

Android Studio から実行した後は、最後に実行した構成の flavor が残っている点に注意してください。

### マージ後の片付け
ユーザーから「ワークツリーを片付けて」と依頼されたら、以下で削除します：

```bash
git worktree remove <path>
git branch -d <branch>
```

- 未コミット変更・未プッシュコミットがある場合は削除せず、内容を提示して確認する
- ただし `ios/Podfile.lock` の `realm:` の行だけの差分は上記のとおりセットアップで必ず出るもので、未コミット変更には数えない。これが残っていると `git worktree remove` が拒否するため、`git status` と `git diff` で他に差分がないことを確認したうえで `--force` を付ける
- gitignore されたファイル（ビルド成果物や symlink）は `git worktree remove` を妨げない。symlink が消えるだけで、本体側のファイルは消えない
- ビルド成果物を含むワークツリーは数 GB になるため放置しない