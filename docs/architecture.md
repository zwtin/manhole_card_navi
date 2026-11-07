# 共通・データ層の設計

層の境界、domain・data、依存性注入、失敗の扱いを設計・実装・レビューする前に、関係する節を読む。画面の詳細は [画面の設計](app-architecture.md) を参照。

## パッケージ構成
クリーンアーキテクチャの層ごとに `packages/` 配下のパッケージに分けています。依存の向きは `app → domain ← data` で、app と data は互いを知りません。

1. **domain** (`packages/domain/`) - 他のパッケージにも Flutter にも依存しない中心。provider の宣言には Flutter を含まない `riverpod` 本体を使う（`hooks_riverpod` は使わない）
   - `core/` - エンティティではない、操作の結果を表す共通の型。成功か失敗かを包む `Result` と、失敗の種類 `DomainException`。Flutter の Clean Architecture でよく見る `core/error/` と同じ位置づけ
   - `entity/` - アプリが扱うもの（カードのように ID で区別するものと、座標やバージョンのように値そのものに意味があるもの）。値で完結する性質は値の型に置く（`Coordinate` は作った時点で緯度・経度が範囲内であることを保証し、範囲外・NaN・無限大は `FormatException`。`AppVersion` の比較、`SearchCondition.activeFilterCount` も同じ）
   - `repository/` - リポジトリインターフェースと、その provider
   - `usecase/` - ビジネスロジックの実装と、その provider。エンティティや bool をそのまま返し、画面用の型に詰め替えない
     - クラスは、扱うもの（エンティティ）ごとに 1 つ（`CardUseCase`・`AppInfoUseCase` など）。そのエンティティの保存に付随する取得・変換は、別の Repository を使っても同じクラスに置く（`CardBrowsingSettingsUseCase.save` は、検索条件で全弾を選んだかをカードから確かめて未選択にそろえてから保存する）。どのエンティティにも属さない独立した手順だけ、手順ごとのクラスにする（`CheckMasterUpdateUseCase`）。1 つのユースケースに 1 クラスにすると、Repository を素通しするだけのクラスが大半になるため
     - 画面が既に持っている値だけで済む処理は、Repository を読まずに引数で受ける同期のメソッドにする（`CardUseCase.filter` は、読み込み済みのカードと取得済みを受けて検索条件で絞り込む）。読み直すと、画面が表示している値と別の時点の値で処理することになるため。Repository を使う段取りと、カード・条件・取得済みのように複数の値を組み合わせる判定は UseCase に置き、そのためだけの Specification・DomainService などは作らない。画面の mapper には業務の判定を置かない
     - 利用者がまとめて選んで保存する設定は、まとめた型で保存する（`CardBrowsingSettings` は絞り込みの `SearchCondition` とマップの見せ方の `MapDisplaySettings` の組）。型を分けても保存を分けると、片方だけ保存された状態ができるため

