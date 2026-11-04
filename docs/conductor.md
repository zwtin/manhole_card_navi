# Conductorで3つの担当との会話を続ける

更新日: 2026-11-04

同じワークスペースに3つのチャットタブを作る。各タブでモデルを選び、最初に一度だけ担当スキルを使う。その後は普通のメッセージで相談を続ける。成果物ができても担当は終了せず、ユーザーが明示的に変更するまで続く。

| タブ | 最初の操作 | 以降のメッセージ例 |
| --- | --- | --- |
| 設計 | Astraを選び `/team-design 作りたいもの` | 「この要件を変えたい」「この例外も考慮して」 |
| 実装 | Opusを選び `/team-build`。仕様書なしなら依頼内容も添える | 「ここを修正して」「PRを作って」「R1の対応要否を検討して」「その指摘に対応して」 |
| レビュー | Solを選び `/team-review PR番号またはURL` | 「R2は不要では？」「修正を確認して」「その指摘を訂正して」 |

Codexではスキル一覧から `team-design` / `team-review` を選んでもよい。スキル自体はモデルを切り替えないので、モデルはConductorのUIで選ぶ。

今回の更新を適用する最初の開始時は、新しい3つのチャットタブを使う。開始後は同じタブを使い続け、再レビューのたびに新しいチャットを作る必要はない。スキルを再指定しても成果物や指摘の記録を初期化しない。

Astraは、ワークツリー内の `.context/ai-team/spec.md` を会話に合わせて更新する。合意済みの内容、検討中の案、未決事項を区別する。仕様書ができても実装へ自動で進まず、設計を再相談すれば同じ仕様書を更新する。

Opusは仕様書を読んで実装・検証する。直接の依頼から始めてもよい。実装が一度できた時点では結果を報告し、追加の修正依頼にも対応する。あなたが「PRを作って」と依頼した時点で、対象変更をコミット・pushしてPRを作る。

実装中にOpusが判断に迷った場合は、`team-build` がCodex CLIで相談用Solを呼び出す。相談のための追加タブは不要。同じ論点では専用のセッションIDで会話を続ける。相談用Solは読み取りと助言を担当し、Opusが採否を判断して実装する。相談記録は `.context/ai-team/consultations/` に置き、レビュー担当Solのセッションと記録は分ける。実行手順は [実装中のSolへの相談](../.agents/skills/team-build/references/sol-consultation.md) を参照。

PR作成後もOpusのタブを使い続ける。「この指摘は正しい？」には妥当性を説明し、「対応して」には必要な実装・検証と同じPRへの反映を行う。「検討だけ」「ローカル修正だけ」「pushしない」などを指定した場合は優先する。マージは別の明示依頼が必要。

Solは初回にPRとコードから独立してレビューし、その後の反論や再確認は同じチャットで続ける。指摘が誤っていれば撤回・訂正し、PR上の当該投稿も更新する。修正後は最新コミットと前回からの差分を確認し、「実装者が対応済みと報告した」ことと「Solが対応を確認した」ことを区別する。

PRレビューの依頼には結果投稿も含む。「チャットだけ」「投稿せず検討して」と指定することもできる。PRがまだない場合はレビュー担当として待機でき、作成前のローカル変更を確認してほしいと明示すればPRレビューと区別して確認する。

3つのタブで会話履歴が自動共有される前提にはしていない。引き継ぎは次の共有ファイルとPRを通じて行う。

| 記録 | 更新担当 | 内容 |
| --- | --- | --- |
| `.context/ai-team/spec.md` | Astra | 仕様の版、合意事項、提案、未決事項 |
| `.context/ai-team/implementation.md` | Opus | 実装・検証結果、指摘の採否と対応、PR URL・コミット |
| `.context/ai-team/reviews/pr-<番号>.md` | Sol | 指摘ID、根拠、状態、確認コミット、PR投稿へのリンク |

各担当は他の記録を読めるが、上書きしない。指摘の状態は未解決・対応確認済み・撤回・保留を必要に応じて使う。通常の会話はタブで続け、別タブに作業を頼むときはそのタブへ移動して依頼する。

レビューは通常 `COMMENT` として投稿する。レビュー本文と行コメントはそれぞれ対応する更新機能で訂正できる。[GitHubのレビュー本文の更新](https://docs.github.com/en/rest/pulls/reviews#update-a-review-for-a-pull-request)、[行コメントの更新](https://docs.github.com/en/rest/pulls/comments#update-a-review-comment-for-a-pull-request)。この運用でブランチ保護を変更したり回避したりはしない。

Runメニューの `setup` は開発環境の再準備、`check` は静的解析・規約チェック・全テスト。日常の担当間の往復では、これらの操作やスキルの再実行は不要。

設定ファイル:

- 共通ルールと作業別資料の参照条件: `AGENTS.md`（`CLAUDE.md` は `@AGENTS.md` の1行）
- 共通レビュー基準: [コードレビュー](code-review.md)（Conductorのレビュー機能・`team-review`で共有）
- スキル本体: `.agents/skills/<名前>/SKILL.md`（追加・編集はここだけで行う）
- Claude Codeの参照先: `.claude/skills` → `../.agents/skills`（相対シンボリックリンク）
- 共有設定: `.conductor/settings.toml`
- Mac固有の上書き: `.conductor/settings.local.toml`（Git管理外）

`prompts.general` と `prompts.code_review` は `AGENTS.md` への参照指示だけを持つ。共通ルールは `AGENTS.md`、レビュー基準はそこから案内する `docs/code-review.md` で更新する。

`team-design` / `team-build` / `team-review` に加え、既存の `update-master` / `cleanup-old-images` も同じ場所で管理する。Claude Codeでは `/team-build` などの名前で呼び出せる。同名の `.claude/commands` は置かない。リンク先は各ワークツリー内なので、別ワークツリーのスキルを直接編集することはない。

共有Conductor設定はデフォルトブランチへ取り込んだ後に反映される。取り込む前に試す場合は、ローカルの上書き設定を使う。必要なモデルが表示されない場合は、利用するCodex・Claude Codeの実行ファイルをローカル設定で指定する。

共通設定・スキルを含むブランチからワークスペースを作ると、共通ルール・設計資料・スキルと `.claude/skills` の相対シンボリックリンクはGitから配置される。既存のワークスペースで使う場合も、この変更を含むコミットを取り込む。設定ファイルの補完やスキル移行のための独自スクリプトは不要。

ワークスペース作成時のsetupは、`lefthook install` と既存の `scripts/setup_worktree.sh` を実行する。設定ファイル、署名ファイル、依存取得、コード生成、iOS設定の詳細は [開発・検証手順](development.md) を参照。

実装中の相談には `team-build` の [Solへの相談手順](../.agents/skills/team-build/references/sol-consultation.md) を使う。相談にはChatGPTでログインしたCodex CLIを使い、実行ファイルはConductorのCodex設定に合わせる。API認証への切替は行わない。

アプリの検証は `AGENTS.md` と [開発・検証手順](development.md) に従う。
