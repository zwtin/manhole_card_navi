#!/usr/bin/env python3
"""
build_master.py が生成した master JSON を Firestore の master/{version} 配下に投入する。

書き込み先（新構造・3コレクション）:
  master/{ver}                  : {id}
  master/{ver}/prefectures/{id} : {id, name}
  master/{ver}/volumes/{id}     : {id, name}
  master/{ver}/cards/{id}       : {
      id, name, prefecture_id, volume_id, publication_date,
      location            : GeoPoint      マンホール座標
      image               : string        master/v{ver}/images/{id}.jpg
      distribution_place_html : string    配布場所HTML（そのまま）
      distribution_points : [GeoPoint]    配布場所の座標（0〜複数）
      stock_html          : string        在庫状況HTML（そのまま）
      distribution_state  : string        distributing / stopped / notClear
    }

  ※ 旧構造の contacts / images コレクションと cards/{id}/contact_id サブコレクションは
    廃止した。配布場所と画像はカードに埋め込む。--replace はそれらの残骸も削除する。

特徴:
  - --target-version で指定したバージョンにだけ書き込む（他バージョンには触れない）
  - Firestore REST API の commit(batch write) を使い、500 writes ずつまとめて送る
  - 冪等: 同じ内容を再実行しても upsert（set）なので安全。再実行で重複しない
  - --replace: 投入前に master/{version} 配下の既存ドキュメントを全削除する。
      同じバージョンを上書きする際、今回のデータに無い古いカード等が残らないようにする。
      （--replace を付けないと、set は同一IDを上書きするだけで、消えたカードは残る）
  - --dry-run で書き込まず件数のみ表示
  - GeoPoint / 配列 に対応（to_value 参照）

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
sys.path.insert(0, HERE)
from geo_utils import GEO_KEY  # noqa: E402  （GeoPoint センチネルは geo_utils と共有）
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
    """Python値 -> Firestore REST の Value 表現

    対応する型:
      None / bool / int / float / str
      GeoPoint : {"_geopoint": {"lat": <float>, "lon": <float>}}
      array    : list（要素は再帰的に変換。GeoPoint の配列も可）
      map      : dict（GEO_KEY を持たないもの）
    """
    if v is None:
        return {"nullValue": None}
    # bool は int のサブクラスなので先に判定する
    if isinstance(v, bool):
        return {"booleanValue": v}
    if isinstance(v, dict):
        if GEO_KEY in v:
            g = v[GEO_KEY]
            return {"geoPointValue": {
                "latitude": float(g["lat"]),
                "longitude": float(g["lon"]),
            }}
        return {"mapValue": {"fields": {k: to_value(x) for k, x in v.items()}}}
    if isinstance(v, list):
        return {"arrayValue": {"values": [to_value(x) for x in v]}}
    if isinstance(v, int):
        return {"integerValue": str(v)}
    if isinstance(v, float):
        return {"doubleValue": v}
    return {"stringValue": str(v)}


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

    # 新構造: cards / prefectures / volumes の3コレクションのみ。
    # 配布場所（旧 contacts）と画像（旧 images）は card に埋め込むため、
    # 独立したコレクション・サブコレクションは作らない。
    writes = []
    # master/{ver} ルート
    writes.append(make_write(project, root, {"id": ver}))
    for p in data["prefectures"]:
        writes.append(make_write(project, f"{root}/prefectures/{p['id']}", p))
    for v in data["volumes"]:
        writes.append(make_write(project, f"{root}/volumes/{v['id']}", v))
    for card in data["cards"]:
        writes.append(make_write(project, f"{root}/cards/{card['id']}", card))

    print(f"投入先プロジェクト: {project}")
    print(f"書き込み対象: master/{ver}")
    print(f"  cards {len(data['cards'])} / prefectures {len(data['prefectures'])} / "
          f"volumes {len(data['volumes'])}")
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
