#!/usr/bin/env python3
"""Subscription-backed, read-only second opinions for this repository."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args]).decode().strip()


def fingerprint(root):
    digest = hashlib.sha256(git(root, "rev-parse", "HEAD").encode())
    digest.update(subprocess.check_output(["git", "-C", str(root), "diff", "HEAD", "--binary"]))
    paths = subprocess.check_output(["git", "-C", str(root), "ls-files", "--others", "--exclude-standard", "-z"])
    for name in sorted(filter(None, paths.split(b"\0"))):
        path = root / os.fsdecode(name)
        digest.update(name)
        digest.update(os.readlink(path).encode() if path.is_symlink() else path.read_bytes())
    return digest.hexdigest()


def environment():
    env = os.environ.copy()
    # The bridge must not silently switch an existing subscription to API billing.
    for name in ("OPENAI_API_KEY", "CODEX_API_KEY", "OPENAI_BASE_URL", "ANTHROPIC_API_KEY",
                 "ANTHROPIC_AUTH_TOKEN", "ANTHROPIC_BASE_URL", "CLAUDE_CODE_USE_BEDROCK",
                 "CLAUDE_CODE_USE_VERTEX", "CLAUDE_CODE_USE_FOUNDRY"):
        env.pop(name, None)
    return env


def executable(root, provider):
    common = Path(git(root, "rev-parse", "--path-format=absolute", "--git-common-dir")).parent
    config = common / ".conductor/ai-team.local.json"
    value = json.loads(config.read_text()).get(provider) if config.exists() else None
    path = value or shutil.which(provider)
    if not path or not os.access(path, os.X_OK):
        raise RuntimeError(f"{provider} が見つかりません。.conductor/ai-team.local.json を確認してください。")
    return path


def check_auth(binary, provider, env):
    cmd = [binary, "login", "status"] if provider == "codex" else [binary, "auth", "status"]
    result = subprocess.run(cmd, env=env, capture_output=True, text=True, timeout=30)
    if provider == "codex":
        valid = result.returncode == 0 and "Logged in using ChatGPT" in result.stdout + result.stderr
    else:
        data = json.loads(result.stdout or "{}")
        valid = result.returncode == 0 and data.get("loggedIn") and data.get("authMethod") == "claude.ai"
    if not valid:
        raise RuntimeError(f"{provider} の月額契約ログインを確認できません。APIへの切り替えは行いません。")


def run_agent(root, provider, prompt, output, timeout):
    binary, env = executable(root, provider), environment()
    check_auth(binary, provider, env)
    if provider == "codex":
        cmd = [binary, "--no-daemon", "-a", "never", "exec", "--ignore-user-config", "--ephemeral",
               "--sandbox", "read-only", "--model", "gpt-6.1-sol", "-c", 'model_reasoning_effort="high"',
               "--output-last-message", str(output), "-"]
    else:
        cmd = [binary, "--print", "--model", "opus", "--effort", "high", "--output-format", "json",
               "--no-session-persistence", "--restricted", "--strict-mcp-config",
               "--tools", "Read,Glob,Grep", "--allowedTools", "Read,Glob,Grep",
               "--permission-mode", "dontAsk"]
    result = subprocess.run(cmd, input=prompt, cwd=root, env=env, capture_output=True, text=True, timeout=timeout)
    if result.returncode:
        output.unlink(missing_ok=True)
        raise RuntimeError(f"{provider} が終了コード {result.returncode} で失敗しました。\n{result.stderr[-1800:]}")
    if provider == "claude":
        data = json.loads(result.stdout)
        if data.get("is_error") or data.get("subtype") != "success":
            raise RuntimeError("Opusの相談が完了しませんでした。レビュー成功として扱わないでください。")
        output.write_text(data.get("result", ""))
    if not output.exists() or not output.read_text().strip():
        raise RuntimeError("回答が空でした。相談・レビューは未完了です。")


def link_skills(root):
    canonical = root / ".agents/skills"
    alias = root / ".claude/skills"
    if alias.is_symlink():
        if alias.readlink() != Path("../.agents/skills"):
            raise RuntimeError(".claude/skills が別のリンク先を指しています。既存リンクを確認してください。")
        canonical.mkdir(parents=True, exist_ok=True)
        return
    entries = []
    if alias.exists():
        if not alias.is_dir():
            raise RuntimeError(".claude/skills がディレクトリではありません。既存ファイルを確認してください。")
        entries = list(alias.iterdir())
        conflicts = [entry.name for entry in entries
                     if (canonical / entry.name).exists() or (canonical / entry.name).is_symlink()]
        if conflicts:
            raise RuntimeError("両方に同名スキルがあります。内容を統合してから再実行してください: " + ", ".join(sorted(conflicts)))
    canonical.mkdir(parents=True, exist_ok=True)
    for entry in entries:
        entry.rename(canonical / entry.name)
    if alias.exists():
        alias.rmdir()
    alias.parent.mkdir(parents=True, exist_ok=True)
    alias.symlink_to("../.agents/skills", target_is_directory=True)


def bootstrap(root):
    source = Path(__file__).resolve().parent.parent
    link_skills(root)
    files = ["AGENTS.md", "scripts/ai_team.py"]
    files += [str(path.relative_to(source)) for path in (source / ".agents/skills").rglob("*")
              if path.is_file()]
    for name in files:
        destination = root / name
        if destination.exists() or destination.is_symlink():
            continue
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source / name, destination)
    ignore = root / ".gitignore"
    contents = ignore.read_text()
    additions = [line for line in ("/.context/", "/.conductor/*.local.*", "**/__pycache__/")
                 if line not in contents.splitlines()]
    if additions:
        ignore.write_text(contents.rstrip() + "\n\n" + "\n".join(additions) + "\n")
    print("AI連携ファイルを配置しました（既存ファイルは上書きしません）。")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["init", "consult-sol", "consult-opus", "review", "status", "bootstrap"])
    parser.add_argument("--request", type=Path)
    parser.add_argument("--timeout", type=int, default=600)
    args = parser.parse_args()
    root = Path(git(Path.cwd(), "rev-parse", "--show-toplevel"))
    if args.mode == "bootstrap":
        bootstrap(root)
        return
    context = root / ".context/ai-team"
    state_file = context / "task.json"
    if args.mode == "init":
        if state_file.exists():
            print("既存タスクを継続します。別の作業は新しいConductorワークスペースで開始してください。")
            return
        context.mkdir(parents=True, exist_ok=True)
        state_file.write_text(json.dumps({"base": git(root, "rev-parse", "HEAD")}, indent=2) + "\n")
        print("タスクの開始コミットを保存しました。次に brief.md へ目的と受入条件を記録してください。")
        return
    if not state_file.exists():
        raise RuntimeError("先に init を実行してください。開始時点が不明なまま差分をレビューしません。")
    state = json.loads(state_file.read_text())
    base = state["base"]
    git(root, "rev-parse", "--verify", base + "^{commit}")
    brief = context / "brief.md"
    if args.mode == "status":
        print(json.dumps({"base": base, "brief_exists": brief.exists(), "fingerprint": fingerprint(root)}, indent=2))
        return
    if not brief.exists() or not brief.read_text().strip():
        raise RuntimeError(".context/ai-team/brief.md に目的・制約・受入条件を記録してください。")
    if args.mode.startswith("consult") and not args.request:
        raise RuntimeError("相談は --request <質問を記録したファイル> が必要です。")
    request = args.request.read_text() if args.request else ""
    common = (
        "日本語で回答してください。コードやファイルを変更しない読み取り専用の相談です。"
        "CLAUDE.mdとAGENTS.mdを読み、次の目的・受入条件を実コードと照合してください。"
        "他のAIや相談スクリプトを呼び出さないでください。秘密情報や環境設定の値を読まないでください。\n"
        f"開始コミット: {base}\n目的・受入条件:\n{brief.read_text()}\n"
    )
    if args.mode == "review":
        prompt = common + (
            "\n実装者との会話や .context/ai-team 内の過去の相談・レビューを読まず、独立して最終レビューしてください。"
            "git diff <開始コミット> と git status --short を使い、コミット済み・未コミット・未追跡の変更を確認してください。"
            "最初に問題設定・データモデル・受入条件の不足を検討し、その後に具体的な不具合を探してください。"
            "推測は推測と示し、指摘には重要度・ファイルと行・再現条件・影響を付けてください。"
            "根拠のない好みや儀礼的な指摘は不要です。検証できない部分も示してください。"
            "冒頭は『判定: 問題なし』『判定: 要修正』『判定: 要確認』のいずれかにしてください。\n"
            f"実行した検証の記録（自己評価ではなく事実）:\n{request}\n"
        )
    else:
        prompt = common + "\n問いの前提を検証し、自分の推奨と根拠・反証条件を示してください。\n" + request
    before = fingerprint(root)
    provider = "claude" if args.mode == "consult-opus" else "codex"
    label = time.strftime("%Y%m%d-%H%M%S") + "-" + args.mode
    with tempfile.TemporaryDirectory(prefix="ai-team-") as temporary:
        output = Path(temporary) / "answer.md"
        run_agent(root, provider, prompt, output, args.timeout)
        answer = output.read_text()
    after = fingerprint(root)
    report = context / (label + ".md")
    report.write_text(f"開始コミット: {base}\n対象の指紋: {before}\n\n" + answer)
    print(answer)
    print(f"\n保存先: {report}")
    if before != after:
        raise RuntimeError("相談中に作業ツリーが変わりました。この回答を現時点の最終レビューとして扱わないでください。")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, ValueError, OSError, subprocess.SubprocessError) as error:
        print(f"AI連携エラー: {error}", file=sys.stderr)
        sys.exit(1)
