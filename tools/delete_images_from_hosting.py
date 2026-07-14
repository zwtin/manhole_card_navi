#!/usr/bin/env python3
"""
旧 master バージョンの画像を Firebase Hosting から削除して再デプロイする。

用途:
  - バージョン更新後、全端末が新バージョンへ移行しきった後の後片付け。
  - master/v{version}/images/ ディレクトリを丸ごと削除し、再デプロイで反映する。

削除タイミングの注意（重要）:
  - master バージョンの切り替えは Remote Config（inquired_master_version）で行うが、
    端末側は次回の fetchAndActivate まで旧バージョンを参照し続ける。
  - そのため新バージョン公開直後に旧画像を消すと、まだ旧バージョンを見ている端末で
    画像が 404 になる。削除は「全端末が移行しきる猶予を置いた後」に行うこと。
  - 容量は全 1264 枚で 200MB 弱、無料枠 10GB に対し数世代残せる。急いで消す必要はない。

認証: firebase CLI（firebase login 済みであること）

使い方:
  # 削除対象の確認のみ（削除もデプロイもしない）
  python3 tools/delete_images_from_hosting.py --version 0002 --project prod --dry-run

  # ディレクトリ削除のみ（デプロイは手動）
  python3 tools/delete_images_from_hosting.py --version 0002 --project prod

  # 削除してそのままデプロイ
  python3 tools/delete_images_from_hosting.py --version 0002 --project prod --deploy
"""
import argparse
import os
import shutil
import subprocess
import sys

PROJECTS = {
    "prod": os.path.expanduser("~/Documents/github/firebase/manhole_card_navi"),
    "dev": os.path.expanduser("~/Documents/github/firebase/manhole_card_navi_dev"),
}


def run(cmd, cwd=None):
    print("  $", " ".join(cmd))
    result = subprocess.run(cmd, cwd=cwd)
    if result.returncode != 0:
        sys.exit(f"コマンド失敗（exit {result.returncode}）: {' '.join(cmd)}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True,
                    help="削除する master バージョン（例 0002）")
    ap.add_argument("--project", required=True, choices=list(PROJECTS),
                    help="対象プロジェクト（prod / dev）")
    ap.add_argument("--deploy", action="store_true",
                    help="削除後に firebase deploy --only hosting を実行する")
    ap.add_argument("--dry-run", action="store_true",
                    help="削除もデプロイもせず、対象のみ表示")
    args = ap.parse_args()

    hosting_dir = PROJECTS[args.project]
    target_dir = os.path.join(
        hosting_dir, "public", "master", f"v{args.version}")

    print(f"プロジェクト : {args.project} ({hosting_dir})")
    print(f"削除対象     : {target_dir}")

    if not os.path.isdir(target_dir):
        print("\n対象ディレクトリが存在しません（既に削除済み or バージョン誤り）。")
        return

    n_files = sum(len(files) for _, _, files in os.walk(target_dir))
    print(f"含まれるファイル数: {n_files}")

    if args.dry_run:
        print("\n（--dry-run のため削除しません）")
        return

    # 誤削除防止: 対象パスに master/v{version} が含まれることを確認してから削除。
    if f"master/v{args.version}" not in target_dir.replace(os.sep, "/"):
        sys.exit("安全確認に失敗しました（対象パスが想定と異なります）。中止します。")

    shutil.rmtree(target_dir)
    print(f"削除完了: {target_dir}")

    if args.deploy:
        print(f"\nデプロイ中（{args.project}）...")
        run(["firebase", "deploy", "--only", "hosting"], cwd=hosting_dir)
        print("デプロイ完了")
    else:
        print("\n（--deploy 未指定のため削除のみ。デプロイは手動で実行してください）")
        print(f"  cd {hosting_dir} && firebase deploy --only hosting")


if __name__ == "__main__":
    main()
