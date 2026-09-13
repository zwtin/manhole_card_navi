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

# コード解析（ルートで実行すると packages/ 配下もまとめて解析する）
fvm flutter analyze

# テストの実行（パッケージごと）
(cd packages/domain && fvm flutter test)
(cd packages/data && fvm flutter test)
(cd packages/app && fvm flutter test)

# コード生成（パッケージごと。依存される側から順に）
for package in packages/domain packages/data packages/app; do
  (cd "$package" && fvm dart run build_runner build --delete-conflicting-outputs)
done

# アプリアイコンの生成
fvm flutter pub run flutter_launcher_icons -f flutter_launcher_icons-production.yaml

# ネイティブスプラッシュ画面の生成
fvm flutter pub run flutter_native_splash:create
```

## アーキテクチャ

### パッケージ構成
クリーンアーキテクチャの層ごとに `packages/` 配下のパッケージに分けています。依存の向きは `app → domain ← data` で、app と data は互いを知りません。

1. **domain** (`packages/domain/`) - 他のパッケージに依存しない中心
   - `entity/` - ビジネスエンティティ
   - `repository/` - リポジトリインターフェースと、その provider
   - `query_service/` - 画面表示用の読み取りインターフェースと、その provider
   - `usecase/` - ビジネスロジックの実装と、その provider
   - `dto/` - UseCase / QueryService が返すデータ
   - `service/` - 画面遷移の窓口 `NavigationService` のインターフェース

2. **data** (`packages/data/`) - domain のインターフェースの実装
   - `repository/` / `query_service/` - Firestore・Realm・SharedPreferences・Remote Config などを使う実装
   - `dao/` - Realm のモデル
   - `mapper/` - DAO・JSON とエンティティの変換
   - `provider/` - domain の provider を実装に差し替える `dataProviderOverrides`

3. **app** (`packages/app/`) - 画面
   - `router/` - go_router のルート定義、`NavigationService` の実装、下タブの `ShellScaffold`
   - `view/` - 画面（`*_page.dart`）
   - `view_model/` - 画面ごとの ViewModel
   - `view_data/` - 画面ごとの State（freezed）と表示用データ
   - `widget/` / `mapper/` / `service/` / `theme/` - 共通部品・DTO から表示用データへの変換・画像取得・テーマ
   - `assets/` - 画面で使うアセット。flutter_gen の生成物は `lib/src/gen/`

4. **ルート** (`lib/`) - `main.dart` で Firebase を初期化し、3 パッケージを組み立てるだけ

### 依存性注入
- Repository / QueryService / NavigationService の provider は domain で `throw UnimplementedError` として宣言し、`lib/main.dart` の `ProviderScope` で `dataProviderOverrides` / `appProviderOverrides` を渡して実装に差し替える
- テストでは `ProviderContainer(overrides: [...])` でモックに差し替える

### 状態管理（app）
- 1 画面 1 ViewModel 1 State。State は freezed、依存は `build()` で `ref.watch` して `late final` に保持する
- 読み込むだけの画面は `AsyncNotifier`（`build()` で取得）、起動時チェックやマップのように読み込みに副作用を伴う画面は `Notifier` にして View の `useEffect` から `onLoad()` を呼ぶ
- ViewModel は BuildContext を持たない。遷移・アラート・URL を開く操作は `NavigationService` 経由で行う

### 画面遷移（app）
- go_router の `StatefulShellRoute` で、マップ・リスト・設定のタブがそれぞれ独立した遷移スタックを持つ
- 起動時チェックは `go` で置き換えながら進み、タブの外に出す画面（検索条件・画像拡大・起動時の規約）は root Navigator に積む
- マップのカードモーダルもルート（`/map/card/:cardId`）で、マップはその有無で表示エリアを縮める
- 戻る操作はタブ内の画面があればそれを閉じ、タブのルートでは `ShellScaffold` の `PopScope` がタブ切り替え／アプリ終了を決める
- PV は各画面の `useScreenView` が、GoRouter 上で最前面になったとき（表示・戻り・タブ切り替え）に送る

### データ層
- **リモート:** クラウドデータ用のFirebase Firestore
- **ローカル:** オフラインストレージ用のRealmデータベース
- **コード生成:** イミュータブルモデル用のFreezed、Realm のモデル

### 主要な依存関係
- Firebaseスイート（Auth、Firestore、Storage、Analytics、Crashlyticsなど）
- Google Maps統合
- ローカルデータベース用のRealm
- 状態管理用のRiverpod + Flutter Hooks
- 画面遷移用の go_router
- データモデル用のFreezed

realm はルートの `pubspec.yaml` にも書いています。iOS / Android のビルド時にアプリのルートで `dart run realm install` が走り、直接の依存でないと実行できないためです。

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
モデルはFreezedとRealmを使用。モデル変更後は、変更したパッケージで以下を実行（app は domain の型を解析するため、domain を変えたら app も生成し直す）：
```bash
(cd packages/<パッケージ> && fvm dart run build_runner build --delete-conflicting-outputs)
```

生成されるファイル：
- `*.freezed.dart` - Freezedイミュータブルクラス（gitignore 済み）
- `*.realm.dart` - Realmデータベースモデル（gitignore 済み）
- `packages/app/lib/src/gen/*.gen.dart` - flutter_gen のアセット・色の定義（git 管理）

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
- **各パッケージで `pub get` と `build_runner build --delete-conflicting-outputs`**: 生成ファイルは gitignore されているため、生成しないとコンパイルできない。コード生成はパッケージ単位なので domain → data → app の順に行う
- **（macOS のみ）`fvm flutter build ios --config-only`**: `pod install` と、Xcode 用のビルド設定（`ios/Flutter/Generated.xcconfig`）の生成。flavor は development を入れる

**ビルド時にコピー先として書き込まれるファイルは symlink してはいけません。** 書き込みが symlink を辿って本体側のファイルを上書きします。該当するのは `android/app/google-services.json`、`ios/Runner/GoogleService-Info.plist`、`ios/Flutter/Dart-Defines.xcconfig` の 3 つで、いずれもビルドのたびに上のファイルから生成されます。

`ios/Podfile` の realm のチェックサムを補正する処理は消さないでください。realm の podspec はチェックアウトの絶対パスを埋め込むため、補正がないと `ios/Podfile.lock` の `realm:` の行がチェックアウトの場所ごとに変わり、ワークツリーで必ず差分が出ます。戻そうとして `git checkout` すると `ios/Pods/Manifest.lock` と食い違い、Xcode のビルドが `The sandbox is not in sync with the Podfile.lock` で落ちます。Realm を外すときは補正も一緒に消します。

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
- gitignore されたファイル（ビルド成果物や symlink）は `git worktree remove` を妨げない。symlink が消えるだけで、本体側のファイルは消えない
- ビルド成果物を含むワークツリーは数 GB になるため放置しない
