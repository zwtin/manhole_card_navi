# このリポジトリの開発

このファイルを、このリポジトリで作業するすべてのエージェントの共通ルールとする。Flutterの操作は必ずFVM経由で行う。

常に日本語で応答する。提案の前に問題設定と前提を検証し、データモデルが現実を表しているかを優先する。指摘には根拠と具体的な次の行動を添える。コメントにはコードから読めない意図を書く。

## プロジェクト概要

マンホールカードナビ - 日本全国のマンホールカードを収集・ナビゲーションするためのFlutterモバイルアプリケーション。

## 作業に応じて読む資料

設計判断・編集・レビュー・コマンド実行の前に、次の条件で該当資料の関係する節を読む。資料のルールは対象作業にも適用する。新しい領域を扱うときは対応する資料を確認する。

| 作業 | 参照する資料 |
| --- | --- |
| アプリの設計・コード変更・レビュー（層の境界、domain・data、DI、失敗と記録） | [共通・データ層の設計](docs/architecture.md) |
| `packages/app/` の画面、ViewModel、表示、テーマ、画面遷移の設計・変更・レビュー | 上記に加えて [画面の設計](docs/app-architecture.md) |
| 実行・ビルド・検証・コード生成・環境設定・Gitフック・ワークツリーの準備や片付け | [開発・検証手順](docs/development.md) の該当節 |
| コード・設計のレビュー、指摘の妥当性の検討、修正後の再レビュー | [共通レビュー基準](docs/code-review.md) |
| Conductorの設定、担当タブの使い方、引き継ぎの運用 | [Conductorの使い方](docs/conductor.md) と担当スキル |

詳細ルールの更新は対応する資料で行い、このファイルには常時必要な原則と参照条件を保つ。

## 重要な設計原則

- 依存の向きは `app → domain ← data`。domain は Flutter に依存せず、app と data は互いを知らない。実装の組み立てはルートの `lib/` に置く。
- data の外界との通信は DataSource 経由にする。外界の model をエンティティへ変換するのは Repository。DataSource は単一の外界を相手にし、他の DataSource やサービスを持たない。
- View・ViewData・widget は domain を知らず、画面は自分の ViewModel だけを読む。ViewModel は UseCase を呼び、Repository・他の ViewModel・BuildContext・画面の部品を持たない。カード画像の例外を含む詳細は画面の設計に従う。
- UI は `AppText`、`AppBarTitle`、`ColorScheme`、`AppColors` を使う。色の値は `assets/colors/colors.xml` で管理する。mapper は純粋な変換にする。
- Repository の想定内の失敗は `Result` と `DomainException` で返し、バグ（Error）はそのまま流す。失敗とバグの記録は、設計資料の記録対象・例外に従い、変換前の例外と発生時のスタックトレースを使って重複を避ける。

## コードの書き方
domain・data・app ともこの形にそろえてある。

- import は相対パスにせず `package:` の形で書く。`dart:`・外部のパッケージ・このアプリのパッケージ（`package:domain/` など）の順にまとめ、まとまりの間に空行を入れる。domain・data・app・ルートとも lint（`always_use_package_imports`）で相対パスを禁じている。テストの中でテスト用のファイルを読むときだけは相対パスで、最後のまとまりにする
- コメントは、コードを読んでもわからないこと（そうしている理由・型や名前に表れない約束・名前だけでは意味の取れないもの）だけを書く。コードを言い直すコメントや、設計の方針（このファイルに書く）はコードに書かない。コメントとコードを二重に管理しないため

## 必須の検証とGit操作

- Flutter・Dartの操作は `fvm flutter` / `fvm dart` を使う。Dartコード変更時は静的解析、appの規約チェック、変更に対応するテストを行う。コマンドとコード生成の順序は開発・検証手順を参照する。
- Gitフックは lefthook で管理し、各ワークツリーで `lefthook install` する。コミット時は変更したDartの修正・整形・app規約チェック、push時は `fvm flutter analyze` と `./scripts/run_tests.sh` が走る。
- `git commit --no-verify` / `git push --no-verify` は使わない。`lefthook.yml` の `env -u GIT_DIR` はワークツリーでのFVM動作に必要なので外さない。
- ワークツリーの削除はユーザーの依頼時に行う。未コミット変更・未pushコミットがあれば削除せず、内容を示して確認する。署名・環境設定の共有とビルド生成先の扱いは開発・検証手順に従う。

## スキルの管理

スキルの本体は `.agents/skills/<名前>/SKILL.md` とその配下の関連ファイルで管理する。`.claude/skills` は `../.agents/skills` への相対シンボリックリンクとし、Claude専用のコピーや同名の `.claude/commands` を作らない。スキルの追加・編集は `.agents/skills` 側で行う。

## Conductorの継続する担当

- 同じワークスペース内で、`team-design` はAstraの設計タブ、`team-build` はOpusの実装タブ、`team-review` はSolのレビュータブに使う。選択モデルはユーザーがUIで設定する。
- ユーザーが選んだ担当は、そのチャットの後続メッセージにも適用する。後続ターンでも対応する `.agents/skills/team-<担当>/SKILL.md` を参照し、会話の要約にも現在の担当と継続中の作業を残す。通常の質問、別担当への言及、成果物の完成だけで担当を変えない。再実行で既存記録を初期化しない。
- 担当はチャット単位。他タブも切り替わる共有の「現在モード」を作らず、他タブの会話履歴が自動共有されるとは仮定しない。ユーザーが担当変更を明示した場合だけ切り替える。モデルを名乗るだけの代行はしない。
- 設計は仕様書を更新し続ける。実装は仕様書または直接の依頼から開始でき、PR作成はユーザーが明示的に依頼した時点で行う。PR後の指摘対応と再確認も同じ担当チャットで続ける。マージは別の明示依頼が必要。
- Opusは実装で判断に迷ったとき、`team-build` の相談手順で専用のSol CLIセッションへ相談する。相談は `.context/ai-team/consultations/` に記録し、PRレビュー担当のSolとはセッションを分ける。
- 共有記録は `.context/ai-team/spec.md`（Astra）、`implementation.md`（Opus）、`reviews/`（Sol）。各担当は他の記録を読めるが上書きしない。コードを書く主担当はOpus。独立レビューは任意で、スキルの自動選択だけで他担当へ移らない。