2. **data** (`packages/data/`) - domain のインターフェースの実装。組み立て（どの実装をどの部品で作るか）は持たず、実装クラスを公開するだけ
   - `repository/` - Repository の実装だけを置く。**外界に触るのは DataSource 経由だけで、SDK を直接持たない。** DataSource から model を受け取り、mapper でエンティティにして返す。複数の DataSource の組み合わせも、別々のドキュメントどうしが食い違っていないか（カードが指す都道府県があるか など）を確かめるのもここで行う。例外を捕まえるのは data の中でここだけで、捕まえたら記録し、`DomainExceptionMapper.from` で種類に変換して `Result` に包む
   - `datasource/` - 外界と話すクラス。**Repository は DataSource としか話さない**ので、外界は素通しでも必ずここで包む（包むか判断しないで済むようにするため）。返すのは model か素の値で、SDK の型もエンティティも外に出さない。domain を知らないので、失敗は package が定義した例外（`CheckedFromJsonException`・`FormatException` など）のまま投げる。失敗の種類にするのは Repository。**DataSource は例外を捕まえない**（壊れたファイルを消す など、後片付けをして投げ直すときだけ捕まえてよい）。握りつぶすと、どこで何が起きたかが誰にも見えなくなる
     - **DataSource は 1 つの外界だけを相手にし、単体で独立させる。** DataSource の中に別の DataSource やサービスを持たない。複数の外界を組み合わせる（片方でだめならもう片方、取れたら計測する など）のは Repository の役目
     - `MasterDataLocalDataSource`: 取り込んだマスターデータ（配信のバージョンとカード一式の組、`LocalMasterDataModel`）を 1 つの JSON ファイルで持つ。読み書きは 1 つずつ順に行い、読んでいる間に終わった書き込みを古い内容で戻さない
     - `RemoteConfigDataSource`: Remote Config の取得（起動時の `activate`）と読み取り（空なら取り直す）。取り直さない時間は環境で変わるので、ルートから渡す。同じく環境で変わるアプリ名も、ルートが `AppInfoRepositoryImpl` に渡す（data は `String.fromEnvironment` を読まない）
     - `CardImageDataSource`: カード画像を、端末のキャッシュから読む／URL から取って保存する
     - `AnalyticsDataSource`: アプリのイベントを Analytics に送る。イベント名とパラメータへの置き換えは `AnalyticsEventMapper`
     - `MasterDataRemoteDataSource`: サーバー（Firestore）が配信するマスターデータ
     - `PreferencesDataSource`: 端末に保存する利用者の設定・取得済みカード（SharedPreferences）。書き込みは保存できたかを bool で返し、失敗として扱うかは Repository が決める
     - `AuthDataSource`: 匿名ログイン。返すのは利用者の ID だけ
     - `PushNotificationDataSource` / `PackageInfoDataSource` / `LocationDataSource` / `AppBadgeDataSource`: 通知の許可・アプリ自身の情報・位置情報・アプリのバッジ
     - `CrashlyticsDataSource`: Crashlytics への記録。アプリの中で Crashlytics を触るのはここだけ
   - `model/` - 外の形（Firestore のドキュメント・端末の JSON ファイル・保存した検索条件）をそのまま表すクラス。model 以外は置かない。JSON との変換は json_serializable で生成する。外から受け取ったものは `checked: true` で読み、形が違えば生成コードが `CheckedFromJsonException` を投げる。型だけでは表せない約束（座標の範囲、マスターのバージョンが空でない・カードが 0 件でない）は model のコンストラクタで確かめて `FormatException` を投げ、作れた model は使えるものにする（data の model は domain を知らないので、`Coordinate` と同じ範囲をここでも確かめる）。保存する値の enum も model が持ち、値の名前を保存する文字列にそろえる（domain の名前を変えても保存済みの値は変わらない）。エンティティは JSON を知らない
   - `mapper/` - model とエンティティ・model どうしの変換（`toCard`・`toModel`・`toLocalCard` など、出力するもので名前を付ける）と、外の例外から失敗の種類への変換（`DomainExceptionMapper.from`）。model が形を保証しているので、mapper は詰め替えるだけで例外を投げない

3. **app** (`packages/app/`) - 画面。View・表示用データ・ViewModel・mapper・テーマの構成は [画面の設計](app-architecture.md) を参照。

4. **ルート** (`lib/`) - アプリを組み立てる場所（Composition Root）。`main.dart` で Firebase を初期化し、`di/` で data の実装を domain の provider に当てはめる
   - `di/infrastructure.dart` - data の Repository が共有する部品（SharedPreferences・PackageInfo・Remote Config・JSON ファイル・記録）を起動時に 1 回だけ作る `Infrastructure`
   - `di/repository_overrides.dart` - domain の Repository の provider に data の実装を当てはめる override の一覧
   - `uncaught_error_observer.dart` - provider の生成中のバグをクラッシュとして記録する `ProviderObserver`。`main.dart` の Zone・`FlutterError.onError` と合わせて、クラッシュの記録はルートに集める

