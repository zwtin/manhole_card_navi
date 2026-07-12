#!/usr/bin/env python3
"""card_id は行順の連番なので、gk-p.jp に新カードが挿入されると全体がシフトする。
安定キーである image_url を介して、旧 card_id ベースの中間成果物（OCR結果・配布場所抽出・
ダウンロード済み画像）を新 card_id へ移送する。

  python3 tools/remap_card_ids.py --dry-run
  python3 tools/remap_card_ids.py
"""
import argparse
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DATA = ROOT / "data"
IMAGES = ROOT / "images"

# 旧 card_id をキーに持つ中間ファイル
KEYED_FILES = [
    "ocr_raw.json",
    "ocr_resolved.json",
    "dist_raw.json",
    "dist_resolved.json",
    "download_status.json",
]


def load(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--prev", default=str(DATA / "cards_base_prev.json"))
    ap.add_argument("--cur", default=str(DATA / "cards_base.json"))
    args = ap.parse_args()

    prev = load(args.prev)
    cur = load(args.cur)

    prev_by_url = {c["image_url"]: c["card_id"] for c in prev}
    cur_by_url = {c["image_url"]: c["card_id"] for c in cur}
    if len(prev_by_url) != len(prev) or len(cur_by_url) != len(cur):
        raise SystemExit("image_url に重複がある。移送の一意性が保証できないので中断する。")

    # 旧 card_id -> 新 card_id
    remap = {
        prev_by_url[url]: cur_by_url[url]
        for url in prev_by_url
        if url in cur_by_url
    }
    dropped = [prev_by_url[u] for u in prev_by_url if u not in cur_by_url]
    added = [cur_by_url[u] for u in cur_by_url if u not in prev_by_url]
    moved = {o: n for o, n in remap.items() if o != n}

    print(f"旧カード {len(prev)} 件 / 新カード {len(cur)} 件")
    print(f"  移送対象      : {len(remap)} 件（うち card_id が変わる: {len(moved)} 件）")
    print(f"  今回から消えた: {len(dropped)} 件 {sorted(dropped)[:10]}")
    print(f"  今回の新規    : {len(added)} 件（OCR・配布場所抽出が必要）")

    # --- 中間 JSON の移送 ---
    for name in KEYED_FILES:
        path = DATA / name
        if not path.exists():
            print(f"  [skip] {name} が無い")
            continue
        old = load(path)
        new = {}
        lost = []
        for old_id, val in old.items():
            new_id = remap.get(old_id)
            if new_id is None:
                lost.append(old_id)
                continue
            new[new_id] = val
        # 画像パスは card_id を含むので張り替える（拡張子は元のものを保つ）
        if name == "download_status.json":
            for cid, v in new.items():
                if v.get("path"):
                    v["path"] = str(IMAGES / f"{cid}{Path(v['path']).suffix}")
        print(f"  {name}: {len(old)} -> {len(new)} 件" + (f" / 移送先なしで破棄 {len(lost)} 件 {lost[:5]}" if lost else ""))
        if not args.dry_run:
            shutil.copy2(path, path.with_suffix(".json.bak"))
            with open(path, "w", encoding="utf-8") as f:
                json.dump(new, f, ensure_ascii=False, indent=1)

    # --- 画像ファイルのリネーム（衝突するので一時ディレクトリを経由する）---
    if IMAGES.exists():
        # 拡張子は .jpg とは限らない（.png のカードがある）ので stem で対応付け、拡張子は保つ
        present = {p.stem: p for p in IMAGES.iterdir() if p.is_file() and not p.name.startswith(".")}
        to_move = {o: n for o, n in remap.items() if o in present}
        orphan = sorted(set(present) - set(remap))
        print(f"  images/: {len(present)} 枚中 {len(to_move)} 枚を移送"
              + (f" / 対応先なし {len(orphan)} 枚 {orphan[:5]}" if orphan else ""))
        if not args.dry_run:
            staging = IMAGES.parent / "images_staging"
            if staging.exists():
                shutil.rmtree(staging)
            staging.mkdir()
            for old_id, new_id in to_move.items():
                src = present[old_id]
                shutil.move(str(src), str(staging / f"{new_id}{src.suffix}"))
            for p in staging.iterdir():
                shutil.move(str(p), str(IMAGES / p.name))
            shutil.rmtree(staging)
            for cid in orphan:
                present[cid].unlink(missing_ok=True)

    if not args.dry_run:
        with open(DATA / "new_card_ids.json", "w", encoding="utf-8") as f:
            json.dump(sorted(added), f, ensure_ascii=False, indent=1)
        print(f"\n新規 card_id を data/new_card_ids.json に書き出した（{len(added)} 件）")
    print("\ndry-run（書き込みなし）" if args.dry_run else "\n移送完了")


if __name__ == "__main__":
    main()
