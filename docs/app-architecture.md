# 画面の設計

`packages/app/` の画面、表示用データ、ViewModel、テーマ、画面遷移を設計・実装・レビューする前に、関係する節を読む。層の境界と失敗の扱いは [共通・データ層の設計](architecture.md) に従う。

## パッケージ構成

**app** (`packages/app/`) - 画面
   - `router/` - go_router のルート定義、画面遷移の窓口 `NavigationService` とその go_router による実装、下タブの `ShellScaffold`
   - `view/` - 画面（`*_page.dart`）
   - `view_model/` - 画面ごとの ViewModel
   - `view_data/` - 画面ごとの State（freezed）と表示用データ
   - **View・ViewData・widget は domain を知らない。** ViewData は表示の形（文字・bool・数）だけを持ち、domain の値を表示名や並び順にするのは mapper。編集中の条件のように画面が domain の値を持ち続けるときは、ViewModel の private な変数に置く。選択肢は「表示名と選ばれているか」で渡し、押されたものは何番目かで ViewModel に返す（番号を値に戻す並びは mapper が持つ）。例外はカード画像の `card_image_provider.dart` だけ（状態管理の節）
   - `widget/` / `mapper/` / `theme/` - 共通部品・変換・テーマ
   - **見た目はデザインシステムから選ぶ。** 文字は `AppText`（`widget/app_text.dart`）の名前付きコンストラクタ、色は `ColorScheme`（Material 3 の色の役割）から引く。役割に当てはまらない色だけ `AppColors`（`theme/app_colors.dart`、`ThemeExtension`）に置く。いまそこにあるのはリンク・カードの枠線・カードの影の 3 つだけ
   - `AppBar` の見出しは `AppBarTitle`。画面ごとに大きさや太さを決めない
   - **`ThemeData` を組む時点の `textTheme` には大きさが入っていない**（言語に応じた字形と合わせるのは画面を描くとき）。`appBarTheme.titleTextStyle` のようなところに `textTheme` から作った style を焼き込むと、大きさのない style になって既定値に落ちる。テーマに焼き込まず、描画時に読むウィジェット側で決める
   - 面の重なりは `surface`（画面の地）と `surfaceContainerLowest`（カード・リストの面）で表す。Material 3 はこの 2 つを、明るいテーマでは面のほうを明るく、暗いテーマでは面のほうを暗くする向きで定義している。`ColorScheme.background` のように**役割を自分の意味で使い回すと、フレームワークの移行（`dart fix`）に踏まれる**
   - 色の値そのものは `assets/colors/colors.xml` に名前を付けてから使う。画面で `Text`・`TextStyle`・`Color` を直接作らず、Material のパレット（`Colors.xxx`）も使わない（`scripts/check_app_rules.sh` が止める。塗らないことを表す `Colors.transparent` だけは許す。動かせない事情があるところは、その行の直前に `// ignore: <ルール名>` と理由を書く）。使っていない見た目も、そろえるために `AppText` に残す
   - `mapper/` は純粋な変換だけを置く。通信・保存・キャッシュを持たせない。マップのマーカーなら、ピンの選び方（`MapMarkersViewDataMapper`）と 1 枚の合成（`MarkerIconMapper`）が mapper で、画像を取る・並べる段取りと、合成した画像を控えておく（選び直すたびに合成し直さない）のは ViewModel の役目
   - `assets/` - 画面で使うアセット。flutter_gen の生成物は `lib/src/gen/`