## 依存性注入
- Repository の provider は domain で `throw UnimplementedError` として宣言し、ルートの `lib/di/repository_overrides.dart` が data の実装に差し替える。どの実装を、どの部品で作るかを知っているのはルートだけ。app の中で閉じる `NavigationService` は、app で実装を返す provider を宣言する
- provider の寿命
  - Repository は状態を持たないか、アプリ全体で共有するもの（端末に取り込んだマスターデータなど）なので、`autoDispose` にせずアプリ全体で 1 つにする
  - UseCase も状態を持たない（状態は ViewModel か data に置く）ので、画面ごとに分けず（`family` にせず）、`autoDispose` にもせずアプリ全体で 1 つにする。クリーンアーキテクチャ・DDD の慣習でも、UseCase（アプリケーションサービス）に求められるのは状態を持たないことで、寿命は決めごとにしていない
  - ViewModel は画面の状態を持つので、画面の寿命に合わせて `autoDispose` にする
  - アプリ全体で 1 つの Repository・UseCase は、ふだんはアプリが動いている間ずっと共有するが、明示的な `invalidate` や `ProviderContainer` の破棄では dispose される。閉じる必要のある資源（StreamController・HTTP クライアントなど）を持つクラスだけ `dispose` を作り、作った provider の `ref.onDispose` に登録する。待っている間に dispose されることもあるので、待った後に閉じた資源へ書き込まない（`LocationRepositoryImpl.requestPermission`）。別の持ち主の資源（共有の DataSource や SDK）は閉じない
- テストでは `ProviderContainer(overrides: [...])` でモックに差し替える

## UseCase・Repository の引数
- 既にあるものを探す・指す・消すときは ID で渡す（`CardUseCase.get(id:)`、`AlreadyGetCardRepository.save(cardId:)`、サーバーのマスターデータを指す `MasterDataRepository.replace(version:)`）。UseCase が Repository から正しいエンティティを読み直す
- 保存する中身や新しく作るものは、値やエンティティで渡す（`CardBrowsingSettingsRepository.save(settings:)`）
- ID は値オブジェクトにせず String のまま扱う

## 失敗の扱い
- Repository は想定内の失敗（通信・サーバーのデータ・端末の保存領域）を投げずに `Result` に包んで返す。呼ぶ側は try / catch せずに `switch` で成功と失敗を分ける
- 失敗の種類は domain の `DomainException`（sealed）で表す。表示の文言は持たない。種類は app が表示や対応を変えたいものの分だけ作り、区別が必要になったら足す
- data は外の例外を `DomainExceptionMapper.from` で種類に変換する。変換は例外の型 1 つで決まる（外界ごとに変換器を分けない）ので、判定は狭い型から順に当てる。サーバーのデータはキャストに頼らず型を確かめ、合わなければ `CheckedFromJsonException` を経て `CorruptedDataException` にする
- app は `NavigationService.showFailure(title:, exception:)` で知らせる。タイトルは何に失敗したか（画面が決める）、本文は `ErrorMessageMapper` が種類から決める
- バグ（Error）は `Result` に包まずにそのまま流す
- 失敗ではない結果（位置情報を許可されなかった、アップデートが必要 など）は例外にせず戻り値で返す

## 失敗とバグの記録（Crashlytics）
Exception も Error も、すべて 1 回だけ記録する。ルールは 4 つ。

1. **記録するのは変換前の例外・Error と、捕まえたときのスタックトレース。** `DomainException` に変換した後のものを記録すると、原因の違うものが 1 つの issue に畳まれる。スタックトレースを `StackTrace.current` で補うのも同じ理由で禁止（記録した場所が発生行になる）
2. **最初に捕まえた場所で記録する。** 捕まえたらそこから先へは流れない
3. **捕まえないものは流す。** 根（`main.dart` の Zone・`FlutterError.onError`・`PlatformDispatcher.instance.onError`・ルートの `UncaughtErrorObserver`）が受け取って記録する
4. **記録できない場所では握りつぶさない。** app は Crashlytics を知らないので、握りつぶさずに流して根に拾わせる

