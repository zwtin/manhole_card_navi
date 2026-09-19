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
(cd packages/domain && fvm dart test)  # domain は Flutter に依存しないので dart で回せる
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

1. **domain** (`packages/domain/`) - 他のパッケージにも Flutter にも依存しない中心。provider の宣言には Flutter を含まない `riverpod` 本体を使う（`hooks_riverpod` は使わない）
   - `core/` - エンティティではない、操作の結果を表す共通の型。成功か失敗かを包む `Result` と、失敗の種類 `DomainException`。Flutter の Clean Architecture でよく見る `core/error/` と同じ位置づけ
   - `entity/` - アプリが扱うもの（カードのように ID で区別するものと、座標やバージョンのように値そのものに意味があるもの）
   - `repository/` - リポジトリインターフェースと、その provider
   - `usecase/` - ビジネスロジックの実装と、その provider。エンティティや bool をそのまま返し、画面用の型に詰め替えない

2. **data** (`packages/data/`) - domain のインターフェースの実装。組み立て（どの実装をどの部品で作るか）は持たず、実装クラスを公開するだけ
   - `repository/` - Repository の実装。DataSource から model を受け取り、mapper でエンティティにして返す。失敗は `FailureRecorder.guard` で種類に変換・記録して返す
   - `datasource/` - 外界と話すクラス。Firestore・Firebase Auth・Analytics・Messaging・SharedPreferences は SDK のインスタンスをそのまま使い、中身があるもの・static な API だけを包む。返すのは model（か SDK の型）で、エンティティにはしない。domain を知らず、形の違うデータは data の中だけの `MalformedDataException` で知らせる（domain の失敗の種類にするのは Repository）
     - `MasterDataLocalDataSource`: 取り込んだマスターデータ（カード一式）を 1 つの JSON ファイルで持つ
     - `RemoteConfigDataSource`: Remote Config の取得（起動時の `activate`）と読み取り（空なら取り直す）
     - `CardImageCacheManager` / `ImageFallback` / `ImageLoadMonitor`: カード画像の取得（`CardRepositoryImpl.fetchImage` が使う）。端末への保存、R2 で取れなければ Hosting から取る切り替え、失敗の計測（Analytics）
     - `LocationDataSource`: 位置情報（geolocator の static な API の包み）
     - `FailureRecorder` / `UncaughtErrorObserver`: Crashlytics への記録。domain の失敗の種類を見て記録するかを決めるので、この 2 つだけは domain を知っている
   - `model/` - 外の形（Firestore のドキュメント・端末の JSON ファイル・保存した検索条件）をそのまま表すクラス。JSON との変換は json_serializable で生成する。外から受け取ったものは `checked: true` で読み、形が違えば `MalformedDataException` にする（`decodeModel`）。保存する値の enum も model が持ち、値の名前を保存する文字列にそろえる（domain の名前を変えても保存済みの値は変わらない）。エンティティは JSON を知らない
   - `mapper/` - model とエンティティ・model どうしの変換（`toCard`・`toModel`・`toLocalCard` など、出力するもので名前を付ける）と、外部の例外・`MalformedDataException` と失敗の種類の変換（`DomainExceptionMapper`）

3. **app** (`packages/app/`) - 画面
   - `router/` - go_router のルート定義、画面遷移の窓口 `NavigationService` とその go_router による実装、下タブの `ShellScaffold`
   - `view/` - 画面（`*_page.dart`）
   - `view_model/` - 画面ごとの ViewModel
   - `view_data/` - 画面ごとの State（freezed）と表示用データ
   - `widget/` / `mapper/` / `service/` / `theme/` - 共通部品・エンティティから表示用データへの変換・マーカー画像の合成・テーマ
   - `assets/` - 画面で使うアセット。flutter_gen の生成物は `lib/src/gen/`

4. **ルート** (`lib/`) - アプリを組み立てる場所（Composition Root）。`main.dart` で Firebase を初期化し、`di/` で data の実装を domain の provider に当てはめる
   - `di/infrastructure.dart` - data の Repository が共有する部品（SharedPreferences・PackageInfo・Remote Config・JSON ファイル・記録）を起動時に 1 回だけ作る `Infrastructure`
   - `di/repository_overrides.dart` - domain の Repository の provider に data の実装を当てはめる override の一覧

