#!/usr/bin/env python3
"""
master_0003.json を Firestore の master/0003 配下に投入する。

書き込み先:
  master/0003                              : {id:"0003", created_at: <省略可>}
  master/0003/prefectures/{id}             : {id, name}
  master/0003/volumes/{id}                 : {id, name}
  master/0003/images/{id}                  : {id, color_original}
  master/0003/contacts/{id}                : {id,name,name_url,address,phone_number,latitude,longitude,time,time_other,other}
  master/0003/cards/{id}                   : {id,name,prefecture_id,volume_id,image_id,publication_date,
                                              latitude,longitude,distribution_state,distribution_text,
                                              distribution_link_text,distribution_link_url,distribution_other}
  master/0003/cards/{id}/contact_id/{cid}  : {id}

特徴:
  - --target-version で指定したバージョンにだけ書き込む（他バージョンには触れない）
  - Firestore REST API の commit(batch write) を使い、500 writes ずつまとめて送る
  - 冪等: 同じ内容を再実行しても upsert（set）なので安全。再実行で重複しない
  - --replace: 投入前に master/{version} 配下の既存ドキュメントを全削除する。
      同じバージョンを上書きする際、今回のデータに無い古いカード等が残らないようにする。
      （--replace を付けないと、set は同一IDを上書きするだけで、消えたカードは残る）
  - --dry-run で書き込まず件数のみ表示

認証: gcloud アクセストークン
"""
import argparse
import json
import os
import subprocess
import sys
import time
import urllib.request
import urllib.error
import urllib.parse

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_MASTER_PATH = os.path.join(HERE, "data", "firestore", "master_0003.json")
DEFAULT_PROJECT = "manhole-card-navi"


def token():
    try:
        return subprocess.check_output(
            ["gcloud", "auth", "print-access-token"],
            stderr=subprocess.DEVNULL).decode().strip()
    except Exception:
        sys.exit("gcloud アクセストークン取得失敗。`gcloud auth login` を実行してください。")


def to_value(v):
    """Python値 -> Firestore REST の Value 表現"""
    if isinstance(v, bool):
        return {"booleanValue": v}
    if isinstance(v, int):
        return {"integerValue": str(v)}
    if isinstance(v, float):
        return {"doubleValue": v}
    return {"stringValue": "" if v is None else str(v)}


def doc_fields(d):
    return {k: to_value(v) for k, v in d.items()}


def make_write(project, doc_path, fields):
    return {
        "update": {
            "name": f"projects/{project}/databases/(default)/documents/{doc_path}",
            "fields": doc_fields(fields),
        }
    }


def commit(tok, project, writes):
    commit_url = (f"https://firestore.googleapis.com/v1/projects/{project}"
                  f"/databases/(default)/documents:commit")
    body = json.dumps({"writes": writes}).encode("utf-8")
    req = urllib.request.Request(commit_url, data=body, method="POST", headers={
        "Authorization": f"Bearer {tok}",
        "Content-Type": "application/json",
    })
    for attempt in range(4):
        try:
            with urllib.request.urlopen(req, timeout=120) as resp:
                return json.loads(resp.read())
        except urllib.error.HTTPError as e:
            msg = e.read().decode()[:300]
            if e.code in (429, 500, 503) and attempt < 3:
                time.sleep(2 ** attempt)
                continue
            raise SystemExit(f"commit失敗 HTTP {e.code}: {msg}")


def chunked(seq, n):
    for i in range(0, len(seq), n):
        yield seq[i:i + n]


def list_doc_names(tok, project, coll_path):
    """コレクション配下の全ドキュメントの完全名（projects/.../documents/...）を返す。

    ページングに対応。__name__ のみ取得して軽量化する。
    """
    base = (f"https://firestore.googleapis.com/v1/projects/{project}"
            f"/databases/(default)/documents/{coll_path}")
    names = []
    page_token = None
    while True:
        params = {"pageSize": "300", "mask.fieldPaths": "__name__"}
        if page_token:
            params["pageToken"] = page_token
        url = base + "?" + urllib.parse.urlencode(params)
        req = urllib.request.Request(
            url, headers={"Authorization": f"Bearer {tok}"})
        try:
            with urllib.request.urlopen(req, timeout=60) as resp:
                data = json.loads(resp.read())
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return names  # コレクションが無い
            raise SystemExit(f"list失敗 HTTP {e.code}: {e.read().decode()[:300]}")
        for doc in data.get("documents", []):
            names.append(doc["name"])
        page_token = data.get("nextPageToken")
        if not page_token:
            break
    return names


def make_delete(doc_name):
    """完全ドキュメント名（projects/.../documents/...）を削除する write。"""
    return {"delete": doc_name}


