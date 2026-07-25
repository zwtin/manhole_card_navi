#!/usr/bin/env python3
"""旧 master バージョンの画像を Cloudflare R2 から削除する。

用途:
  - バージョン更新後、全端末が新バージョンへ移行しきった後の後片付け。
  - master/v{version}/ 配下のオブジェクトをまとめて削除する。

削除タイミングの注意（重要）:
  - master バージョンの切り替えは Remote Config（inquired_master_version）で行うが、
    端末側は次回の fetchAndActivate まで旧バージョンを参照し続ける。
  - また、旧アプリ（image_url 非対応）向けに Remote Config のアプリバージョン条件で
    旧 master を返し続けている間は、その旧バージョンの画像も生きている。
  - そのため新バージョン公開直後に旧画像を消すと、旧バージョンを見ている端末で
    画像が 404 になる。削除は「その世代を参照する端末が居なくなった後」に行うこと。
  - R2 のストレージは全 1264 枚で 200MB 弱（無料枠 10GB）。急いで消す必要はない。

認証:
  R2 の認証情報は環境変数から読む（r2_utils.py 参照）。
    R2_ACCOUNT_ID / R2_ACCESS_KEY_ID / R2_SECRET_ACCESS_KEY

使い方:
  # 削除対象の確認のみ（削除しない）
  python3 tools/delete_images_from_r2.py --version 0003 --project dev --dry-run

  # 削除（対話確認あり。バージョン番号の入力を求める）
  python3 tools/delete_images_from_r2.py --version 0003 --project dev

  # 確認なしで削除
  python3 tools/delete_images_from_r2.py --version 0003 --project prod --yes
"""
import argparse
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import r2_utils  # noqa: E402

# バージョン文字列に使える文字（パス区切りやワイルドカードを混ぜられないようにする）
VERSION_RE = re.compile(r"[0-9A-Za-z_-]{1,20}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True,
                    help="削除する master バージョン（例 0003）")
    ap.add_argument("--project", required=True, choices=list(r2_utils.PROJECTS),
                    help="対象プロジェクト（prod / dev）")
    ap.add_argument("--bucket", default=None, help="バケット名を明示指定（既定は project から解決）")
    ap.add_argument("--dry-run", action="store_true",
                    help="削除せず、対象件数のみ表示")
    ap.add_argument("--yes", action="store_true",
                    help="対話確認をスキップして削除する")
    args = ap.parse_args()

    # 誤削除防止: バージョン文字列の形を先に検査する（"" や "/" や ".." を弾く）
    if not VERSION_RE.fullmatch(args.version):
        sys.exit(f"バージョン指定が不正です: {args.version!r}（英数字・ハイフン・アンダースコアのみ）")

    bucket = r2_utils.bucket_of(args.project, args.bucket)
    prefix = f"master/v{args.version}/"

    # 誤削除防止: 対象接頭辞に master/v{version} が含まれることを確認してから削除する。
    if f"master/v{args.version}" not in prefix:
        sys.exit("安全確認に失敗しました（対象パスが想定と異なります）。中止します。")

    print(f"プロジェクト : {args.project}")
    print(f"バケット     : {bucket}")
    print(f"削除対象     : s3://{bucket}/{prefix}")

    s3 = r2_utils.client()
    try:
        keys = r2_utils.list_keys(s3, bucket, prefix)
    except Exception as e:  # noqa
        sys.exit(f"R2 の一覧取得に失敗しました（bucket={bucket}）: {type(e).__name__}: {e}")

    print(f"対象オブジェクト数: {len(keys)}")
    for k in keys[:5]:
        print(f"  {k}")
    if len(keys) > 5:
        print(f"  ... 他 {len(keys) - 5} 件")

    if not keys:
        print("\n対象オブジェクトがありません（既に削除済み or バージョン誤り）。")
        return

    if args.dry_run:
        print("\n（--dry-run のため削除しません）")
        return

    if not args.yes:
        print(f"\n{len(keys)} オブジェクトを削除します。取り消せません。")
        answer = input(f"続行するにはバージョン番号を入力してください（{args.version}）: ").strip()
        if answer != args.version:
            sys.exit("入力が一致しませんでした。中止します。")

    deleted = 0
    for i in range(0, len(keys), 1000):     # delete_objects は1回1000件まで
        group = keys[i:i + 1000]
        resp = s3.delete_objects(
            Bucket=bucket,
            Delete={"Objects": [{"Key": k} for k in group], "Quiet": True},
        )
        errs = resp.get("Errors") or []
        for e in errs[:5]:
            print(f"  [失敗] {e.get('Key')}: {e.get('Code')} {e.get('Message')}")
        deleted += len(group) - len(errs)
        print(f"  delete: {deleted}/{len(keys)}")

    left = r2_utils.list_keys(s3, bucket, prefix)
    print(f"\n削除完了: {deleted} オブジェクト。残 {len(left)} 件")
    if left:
        print("  ⚠️ 残りがあります。権限やエラー出力を確認してください。")


if __name__ == "__main__":
    main()
