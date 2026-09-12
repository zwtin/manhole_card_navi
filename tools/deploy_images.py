#!/usr/bin/env python3
"""カード原本画像を gk-p.jp から**1回だけ**取得し、主系（Cloudflare R2）と
代替（Firebase Hosting）の**両方**へ同じパスで配る。

    主系 : s3://{bucket}/master/v{version}/images/{id}.jpg
           配信 {R2ベースURL}/master/v{version}/images/{id}.jpg      -> cards.image_url
    代替 : {hosting_dir}/public/master/v{version}/images/{id}.jpg
           配信 {HostingベースURL}/master/v{version}/images/{id}.jpg  -> cards.image_sub_url

  ※ 旧 deploy_images_to_r2.py / deploy_images_to_hosting.py を統合したもの。
    別々に走らせると gk-p.jp から二重にダウンロードすることになり、かつ
    取得タイミングの差で主系と代替の中身がズレうるので、1本にまとめてある。

なぜ2か所に置くのか:
  R2 の配信ドメイン（cdn.manholecardnavi.com）が経路上のフィルタリング装置に
  遮断される端末がある。アプリは image_url の取得に失敗したときだけ
  image_sub_url（*.web.app）へフォールバックする。
  詳細は hosting_utils.py の docstring を参照。

  **両方に置かないと片肺になる。** master に image_sub_url を入れたのに Hosting へ
  配置していないと、フォールバック先が 404 になり遮断端末は救済されない。

画像ソースの決め方（1件ごとに、安い順で1回だけ取得する）:
  1. 代替（Hosting ローカル）に既に置いてあればそれを読む
  2. 無ければ主系（R2）に既にあれば GetObject で取る（gk-p.jp を叩かない）
  3. どちらにも無ければ gk-p.jp からダウンロードして JPEG に正規化する
  --overwrite 指定時は必ず 3（gk-p.jp から取り直す）。
  1・2 を挟むことで、中断→再実行が安く済み、主系と代替がバイト単位で一致する。

配置ファイル名（id）:
  カード画像に印字された正規化ID（例 00-101-A001）。cards_base.json の ocr_id を使う。
  これは ocr_cards.py が画像の二重OCRで確定した値。
  ocr_id が無いカードはスキップして警告する（IDが確定していない＝配置できない）。
  ※ 画像URLから機械生成した推定IDや人力付与のIDは不正確なので使わない。

バージョン運用:
  master バージョンを上げるたびに、新しい master/v{version}/ 配下へ全画像を置く。
  旧バージョンの画像は全端末が新バージョンへ移行しきるまで残す
  （後片付けは delete_images_from_r2.py / delete_images_from_hosting.py）。

認証:
  R2      : 環境変数 R2_ACCOUNT_ID / R2_ACCESS_KEY_ID / R2_SECRET_ACCESS_KEY（r2_utils.py）
  Hosting : firebase CLI（`firebase login` 済みであること）

使い方:
  # 対象・件数の確認のみ（DLも配置もしない）。R2 / Hosting の既存差分も出す
  python3 tools/deploy_images.py --version 0007 --project dev --dry-run

  # 疎通確認: 先頭3件だけ流す
  python3 tools/deploy_images.py --version 0007 --project dev --limit 3

  # 全件を R2 + Hosting へ配置し、Hosting はデプロイまで実行する
  python3 tools/deploy_images.py --version 0007 --project dev --deploy

  # 片方だけ流したいとき（原則は両方）
  python3 tools/deploy_images.py --version 0007 --project dev --targets r2

  # 既存も取り直して上書きする
  python3 tools/deploy_images.py --version 0007 --project prod --overwrite --deploy
"""
import argparse
import io
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request
from collections import Counter

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import r2_utils        # noqa: E402
import hosting_utils   # noqa: E402
import image_layout    # noqa: E402

DATA = os.path.join(HERE, "data")
CARDS_PATH = os.path.join(DATA, "cards_base.json")

ALL_TARGETS = ("r2", "hosting")

# gk-p.jp は https + Referer が無いと 403 を返す（download_images.py と同じ作法）。
REFERER = "https://www.gk-p.jp/mhcard/"
# Cloudflare は Python 既定の UA（Python-urllib/3.x）を 403 で弾く。配信URLの
# 検証にも使うので、ブラウザ相当の UA を必ず付ける。
USER_AGENT = ("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
              "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36")


