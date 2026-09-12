#!/usr/bin/env python3
"""現行の master バージョンを実地で調べ、次に発行するバージョン番号を算出する。

**バージョン番号をどこにもハードコードしないための入口。**
手順書やスクリプトに「次は 0007」と書くと、発行するたびに書き換えが要るうえ、
書き換え忘れると 1つ前のバージョンを上書きしてしまう。番号は毎回ここで取り直す。

何を見るか（すべて実地。推測しない）:
  - Firestore の master コレクションに存在するバージョン   … 発行済み master の正
  - Cloudflare R2 の master/v*/ 接頭辞                      … 主系の画像が置かれたバージョン
  - Firebase Hosting ローカルの public/master/v*/           … 代替の画像が置かれたバージョン
  - Remote Config の inquired_master_version               … 端末が実際に参照している値
    （取得できなければスキップ。Firebase コンソールで確認する）

次のバージョン = 上記で見つかった最大値 + 1（4桁ゼロ埋め）。
R2 や Hosting にだけ存在する番号も最大値の計算に入れる。
発行途中で中断した残骸を「空き番号」と誤認して上書きするのを防ぐため。

認証:
  gcloud auth login 済み（Firestore / Remote Config の読み取り）
  R2 の環境変数（R2_ACCOUNT_ID / R2_ACCESS_KEY_ID / R2_SECRET_ACCESS_KEY）
  どれも欠けていればその情報源だけスキップして続行する（--strict で失敗扱い）。

使い方:
  python3 tools/master_version.py --project prod
  python3 tools/master_version.py --project dev
  python3 tools/master_version.py --project prod --next-only   # 次の番号だけ出す（0007）
"""
import argparse
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import r2_utils        # noqa: E402
import hosting_utils   # noqa: E402

# dev / prod -> Firebase プロジェクトID
FIREBASE_PROJECTS = {
    "prod": "manhole-card-navi",
    "dev": "manhole-card-navi-dev",
}

VERSION_RE = re.compile(r"^\d{4}$")
VDIR_RE = re.compile(r"^v(\d{4})$")

# Remote Config のどのパラメータが参照先 master バージョンを持つか（アプリと合わせる）
RC_PARAM = "inquired_master_version"


def token():
    try:
        return subprocess.check_output(
            ["gcloud", "auth", "print-access-token"],
            text=True, stderr=subprocess.PIPE).strip()
    except Exception as e:  # noqa
        return None


def get_json(url, tok, timeout=30, quota_project=None):
    headers = {"Authorization": f"Bearer {tok}"}
    if quota_project:
        # firebaseremoteconfig API は gcloud の ADC だけだと quota project が無く 403 になる。
        # 課金先プロジェクトをヘッダで明示すると通る。
        headers["x-goog-user-project"] = quota_project
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return json.loads(resp.read())


def firestore_versions(tok, firebase_project):
    """Firestore の master コレクションに存在するバージョンIDの集合。"""
    base = (f"https://firestore.googleapis.com/v1/projects/{firebase_project}"
            f"/databases/(default)/documents/master")
    found = set()
    page_token = None
    while True:
        params = {"pageSize": "300", "mask.fieldPaths": "__name__", "showMissing": "true"}
        if page_token:
            params["pageToken"] = page_token
        data = get_json(f"{base}?{urllib.parse.urlencode(params)}", tok)
        for doc in data.get("documents", []):
            found.add(doc["name"].rsplit("/", 1)[-1])
        page_token = data.get("nextPageToken")
        if not page_token:
            break
    return {v for v in found if VERSION_RE.match(v)}


