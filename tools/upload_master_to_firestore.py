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
  - 既存 master/0000〜0002 には一切触れない（新規に0003を作るだけ）
  - Firestore REST API の commit(batch write) を使い、500 writes ずつまとめて送る
  - 冪等: 同じ内容を再実行しても upsert（set）なので安全。再実行で重複しない
  - --target-version で書き込み先バージョンを変更可能（デフォルト0003）
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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--target-version", default="0003")
    ap.add_argument("--project", default=DEFAULT_PROJECT,
                    help="投入先プロジェクト（開発: manhole-card-navi-dev）")
    ap.add_argument("--input", default=DEFAULT_MASTER_PATH, help="master JSON")
    ap.add_argument("--dry-run", action="store_true")
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

    if args.dry_run:
        print("\n（--dry-run のため書き込みません）")
        return

    tok = token()
    batch = min(args.batch, 500)
    total = 0
    for i, group in enumerate(chunked(writes, batch), start=1):
        commit(tok, project, group)
        total += len(group)
        print(f"  commit {i}: {total}/{len(writes)} writes")
    print(f"\n完了: {total} writes を {project} の master/{ver} に投入しました。")


if __name__ == "__main__":
    main()