def run(cmd, cwd=None):
    print("  $", " ".join(cmd))
    result = subprocess.run(cmd, cwd=cwd)
    if result.returncode != 0:
        sys.exit(f"コマンド失敗（exit {result.returncode}）: {' '.join(cmd)}")


def card_image_id(card):
    """配置ファイル名に使う確定ID（ocr_cards.py が確定した ocr_id）。無ければ None。"""
    return card.get("ocr_id") or None


def download_one(url):
    """(ok, data or None, error)"""
    req = urllib.request.Request(url, headers={
        "User-Agent": USER_AGENT,
        "Referer": REFERER,
        "Accept": "image/avif,image/webp,image/apng,image/*,*/*;q=0.8",
    })
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return True, resp.read(), ""
    except urllib.error.HTTPError as e:
        return False, None, f"HTTP {e.code}"
    except urllib.error.URLError as e:
        return False, None, f"URLError {e.reason}"
    except Exception as e:  # noqa
        return False, None, f"{type(e).__name__}: {e}"


def to_jpeg(data):
    """(jpeg_bytes, converted)

    gk-p.jp には拡張子が .png のカードがある（柏市 12-217-A001 など）。
    R2 は拡張子から Content-Type を推測しないので image/jpeg を明示して置く。
    中身が JPEG でないものは JPEG に変換してから配る（主系・代替とも同じバイト列）。
    """
    if data[:3] == b"\xff\xd8\xff":       # JPEG (SOI)
        return data, False
    img = Image.open(io.BytesIO(data))
    if img.mode != "RGB":
        img = img.convert("RGB")
    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=95)
    return buf.getvalue(), True