## 状態管理（app）
- 1 画面 1 ViewModel 1 State。State は freezed
- 依存は、`build()` で使うものは `build()` の中で `ref.watch` してローカル変数にし（`await` より前に）、メソッドで使うものはその都度 `ref.read` する（`XxxUseCase get _xxxUseCase => ref.read(...)` のゲッターにする）。`build()` から呼ぶ補助メソッドには、watch した値を引数で渡す。**`late final` のフィールドに入れない。** Riverpod の Notifier は `build()` が走り直しても同じインスタンスを使い回すので、2 回目の代入で落ちる
- 読み込むだけの画面は `AsyncNotifier`（`build()` で取得）、起動時チェックやマップのように読み込みに副作用を伴う画面は `Notifier` にして View の `useEffect` から `onLoad()` を呼ぶ
- ViewModel は BuildContext を持たない。遷移・アラート・選択肢（`showChoice`）・URL を開く操作は `NavigationService` 経由で行う。画面や widget も自分でダイアログを出したり URL を開いたりせず、ViewModel に渡す（HTML のリンクなら `HtmlContent` の `onTapLink` で受け取って ViewModel へ）。OS で分ける判断は ViewModel が `defaultTargetPlatform` で行う（`dart:io` の `Platform` はテストで差し替えられない）
- **ViewModel は画面の部品（widget・地図の `GoogleMapController` など）を持たない**（`scripts/check_app_rules.sh` が止める）。部品を動かしたいときは指示を State に載せ、View が `ref.listen` で受け取って自分の部品を動かす。マップのカメラなら、ViewModel は `CameraMoveViewData` を出し、controller は View が `useRef` で持つ。同じ指示を続けて出しても届くよう、指示ごとに番号を振る
- ViewModel が読み書きするのは UseCase だけで、Repository を直接呼ばない。処理のない読み取りも、Repository を素通しする UseCase のメソッドを通す
- **ViewModel は他の ViewModel を読まず、画面は自分の ViewModel だけを読む**（`scripts/check_app_rules.sh` が止める）。画面をまたいで共有する状態は UseCase の watch で流す（取得済みカード・検索条件・位置情報の許可）。レイアウトの寸法は状態にせず、要る画面が自分の受け取った大きさ（constraints）から求める（マップとカードのモーダルの高さ）
- カード画像は、app の `CardImageProvider`（Flutter の `ImageProvider`）がカードの ID で `CardUseCase.fetchImage` から画像データを受け取って表示する。画像は Flutter の画像の仕組みで読み込むため、ここだけは ViewModel を通さない。View と widget はカードの ID を `cardImageProvider` に渡して受け取るだけで、UseCase を知っているのは `card_image_provider.dart` だけ。画像の URL・代わりの配信元・端末に保存するかは data だけが知っていて、エンティティにも画像の URL は持たせない

## 画面遷移（app）
- go_router の `StatefulShellRoute` で、マップ・リスト・設定のタブがそれぞれ独立した遷移スタックを持つ
- 起動時チェックは `go` で置き換えながら進み、タブの外に出す画面（検索条件・画像拡大・起動時の規約）は root Navigator に積む
- 起動時チェックの最初（アプリのバージョン確認の画面）で匿名ログインを済ませてから `app_open` を送る。イベントに利用者の ID が付いた状態でアプリを使ってもらうため。初回だけ通信が要り、できなければやり直す
- オフラインでも起動できる。起動時の Remote Config の取得（待ち時間 10 秒）は失敗しても止まらず前回の値で続け、マスターデータは端末のものを使う。前回の値がない初回は、起動時チェックが「通信できませんでした」を出してやり直す
- マップのカードモーダルもルート（`/map/card/:cardId`）で、ピンをタップして開いたときはピンの座標をクエリに載せる。モーダルはマップの表示エリア（AppBar より下）の 2/3 を覆い、マップはその分を地図の `padding` にして、ピンをモーダルの上の中央に出す（地図を縮めない。Google のロゴも見えている範囲に動く）。`padding` とカメラはシートと同じ長さと曲線で動かし、地図がモーダルと一緒に上へずれるようにする。`padding` を変えたときの地図の動きは SDK で違う（iOS はカメラの中心を保って地図をずらし、Android は見えている場所を保つ）ので、どちらかが動いている間は View が毎フレームカメラの中心を指定し直し、OS で分けずに同じ動きにする。モーダルがないときも、下タブの丸がはみ出す分（`ShellScaffold.tabBarOverlap`）を空けて、ロゴを隠さない。高さは受け渡さず、マップは自分の表示エリアから、モーダルはシートで使える高さ（ステータスバーより下）からマップの AppBar を除いて、どちらも `CardModalPage.heightIn` で求める
- 画面の引数は URL（パスとクエリ）に載せ、go_router の `extra` は使わない（URL に載らず、復元できない）。URL の組み立てと読み取りは `AppRoutePath` だけが行う。画像の拡大は、Hero が飛び始める時点で色を決めるため、取得済みかもクエリに載せる
- 戻る操作はタブ内の画面があればそれを閉じ、タブのルートでは `ShellScaffold` の `PopScope` がタブ切り替え／アプリ終了を決める
- PV は各画面の `useScreenView` が、GoRouter 上で最前面になったとき（表示・戻り・タブ切り替え）に送る