def collect_deletes(tok, project, ver):
    """master/{ver} 配下の全ドキュメント削除 write を集める。

    cards のサブコレクション contact_id も含めて削除する。
    Firestore の delete はサブコレクションを自動削除しないため、
    先に子（contact_id）を集めてから親（cards）を消す。
    """
    root = f"master/{ver}"
    deletes = []
    # 単純コレクション
    for coll in ("prefectures", "volumes", "images", "contacts"):
        for name in list_doc_names(tok, project, f"{root}/{coll}"):
            deletes.append(make_delete(name))
    # cards と、その配下の contact_id サブコレクション
    card_names = list_doc_names(tok, project, f"{root}/cards")
    for card_name in card_names:
        # card_name は完全名。末尾のドキュメントIDを取り出してサブコレクションを辿る。
        card_id = card_name.rsplit("/", 1)[-1]
        for sub in list_doc_names(tok, project, f"{root}/cards/{card_id}/contact_id"):
            deletes.append(make_delete(sub))
    for card_name in card_names:
        deletes.append(make_delete(card_name))
    return deletes


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--target-version", required=True,
                    help="投入先の master バージョン（例 0004）")
    ap.add_argument("--project", default=DEFAULT_PROJECT,
                    help="投入先プロジェクト（開発: manhole-card-navi-dev）")
    ap.add_argument("--input", default=DEFAULT_MASTER_PATH, help="master JSON")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--replace", action="store_true",
                    help="投入前に master/{version} 配下の既存ドキュメントを全削除する。"
                         "同じバージョンを上書きする際、今回のデータに無い古いカード等の"
                         "残存を防ぐ。")
    ap.add_argument("--batch", type=int, default=200, help="1commitあたりのwrite数(<=500)")
    args = ap.parse_args()

    project = args.project
    data = json.load(open(args.input, encoding="utf-8"))
    ver = args.target_version
    root = f"master/{ver}"

    writes = []
    # master/{ver} ルート
    writes.append(make_write(project, root, {"id": ver}))
    # prefectures
    for p in data["prefectures"]:
        writes.append(make_write(project, f"{root}/prefectures/{p['id']}", p))
    # volumes
    for v in data["volumes"]:
        writes.append(make_write(project, f"{root}/volumes/{v['id']}", v))
    # images
    for im in data["images"]:
        writes.append(make_write(project, f"{root}/images/{im['id']}", im))
    # contacts
    for c in data["contacts"]:
        writes.append(make_write(project, f"{root}/contacts/{c['id']}", c))
    # cards + contact_id サブコレクション
    n_link = 0
    for card in data["cards"]:
        cid = card["id"]
        fields = {k: v for k, v in card.items() if k != "contact_ids"}
        writes.append(make_write(project, f"{root}/cards/{cid}", fields))
        for con_id in card.get("contact_ids", []):
            writes.append(make_write(project, f"{root}/cards/{cid}/contact_id/{con_id}", {"id": con_id}))
            n_link += 1

    print(f"投入先プロジェクト: {project}")
    print(f"書き込み対象: master/{ver}")
    print(f"  prefectures {len(data['prefectures'])} / volumes {len(data['volumes'])} / "
          f"images {len(data['images'])} / contacts {len(data['contacts'])} / cards {len(data['cards'])}")
    print(f"  contact_id 紐付け {n_link}")
    print(f"  総 write 数: {len(writes)}")

    if args.replace:
        print(f"  --replace: 投入前に master/{ver} 配下の既存ドキュメントを全削除します")

    if args.dry_run:
        print("\n（--dry-run のため書き込みません）")
        if args.replace:
            print("  ※ --replace の削除対象件数は、実行時に列挙して表示します")
        return

    tok = token()
    batch = min(args.batch, 500)

    # --replace: 既存を全削除してから投入する（古いカード等の残存を防ぐ）
    if args.replace:
        deletes = collect_deletes(tok, project, ver)
        if deletes:
            print(f"\n既存削除: {len(deletes)} ドキュメント")
            done = 0
            for i, group in enumerate(chunked(deletes, batch), start=1):
                commit(tok, project, group)
                done += len(group)
                print(f"  delete {i}: {done}/{len(deletes)}")
        else:
            print(f"\n既存削除: master/{ver} 配下にドキュメントなし")

    total = 0
    for i, group in enumerate(chunked(writes, batch), start=1):
        commit(tok, project, group)
        total += len(group)
        print(f"  commit {i}: {total}/{len(writes)} writes")
    print(f"\n完了: {total} writes を {project} の master/{ver} に投入しました。")


if __name__ == "__main__":
    main()