def head_public_url(url):
    """配信 URL を叩いて (status, content_type) を返す。失敗時は (None, 説明)。"""
    req = urllib.request.Request(url, method="HEAD", headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.status, resp.headers.get("Content-Type", "")
    except urllib.error.HTTPError as e:
        return e.code, e.headers.get("Content-Type", "") if e.headers else ""
    except Exception as e:  # noqa
        return None, f"{type(e).__name__}: {e}"


def parse_targets(value):
    names = [x.strip() for x in value.split(",") if x.strip()]
    bad = [x for x in names if x not in ALL_TARGETS]
    if bad:
        sys.exit(f"--targets に不明な配信先: {bad}（使えるのは {', '.join(ALL_TARGETS)}）")
    if not names:
        sys.exit("--targets が空です")
    return names


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", required=True,
                    help="master バージョン（例 0007）。配置先 master/v{version}/images/。"
                         "番号は master_version.py で確認する")
    ap.add_argument("--project", required=True, choices=list(r2_utils.PROJECTS),
                    help="配置先（dev / prod）。バケット・配信URL・Hosting ディレクトリが切り替わる")
    ap.add_argument("--targets", default=",".join(ALL_TARGETS),
                    help="配信先をカンマ区切りで指定（既定 r2,hosting）。"
                         "原則は両方。片方だけにすると主系と代替が食い違う")
    ap.add_argument("--cards", default=CARDS_PATH,
                    help="カードJSON（既定 tools/data/cards_base.json）")
    ap.add_argument("--bucket", default=None, help="R2 バケット名を明示指定（既定は project から解決）")
    ap.add_argument("--base-url", default=None, help="R2 配信ベース URL を明示指定（検証表示用）")
    ap.add_argument("--hosting-dir", default=None,
                    help="Firebase プロジェクトのローカルディレクトリを明示指定")
    ap.add_argument("--hosting-base-url", default=None,
                    help="Hosting 配信ベース URL を明示指定（検証表示用）")
    ap.add_argument("--deploy", action="store_true",
                    help="配置後に firebase deploy --only hosting を実行する")
    ap.add_argument("--dry-run", action="store_true",
                    help="取得も配置もせず、対象件数と配信先の既存差分のみ表示")
    ap.add_argument("--limit", type=int, default=0,
                    help="先頭 N 件だけ処理する（疎通確認用。0 で全件）")
    ap.add_argument("--sleep", type=float, default=0.15,
                    help="gk-p.jp からダウンロードした直後の待機秒（負荷軽減）")
    ap.add_argument("--overwrite", action="store_true",
                    help="既に配置済みでも gk-p.jp から取り直して上書きする")
    ap.add_argument("--cache-control", default=image_layout.DEFAULT_CACHE_CONTROL,
                    help="R2 オブジェクトに付ける Cache-Control"
                         "（Hosting 側は firebase.json の headers で設定済み）")
    args = ap.parse_args()

    targets = parse_targets(args.targets)
    use_r2 = "r2" in targets
    use_hosting = "hosting" in targets
    prefix = image_layout.image_prefix(args.version)

    if not os.path.exists(args.cards):
        sys.exit(f"カードJSON が見つかりません: {args.cards}")
    cards = json.load(open(args.cards, encoding="utf-8"))

    # ---- 配置対象を組み立てる。ID が確定していないカードは除外 ----
    plan = []     # (id, source_url)
    no_id = []    # ID未確定
    no_url = []   # ソース image_url なし
    for c in cards:
        cid = card_image_id(c)
        url = c.get("image_url", "")
        if not cid:
            no_id.append(c.get("card_id"))
            continue
        if not url:
            no_url.append(c.get("card_id"))
            continue
        plan.append((cid, url))

    print(f"プロジェクト   : {args.project}")
    print(f"配信先         : {', '.join(targets)}")
    print(f"パス           : {prefix}{{id}}.jpg")
    print(f"カードJSON総数 : {len(cards)}")
    print(f"配置対象       : {len(plan)}")
    if no_id:
        print(f"  ⚠️ ocr_id が無くスキップ: {len(no_id)}（ocr_cards.py を実行してください）")
    if no_url:
        print(f"  ⚠️ ソース image_url なしでスキップ: {len(no_url)}")

    # ID の重複チェック（別カードが同じIDに落ちると上書きされる）
    dup = {k: n for k, n in Counter(cid for cid, _ in plan).items() if n > 1}
    if dup:
        print(f"  ⚠️ 配置ID重複: {len(dup)} 種（後勝ちで上書きされる）")
        for k in list(dup)[:5]:
            print(f"     {k} ×{dup[k]}")

    if args.limit:
        plan = plan[:args.limit]
        print(f"  --limit {args.limit}: 先頭 {len(plan)} 件のみ処理します")

    required_ids = {cid for cid, _ in plan}

    # ---- 主系（R2）の現状 ----
    s3 = bucket = base_url = None
    r2_existing_ids = set()
    if use_r2:
        bucket = r2_utils.bucket_of(args.project, args.bucket)
        base_url = r2_utils.base_url_of(args.project, args.base_url)
        s3 = r2_utils.client()
        try:
            keys = r2_utils.list_keys(s3, bucket, prefix)
        except Exception as e:  # noqa
            sys.exit(f"R2 の一覧取得に失敗しました（bucket={bucket}）: {type(e).__name__}: {e}\n"
                     "  バケット名・アカウントID・APIトークンの権限を確認してください。")
        r2_existing_ids = {i for i in (image_layout.id_from_key(k) for k in keys) if i}
        print(f"\n主系(R2)       : s3://{bucket}/{prefix}")
        print(f"  配信ベースURL: {base_url}")
        print(f"  既存         : {len(r2_existing_ids)} オブジェクト")
        extra = "（--limit のため未評価）" if args.limit else len(r2_existing_ids - required_ids)
        print(f"  未配置       : {len(required_ids - r2_existing_ids)} / 余剰（対象外）: {extra}")
        if (r2_existing_ids - required_ids) and not args.limit:
            for i in sorted(r2_existing_ids - required_ids)[:5]:
                print(f"     余剰: {prefix}{i}.jpg")
            print("     ※ 旧IDの残骸の可能性がある。master の要求と一致させるなら削除を検討する")

    # ---- 代替（Hosting）の現状 ----
    hosting_dir = hosting_base_url = dest_dir = None
    hosting_existing_ids = set()
    if use_hosting:
        hosting_dir = hosting_utils.local_dir_of(args.project, args.hosting_dir)
        hosting_base_url = hosting_utils.base_url_of(args.project, args.hosting_base_url)
        if not os.path.isdir(hosting_dir):
            sys.exit(f"Firebase プロジェクトディレクトリが見つかりません: {hosting_dir}\n"
                     "  tools/hosting_utils.py の LOCAL_DIRS か --hosting-dir を確認してください。")
        dest_dir = hosting_utils.image_dir(hosting_dir, args.version)
        hosting_existing_ids = hosting_utils.existing_ids(hosting_dir, args.version)
        print(f"\n代替(Hosting)  : {dest_dir}")
        print(f"  配信ベースURL: {hosting_base_url}")
        print(f"  既存         : {len(hosting_existing_ids)} ファイル")
        extra_h = "（--limit のため未評価）" if args.limit else len(hosting_existing_ids - required_ids)
        print(f"  未配置       : {len(required_ids - hosting_existing_ids)} / 余剰（対象外）: {extra_h}")

    if args.dry_run:
        print("\n（--dry-run のため取得・配置しません）")
        if plan:
            cid, src = plan[0]
            print(f"  例: {prefix}{cid}.jpg <- {src}")
            if use_r2:
                print(f"      主系 {image_layout.image_url(base_url, args.version, cid)}")
            if use_hosting:
                print(f"      代替 {image_layout.image_url(hosting_base_url, args.version, cid)}")
        return

    if use_hosting:
        os.makedirs(dest_dir, exist_ok=True)

    # ---- 本体: 1件につき1回だけ取得して、必要な配信先へ配る ----
    n_done = n_skip = n_fail = n_conv = 0
    src_counts = Counter()      # どこから取得したか（hosting / r2 / gk-p）
    placed_ids = []
    for i, (cid, url) in enumerate(plan, start=1):
        need_r2 = use_r2 and (args.overwrite or cid not in r2_existing_ids)
        need_hosting = use_hosting and (args.overwrite or cid not in hosting_existing_ids)
        if not need_r2 and not need_hosting:
            n_skip += 1
            continue

        # 取得は1回だけ。安い順に当たる（--overwrite なら必ず gk-p.jp から取り直す）
        data = None
        local_path = (hosting_utils.image_path(hosting_dir, args.version, cid)
                      if use_hosting else None)
        if not args.overwrite and local_path and os.path.exists(local_path) \
                and os.path.getsize(local_path) > 0:
            with open(local_path, "rb") as f:
                data = f.read()
            src_counts["hosting"] += 1
        elif not args.overwrite and use_r2 and cid in r2_existing_ids:
            try:
                obj = s3.get_object(Bucket=bucket,
                                    Key=image_layout.image_key(args.version, cid))
                data = obj["Body"].read()
                src_counts["r2"] += 1
            except Exception as e:  # noqa
                print(f"  [警告] {cid}: R2 からの取得に失敗したので gk-p.jp から取ります "
                      f"({type(e).__name__}: {e})")
                data = None
        if data is None:
            ok, raw, err = download_one(url)
            if not ok or not raw:
                n_fail += 1
                print(f"  [失敗] {cid} <- {url}: {err}")
                time.sleep(args.sleep)
                continue
            try:
                data, converted = to_jpeg(raw)
            except Exception as e:  # noqa
                n_fail += 1
                print(f"  [失敗] {cid}: JPEG 変換に失敗 ({type(e).__name__}: {e})")
                time.sleep(args.sleep)
                continue
            if converted:
                n_conv += 1
                print(f"  [変換] {cid}: 非JPEG画像を JPEG に変換して配置 <- {url}")
            src_counts["gk-p"] += 1
            time.sleep(args.sleep)     # gk-p.jp を叩いたときだけ待つ

        failed = False
        if need_r2:
            try:
                s3.put_object(Bucket=bucket,
                              Key=image_layout.image_key(args.version, cid),
                              Body=data,
                              ContentType=image_layout.CONTENT_TYPE,
                              CacheControl=args.cache_control)
            except Exception as e:  # noqa
                failed = True
                print(f"  [失敗] {cid}: R2 アップロード失敗 ({type(e).__name__}: {e})")
        if need_hosting and not failed:
            try:
                with open(local_path, "wb") as f:
                    f.write(data)
            except Exception as e:  # noqa
                failed = True
                print(f"  [失敗] {cid}: Hosting 配置失敗 ({type(e).__name__}: {e})")

        if failed:
            n_fail += 1
        else:
            n_done += 1
            placed_ids.append(cid)
        if i % 50 == 0:
            print(f"  ... {i}/{len(plan)} (done={n_done} skip={n_skip} fail={n_fail})")

    print(f"\n配置完了: 新規 {n_done}（うち JPEG 変換 {n_conv}） / "
          f"スキップ(既存) {n_skip} / 失敗 {n_fail}")
    if src_counts:
        print(f"  取得元      : " + " / ".join(f"{k}={v}" for k, v in sorted(src_counts.items())))
        print(f"  ※ gk-p.jp を叩いたのは {src_counts.get('gk-p', 0)} 件"
              "（残りは配置済みの画像を再利用したので、主系と代替はバイト一致）")
    if n_fail:
        print("  ⚠️ 失敗があります。master 投入前に原因を確認してください。")

    # ---- 検証: 配置先に過不足が無いか ----
    if use_r2:
        after = {i for i in (image_layout.id_from_key(k)
                             for k in r2_utils.list_keys(s3, bucket, prefix)) if i}
        missing = required_ids - after
        print(f"\n検証(主系R2)   : {len(after)} オブジェクト（今回の対象 {len(required_ids)}）")
        if missing:
            print(f"  ⚠️ 未配置が {len(missing)} 件残っています: {sorted(missing)[:10]}")
        else:
            print("  ✅ 今回の対象はすべて R2 に存在します")
    if use_hosting:
        after_h = hosting_utils.existing_ids(hosting_dir, args.version)
        missing_h = required_ids - after_h
        print(f"検証(代替Hosting): {len(after_h)} ファイル（今回の対象 {len(required_ids)}）")
        if missing_h:
            print(f"  ⚠️ 未配置が {len(missing_h)} 件残っています: {sorted(missing_h)[:10]}")
        else:
            print("  ✅ 今回の対象はすべてローカルに配置済みです")
    if args.limit:
        print("  ※ --limit 指定のため、master 全件との過不足は確認していません")

    # ---- Hosting のデプロイ ----
    deployed = False
    if use_hosting:
        if args.deploy:
            print(f"\nデプロイ中（{args.project} / {hosting_dir}）...")
            run(["firebase", "deploy", "--only", "hosting"], cwd=hosting_dir)
            print("デプロイ完了")
            deployed = True
        else:
            print("\n（--deploy 未指定のため配置のみ。デプロイは手動で実行してください）")
            print(f"  cd {hosting_dir} && firebase deploy --only hosting")

    # ---- 検証: 配信URLを実地で叩く（1件）----
    check_id = placed_ids[0] if placed_ids else (plan[0][0] if plan else None)
    if check_id:
        print("\n配信確認:")
        if use_r2:
            u = image_layout.image_url(base_url, args.version, check_id)
            status, ctype = head_public_url(u)
            print(f"  主系 {u}\n    -> {status} {ctype}")
            if status != 200:
                print("    ⚠️ 200 になりません。バケットの公開設定（カスタムドメイン接続）を確認してください。")
            elif "image/jpeg" not in (ctype or ""):
                print("    ⚠️ Content-Type が image/jpeg ではありません。")
        if use_hosting:
            u = image_layout.image_url(hosting_base_url, args.version, check_id)
            status, ctype = head_public_url(u)
            print(f"  代替 {u}\n    -> {status} {ctype}")
            if status == 200 and "image/jpeg" not in (ctype or ""):
                print("    ⚠️ Content-Type が image/jpeg ではありません。")
            elif status != 200:
                if deployed:
                    print("    ⚠️ デプロイ済みなのに 200 になりません。firebase deploy の対象プロジェクトを確認してください。")
                else:
                    print("    ※ 未デプロイなので 404 で正常。--deploy するか手動デプロイ後にもう一度確認してください。")

    if use_r2 and use_hosting and not args.dry_run:
        print("\n※ master の image_url（主系）と image_sub_url（代替）の両方が上の URL を指します。"
              "\n  build_master.py の出力と突き合わせてください。")


if __name__ == "__main__":
    main()