### 依存性注入
- Repository の provider は domain で `throw UnimplementedError` として宣言し、ルートの `lib/di/repository_overrides.dart` が data の実装に差し替える。どの実装を、どの部品で作るかを知っているのはルートだけ。app の中で閉じる `NavigationService` は、app で実装を返す provider を宣言する
- provider の寿命
  - Repository は状態を持たないか、アプリ全体で共有するもの（端末に取り込んだマスターデータなど）なので、`autoDispose` にせずアプリ全体で 1 つにする
  - UseCase も状態を持たない（状態は ViewModel か data に置く）ので、画面ごとに分けず（`family` にせず）、`autoDispose` にもせずアプリ全体で 1 つにする。クリーンアーキテクチャ・DDD の慣習でも、UseCase（アプリケーションサービス）に求められるのは状態を持たないことで、寿命は決めごとにしていない
  - ViewModel は画面の状態を持つので、画面の寿命に合わせて `autoDispose` にする
  - アプリ全体で 1 つの Repository・UseCase は、アプリが動いている間は dispose されない。閉じる必要のある資源（StreamController・HTTP クライアントなど）を持つクラスだけ `dispose` を作り、`ref.onDispose` に登録する
- テストでは `ProviderContainer(overrides: [...])` でモックに差し替える

### UseCase・Repository の引数
- 既にあるものを探す・指す・消すときは ID で渡す（`CardUseCase.get(id:)`、`AlreadyGetCardRepository.save(cardId:)`、サーバーのマスターデータを指す `MasterDataRepository.replace(version:)`）。UseCase が Repository から正しいエンティティを読み直す
- 保存する中身や新しく作るものは、値やエンティティで渡す（`SearchConditionRepository.save(searchCondition:)`）
- ID は値オブジェクトにせず String のまま扱う

### 失敗の扱い
- Repository は想定内の失敗（通信・サーバーのデータ・端末の保存領域）を投げずに `Result` に包んで返す。呼ぶ側は try / catch せずに `switch` で成功と失敗を分ける
- 失敗の種類は domain の `DomainException`（sealed）で表す。表示の文言は持たない。種類は app が表示や対応を変えたいものの分だけ作り、区別が必要になったら足す
- data は外部の例外を `DomainExceptionMapper` で種類に変換する。サーバーのデータはキャストに頼らず型を確かめ、合わなければ `MalformedDataException` を経て `CorruptedDataException` にする
- app は `NavigationService.showFailure(title:, exception:)` で知らせる。タイトルは何に失敗したか（画面が決める）、本文は `ErrorMessageMapper` が種類から決める
- バグ（Error）は `Result` に包まずにそのまま流す
- 失敗ではない結果（位置情報を許可されなかった、アップデートが必要 など）は例外にせず戻り値で返す

### 失敗とバグの記録（Crashlytics）
- Crashlytics を知っているのは data と `main.dart` だけ。app と domain は記録に関わらない
- data の Repository は、失敗をすべて `FailureRecorder`（ふつうは `guard`）を通して返し、そこで非重大として記録する。通信できない・タイムアウト（`UnavailableException`）は、時間をおけば直り調べても直せないので記録しない
- 例外はカード画像（`CardRepositoryImpl.fetchImage`）の取得の失敗で、`FailureRecorder` を通さない。画像の失敗は `ImageLoadMonitor`（Analytics）と、下の `FlutterError` 経由の非重大で記録している
- 扱われなかったバグはクラッシュ（fatal）として記録する。`main.dart` の Zone と `FlutterError.onError`、provider の生成中に起きたものは data の `UncaughtErrorObserver` が拾う。provider の中の失敗は Riverpod が受け止めるため Zone には届かない
- 画像の読み込み失敗（`library` が `image resource service`）はバグではないので、`FlutterError.onError` でも非重大のまま記録する。画像が出ない問い合わせの調査はこの非重大の記録で行う。`CardImageProvider` は、ここに残るよう変換前の例外（`HandshakeException` など）を投げる