- fatal か non-fatal かは種類で決めない。**根に届いた＝誰も扱わなかった＝ fatal、捕まえた＝扱った＝ non-fatal**
- Crashlytics を知っているのは data と `main.dart` だけ。app と domain は記録に関わらない
- data で捕まえるのは Repository だけ（`on Exception`）。Error は捕まえないので根まで流れる。Repository を通らない起動時の仕事（Remote Config の取得・前の世代が残したファイルの削除）は、ルートの `Infrastructure` が受け止める。Remote Config は取れなくても記録せずに続け（値が要るときに Repository が取り直して記録する）、ファイルの削除の失敗は非重大として記録する。`UncaughtErrorObserver` が `DomainException` を飛ばすのは、Repository で記録済みだから
- **非重大は 1 セッション 8 件まで**で、超えると古いものから消える（iOS SDK の `maxCustomExceptions` の既定値。サーバー設定 `max_custom_exception_events` で変えられる）。大量に出る事象を入れると、ほかの失敗が押し出される
- 画像の取得の失敗（`CardRepositoryImpl.fetchImage` のダウンロード）だけは Crashlytics に記録せず、Analytics の `image_load_failed`（`AnalyticsEvent.imageLoadFailed`）で数える。失敗の種類にこちらで名前を付けず、例外の型名（`runtime_type`）と OS が返したエラー（`os_error`。`WRONG_VERSION_NUMBER` なら経路上の装置が平文を返している、`nodename nor servname provided` なら DNS で潰されている）をそのまま送る。遮断された端末では画面 1 つで何十件も出て 8 件の枠を使い切るため。同じカードの「端末にない」「キャッシュが読めない」は画像の配信とは別の話なので記録する。`FlutterError.onError` が `library` の `image resource service` を記録しないのも同じ理由
- Crashlytics のグルーピングはスタックトレースだけでなく**例外のメッセージも見る**。Flutter の記録は例外の名前が `FlutterError` 固定で、`toString()` の文字列がメッセージになる（`reason` を渡すとそこに連結される）。**投げる `DomainException` の `detail` に可変の値を入れない**。同じ失敗が値ごとに別の issue に分かれてしまう。値を残したいときは `recordError` の `information` に渡す（ログ行になるだけで、グルーピングには影響しない）
- `CrashlyticsDataSource` の記録の失敗だけは Error も含めて捨てる。投げ直すと Zone から同じ記録を呼び直して堂々巡りになる

## データ層
- **リモート:** クラウドデータ用のFirebase Firestore
- **ローカル:** 取り込んだマスターデータは、配信のバージョン（Remote Config の値）とカード一式を 1 つの JSON ファイル（`MasterDataLocalDataSource`、`master_data.json`）に一緒に書き、マスターデータが変わるたびにこのファイルを上書きする。バージョンを別の場所に保存しないのは、片方だけ入れ替わって食い違わないようにするため。取り込み済みのバージョンは `MasterDataRepository.getCurrentVersion` がこのファイルから読み、`MasterVersionRepository` は使うべきバージョン（Remote Config）だけを返す。Firestore から取ったカードは、エンティティを通さずに端末に保存する形（`LocalCardModel`）にして書く。全件をまとめて読んでメモリに持ち、入れ替えは一時ファイルに書いてから名前を変えて行う。ファイルの形を変えてもファイル名は変えない。読めない中身は壊れたファイルとして消して記録し、利用者に知らせずにそのまま取り直す（`CheckMasterUpdateUseCase.getNeedUpdate` は、取り込み済みのバージョンを読めなければ更新が必要と返す）。利用者の設定・取得済みカードは SharedPreferences（検索条件とマップの表示は `search_condition` キーの 1 つの JSON で、`common` と `map` に分けて持つ）
- **コード生成:** イミュータブルモデル用のFreezed

## 主要な依存関係
- Firebaseスイート（Auth、Firestore、Storage、Analytics、Crashlyticsなど）
- Google Maps統合
- 状態管理用のRiverpod + Flutter Hooks
- 画面遷移用の go_router
- データモデル用のFreezed
