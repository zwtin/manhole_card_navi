# 開発・検証手順

コマンドの実行、環境構築、コード生成、Gitフック、ワークツリーの操作を行う前に、関係する節を読む。ドキュメント修正だけなら、Flutterの環境構築やコード生成は不要。

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

# app の約束（デザインシステム・View が domain を知らないこと・ViewModel の独立と画面の部品）の検査。flutter analyze では見つからない
./scripts/check_app_rules.sh

# テストの実行（パッケージごと。ルートにもある）
(cd packages/domain && fvm dart test)  # domain は Flutter に依存しないので dart で回せる
(cd packages/data && fvm flutter test)
(cd packages/app && fvm flutter test)
fvm flutter test                       # ルート（lib/ の組み立て・記録）

# コード生成（パッケージごと。依存される側から順に）
for package in packages/domain packages/data packages/app; do
  (cd "$package" && fvm dart run build_runner build --delete-conflicting-outputs)
done

# アプリアイコンの生成
fvm flutter pub run flutter_launcher_icons -f flutter_launcher_icons-production.yaml

# ネイティブスプラッシュ画面の生成
fvm flutter pub run flutter_native_splash:create
```

## コミットとプッシュ
lefthook がフックで検査を走らせる。導入は `brew install lefthook` の後、**git worktree ごとに** `lefthook install`。

- コミット時: `dart fix --apply` → `dart format` → app の約束の検査（いずれも staged なファイルだけ）
- プッシュ時: `fvm flutter analyze` と全パッケージのテスト（`scripts/run_tests.sh`）

**`git commit --no-verify` や `git push --no-verify` は使わない。** 検査を飛ばすと、壊れたものがそのまま乗る。直せない事情があるなら、フックを飛ばすのではなく `// ignore:` に理由を書く。

`lefthook.yml` の `env -u GIT_DIR` は git worktree 対策で、外してはいけない。worktree からコミットすると git がフックに `GIT_DIR` を渡し、fvm がそれを継承して自分のキャッシュを見失い `exit 255` で落ちる。lefthook の `env:` では代用できない（unset ではなく空文字になり、fvm がミラーを作り直す）。

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
モデルはFreezedを使用。モデル変更後は、変更したパッケージで以下を実行（app は domain の型を解析するため、domain を変えたら app も生成し直す）：
```bash
(cd packages/<パッケージ> && fvm dart run build_runner build --delete-conflicting-outputs)
```

domain のファイルを消した後（freezed をやめて生成ファイルがなくなった場合も含む）は、app の build_runner が `InvalidOutputException: domain|lib/src/...` で落ちる。app の生成キャッシュが消えたファイルを指したままになるためで、app で `fvm dart run build_runner clean` してから build し直す。

生成されるファイル：
- `*.freezed.dart` - Freezedイミュータブルクラス（gitignore 済み）
- `*.g.dart` - data の model の JSON 変換（json_serializable、gitignore 済み）。json_serializable の生成コードが Dart 3.8 の書き方を使うため、data だけ SDK の下限を 3.8 にしている
- `packages/app/lib/src/gen/*.gen.dart` - flutter_gen のアセット・色の定義（git 管理）

## ワークツリーでの動作確認

Claude Code のワークツリーは `.claude/worktrees/` 配下に作られます。git 管理外のファイル（`.idea/`、`dart_defines/*.env`、`firebase.json`、Android の署名ファイルと `google-services.json`、iOS の `GoogleService-Info.plist`、`*.freezed.dart` / `*.g.dart`、`.dart_tool/`、`ios/Pods/`）はワークツリーに引き継がれないため、そのままではビルドできません。

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