### 状態管理（app）
- 1 画面 1 ViewModel 1 State。State は freezed、依存は `build()` で `ref.watch` して `late final` に保持する
- 読み込むだけの画面は `AsyncNotifier`（`build()` で取得）、起動時チェックやマップのように読み込みに副作用を伴う画面は `Notifier` にして View の `useEffect` から `onLoad()` を呼ぶ
- ViewModel は BuildContext を持たない。遷移・アラート・URL を開く操作は `NavigationService` 経由で行う
- ViewModel が読み書きするのは UseCase だけで、Repository を直接呼ばない。処理のない読み取りも、Repository を素通しする UseCase のメソッドを通す
- カード画像は、app の `CardImageProvider`（Flutter の `ImageProvider`）がカードの ID で `CardUseCase.fetchImage` から画像データを受け取って表示する。画像は Flutter の画像の仕組みで読み込むため、ここだけは ViewModel を通さない。画像の URL・代わりの配信元・端末に保存するかは data だけが知っていて、エンティティにも画像の URL は持たせない

### 画面遷移（app）
- go_router の `StatefulShellRoute` で、マップ・リスト・設定のタブがそれぞれ独立した遷移スタックを持つ
- 起動時チェックは `go` で置き換えながら進み、タブの外に出す画面（検索条件・画像拡大・起動時の規約）は root Navigator に積む
- 起動時チェックの最初（アプリのバージョン確認の画面）で匿名ログインを済ませてから `app_open` を送る。イベントに利用者の ID が付いた状態でアプリを使ってもらうため。初回だけ通信が要り、できなければやり直す
- オフラインでも起動できる。起動時の Remote Config の取得（待ち時間 10 秒）は失敗しても止まらず前回の値で続け、マスターデータは端末のものを使う。前回の値がない初回は、起動時チェックが「通信できませんでした」を出してやり直す
- マップのカードモーダルもルート（`/map/card/:cardId`）で、マップはその有無で表示エリアを縮める
- 戻る操作はタブ内の画面があればそれを閉じ、タブのルートでは `ShellScaffold` の `PopScope` がタブ切り替え／アプリ終了を決める
- PV は各画面の `useScreenView` が、GoRouter 上で最前面になったとき（表示・戻り・タブ切り替え）に送る

### データ層
- **リモート:** クラウドデータ用のFirebase Firestore
- **ローカル:** 取り込んだマスターデータは 1 つの JSON ファイル（`MasterDataLocalDataSource`）。Firestore から取ったカードは、エンティティを通さずに端末に保存する形（`LocalCardModel`）にして書く。全件をまとめて読んでメモリに持ち、入れ替えは一時ファイルに書いてから名前を変えて行う。ファイルの形を変えたらファイル名のバージョンを上げ、古い形は取り込んでいない扱いにして取り直す。利用者の設定・取得済みカードは SharedPreferences
- **コード生成:** イミュータブルモデル用のFreezed

### 主要な依存関係
- Firebaseスイート（Auth、Firestore、Storage、Analytics、Crashlyticsなど）
- Google Maps統合
- 状態管理用のRiverpod + Flutter Hooks
- 画面遷移用の go_router
- データモデル用のFreezed

## コードの書き方
domain と data はこの形にそろえてある。app はまだそろえていない。

- import は相対パスにせず `package:` の形で書く。`dart:`・外部のパッケージ・このアプリのパッケージ（`package:domain/` など）の順にまとめ、まとまりの間に空行を入れる。domain と data は lint（`always_use_package_imports`）で相対パスを禁じている。テストの中でテスト用のファイルを読むときだけは相対パスで、最後のまとまりにする
- コメントは、コードを読んでもわからないこと（そうしている理由・型や名前に表れない約束・名前だけでは意味の取れないもの）だけを書く。コードを言い直すコメントや、設計の方針（このファイルに書く）はコードに書かない。コメントとコードを二重に管理しないため

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
