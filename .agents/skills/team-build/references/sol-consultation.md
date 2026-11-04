# 実装中のSolへの相談

Opusが実装方針の比較、原因調査の行き詰まり、既存コードとの整合性で迷ったときに使う。Pythonの補助スクリプトを介さず、Codex CLIを直接呼ぶ。通常の実装判断やユーザーが決める要件はOpusが引き続き担当する。

## 相談の範囲と記録

- 自分で関連コードと再現条件を確認してから、判断に影響する疑問を相談する。ユーザーがその都度相談を指示する必要はない。相談後の根拠ある反論・追加質問もOpusが行う。
- 相談用Solはコードを読む助言者。コード・仕様書・共有記録の編集、別エージェントの呼び出し、PRへの投稿は依頼しない。`team-build` / `team-review` の担当を引き継がせない。
- 相談中はOpusも対象コードを編集しない。相談後にコードが変わったら、回答が現在の版でも成立するかを確認する。
- 相談ごとに `.context/ai-team/consultations/` 内へ専用ディレクトリを作る。同じ実装タブの同じ論点では、そのディレクトリのセッションIDを再利用する。別論点・別タブ・別ワークスペースとは分ける。
- 質問、回答、イベント、セッションIDを保存し、`implementation.md` に相談先と採否・根拠を残す。Opusが回答を検証して実装を決め、要件変更が必要ならユーザーへ戻す。
- レビュー担当のSolタブやそのセッションIDは使わない。相談を独立レビューの完了として扱わず、レビュー記録も変更しない。

## 実行前の確認

作業中のワークツリーをカレントディレクトリにする。`sol_codex` にはConductorの設定で指定されたCodex実行ファイルを使い、指定がなければ `command -v codex` で見つけた実行ファイルを設定する。`jq` が利用できることも確認する。

```bash
env -u OPENAI_API_KEY -u CODEX_API_KEY -u OPENAI_BASE_URL "$sol_codex" login status
```

`Logged in using ChatGPT` を確認してから進む。API認証への切替や、権限エラーを避けるためのサンドボックス無効化は行わない。実行ファイル・認証・CLIオプションに問題があれば、その状態を報告し、呼び出せていないSolの意見を作らない。

## 最初の相談

```bash
mkdir -p .context/ai-team/consultations
sol_dir="$(mktemp -d .context/ai-team/consultations/sol-XXXXXX)"
```

`$sol_dir/question-001.md` をファイル編集ツールで作る。以下を含める。

- 「あなたはOpusの実装相談専用Solです。AGENTS.mdと対象に応じた設計資料を読み、読み取り専用で助言してください。team-build/team-reviewの担当は引き継がず、コードや共有記録の変更・PR投稿・別エージェントの呼び出しは行わないでください。認証情報や環境設定の値は読まないでください。」
- 目的・合意済みの受入条件、現在のHEADと未コミット変更の有無、関係するファイル、再現条件、試したこと、検討している案と迷っている点。
- 実装者の案に同調せず、前提の誤り、見落とし、推奨と根拠を示してほしいこと。

```bash
env -u OPENAI_API_KEY -u CODEX_API_KEY -u OPENAI_BASE_URL \
  "$sol_codex" --no-daemon -a never exec \
  --ignore-user-config --model gpt-6.1-sol --sandbox read-only \
  -c 'model_reasoning_effort="high"' --json \
  --output-last-message "$sol_dir/answer-001.md" - \
  < "$sol_dir/question-001.md" > "$sol_dir/events-001.jsonl" 2> "$sol_dir/stderr-001.log"
```

終了コード0、イベントの `turn.completed`、空でない回答を確認する。`error` / `turn.failed` や空回答は相談成功として扱わない。成功後にセッションIDを保存する。

```bash
jq -ers '[.[] | select(.type == "thread.started") | .thread_id] | if length == 1 then .[0] else error("session ID is not unique") end' \
  "$sol_dir/events-001.jsonl" > "$sol_dir/session-id"
```

## 同じ相談を続ける

続きの質問を `$sol_dir/question-002.md` に書く。自分の検討結果・反論と、前回から変わった事実を含める。以降も番号を増やし、質問・回答を上書きしない。再開時も月額ログインを確認する。

```bash
sol_session="$(cat "$sol_dir/session-id")"
env -u OPENAI_API_KEY -u CODEX_API_KEY -u OPENAI_BASE_URL \
  "$sol_codex" --no-daemon -a never exec resume \
  --ignore-user-config --model gpt-6.1-sol \
  -c 'sandbox_mode="read-only"' -c 'model_reasoning_effort="high"' --json \
  --output-last-message "$sol_dir/answer-002.md" "$sol_session" - \
  < "$sol_dir/question-002.md" > "$sol_dir/events-002.jsonl" 2> "$sol_dir/stderr-002.log"
```

最初と同じ成功条件に加え、`thread.started` のIDが保存済みIDと一致することを確認する。`--last` や `--ephemeral` は使わない。IDが不明・再開に失敗した場合は別セッションへ勝手に繋がず、記録を確認する。復旧できなければユーザーへ状態を伝える。

[Codex CLIの非対話実行とセッション再開](https://learn.chatgpt.com/docs/non-interactive-mode)