def firestore_card_count(tok, firebase_project, version):
    """master/{version}/cards の件数（count 集計）。取れなければ None。"""
    url = (f"https://firestore.googleapis.com/v1/projects/{firebase_project}"
           f"/databases/(default)/documents/master/{version}:runAggregationQuery")
    body = json.dumps({
        "structuredAggregationQuery": {
            "structuredQuery": {"from": [{"collectionId": "cards"}]},
            "aggregations": [{"alias": "n", "count": {}}],
        }
    }).encode("utf-8")
    req = urllib.request.Request(url, data=body, method="POST", headers={
        "Authorization": f"Bearer {tok}", "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read())
        for row in data:
            v = row.get("result", {}).get("aggregateFields", {}).get("n", {})
            if "integerValue" in v:
                return int(v["integerValue"])
    except Exception:  # noqa
        return None
    return None


def firestore_has_image_sub_url(tok, firebase_project, version):
    """そのバージョンの cards が image_sub_url を持つか（先頭1件で判定）。不明なら None。"""
    url = (f"https://firestore.googleapis.com/v1/projects/{firebase_project}"
           f"/databases/(default)/documents/master/{version}/cards?pageSize=1")
    try:
        data = get_json(url, tok)
    except Exception:  # noqa
        return None
    docs = data.get("documents") or []
    if not docs:
        return None
    fields = docs[0].get("fields", {})
    return bool(fields.get("image_sub_url", {}).get("stringValue"))


def r2_versions(project):
    """R2 に master/v{ver}/ 接頭辞が存在するバージョンの集合。"""
    s3 = r2_utils.client()
    bucket = r2_utils.bucket_of(project)
    found = set()
    token_ = None
    while True:
        kw = {"Bucket": bucket, "Prefix": "master/", "Delimiter": "/", "MaxKeys": 1000}
        if token_:
            kw["ContinuationToken"] = token_
        resp = s3.list_objects_v2(**kw)
        for cp in resp.get("CommonPrefixes", []):
            m = VDIR_RE.match(cp["Prefix"][len("master/"):].rstrip("/"))
            if m:
                found.add(m.group(1))
        if not resp.get("IsTruncated"):
            break
        token_ = resp.get("NextContinuationToken")
        if not token_:
            break
    return found


def hosting_versions(project):
    """Hosting のローカル public/master/ に存在するバージョンの集合。"""
    local = hosting_utils.local_dir_of(project)
    root = os.path.join(local, "public", "master")
    if not os.path.isdir(root):
        return set()
    found = set()
    for name in os.listdir(root):
        m = VDIR_RE.match(name)
        if m and os.path.isdir(os.path.join(root, name)):
            found.add(m.group(1))
    return found


def remote_config_versions(tok, firebase_project):
    """Remote Config の inquired_master_version（既定値と条件値）。取れなければ None。"""
    url = (f"https://firebaseremoteconfig.googleapis.com/v1/projects/"
           f"{firebase_project}/remoteConfig")
    try:
        data = get_json(url, tok, quota_project=firebase_project)
    except Exception as e:  # noqa
        return None
    param = (data.get("parameters") or {}).get(RC_PARAM)
    if param is None:
        return {}
    out = {"default": (param.get("defaultValue") or {}).get("value")}
    for cond, val in (param.get("conditionalValues") or {}).items():
        out[cond] = val.get("value")
    return out


def next_version(versions):
    """見つかったバージョンの最大値 + 1（4桁ゼロ埋め）。"""
    if not versions:
        return None
    return f"{max(int(v) for v in versions) + 1:04d}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--project", required=True, choices=list(FIREBASE_PROJECTS),
                    help="調べる環境（dev / prod）")
    ap.add_argument("--next-only", action="store_true",
                    help="次のバージョン番号だけを標準出力に出す（スクリプトから使う用）")
    ap.add_argument("--strict", action="store_true",
                    help="いずれかの情報源が取得できなければエラー終了する")
    args = ap.parse_args()

    firebase_project = FIREBASE_PROJECTS[args.project]
    quiet = args.next_only
    problems = []

    def say(*a):
        if not quiet:
            print(*a)

    say(f"環境           : {args.project}（{firebase_project}）")

    # ---- Firestore ----
    fs_versions = set()
    tok = token()
    if not tok:
        problems.append("gcloud のアクセストークンが取れません（gcloud auth login）")
        say("Firestore      : ⚠️ 取得できません（gcloud auth login を実行してください）")
    else:
        try:
            fs_versions = firestore_versions(tok, firebase_project)
            say(f"Firestore      : {', '.join(sorted(fs_versions)) or '（無し）'}")
            if not quiet and fs_versions:
                latest = max(fs_versions, key=int)
                n = firestore_card_count(tok, firebase_project, latest)
                has_sub = firestore_has_image_sub_url(tok, firebase_project, latest)
                sub = {True: "あり", False: "なし", None: "不明"}[has_sub]
                say(f"  最新 {latest}   : cards {n if n is not None else '?'} 件 / "
                    f"image_sub_url {sub}")
        except Exception as e:  # noqa
            problems.append(f"Firestore の取得に失敗: {type(e).__name__}: {e}")
            say(f"Firestore      : ⚠️ 取得に失敗 ({type(e).__name__}: {e})")

    # ---- R2（主系の画像）----
    r2_vers = set()
    try:
        r2_vers = r2_versions(args.project)
        say(f"R2(主系画像)   : {', '.join(sorted(r2_vers)) or '（無し）'}")
    except SystemExit as e:  # r2_utils が認証不足で sys.exit する
        problems.append(f"R2 の取得に失敗: {e}")
        say("R2(主系画像)   : ⚠️ 取得できません（R2_* の環境変数を確認してください）")
    except Exception as e:  # noqa
        problems.append(f"R2 の取得に失敗: {type(e).__name__}: {e}")
        say(f"R2(主系画像)   : ⚠️ 取得に失敗 ({type(e).__name__}: {e})")

    # ---- Hosting（代替の画像。ローカル配置を見る）----
    host_vers = set()
    try:
        host_vers = hosting_versions(args.project)
        say(f"Hosting(代替)  : {', '.join(sorted(host_vers)) or '（無し）'}"
            "  ※ ローカル配置の状況。デプロイ済みかは配信URLで確認する")
    except SystemExit as e:
        problems.append(f"Hosting の確認に失敗: {e}")
    except Exception as e:  # noqa
        problems.append(f"Hosting の確認に失敗: {type(e).__name__}: {e}")

    # ---- Remote Config（端末が実際に参照している値）----
    if tok and not quiet:
        rc = remote_config_versions(tok, firebase_project)
        if rc is None:
            say("Remote Config  : ⚠️ 取得できません（Firebase コンソールで "
                f"{RC_PARAM} を確認してください）")
        elif not rc:
            say(f"Remote Config  : {RC_PARAM} が未設定")
        else:
            say(f"Remote Config  : {RC_PARAM}")
            for k, v in rc.items():
                label = "default" if k == "default" else f"条件 {k}"
                say(f"  {label:28s} -> {v}")
            say("  ※ これが端末の参照先。切り替えはこの値を新バージョンに更新して行う（手順11）")

    all_versions = fs_versions | r2_vers | host_vers
    nxt = next_version(all_versions)

    if args.next_only:
        if not nxt:
            sys.exit("バージョンが1つも見つかりませんでした。--next-only では算出できません。")
        print(nxt)
        return

    print()
    if not all_versions:
        print("⚠️ バージョンが1つも見つかりませんでした。認証を確認してください。")
    else:
        print(f"現行の最新     : {max(all_versions, key=int)}")
        print(f"次のバージョン : {nxt}")
        # 画像だけ先に置かれている＝発行が途中で止まった残骸の可能性
        orphan = (r2_vers | host_vers) - fs_versions
        if orphan and fs_versions:
            print(f"  ※ Firestore に無いのに画像がある: {', '.join(sorted(orphan))}")
            print("     発行が途中で止まった残骸の可能性がある。上書きしないよう番号を確認すること")
        # 画像を置くようになる前の古いバージョン（画像は Cloud Storage にあった）は
        # 対象外。画像が存在する最古のバージョン以降だけを見る。
        img_vers = r2_vers | host_vers
        if img_vers:
            floor = min(int(v) for v in img_vers)
            gap = {v for v in fs_versions - img_vers if int(v) >= floor}
            if gap:
                print(f"  ※ Firestore にあるのに画像が無い: {', '.join(sorted(gap))}")
                print("     Hosting は「ローカルに無いだけ」のこともある（配信URLで確認する）")

    if problems:
        print(f"\n⚠️ 取得できなかった情報源が {len(problems)} 件あります:")
        for p in problems:
            print("  ", p)
        print("  この状態の「次のバージョン」は当てにしないこと（見落とした番号を上書きしうる）。")
        if args.strict:
            sys.exit(1)


if __name__ == "__main__":
    main()
