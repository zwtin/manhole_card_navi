#!/usr/bin/env python3
"""カード画像の配置レイアウト（配信先に依存しない共通部分）。

画像は主系（Cloudflare R2）と代替（Firebase Hosting）の2か所に置くが、
**両者でパスは完全に同一**にしてある:

    master/v{version}/images/{id}.jpg

    主系   : {R2 配信ベースURL}/master/v{version}/images/{id}.jpg        -> cards.image_url
    代替   : {Hosting 配信ベースURL}/master/v{version}/images/{id}.jpg    -> cards.image_sub_url

パスが同じなので、代替URLはベースURLを差し替えるだけで作れる。
このモジュールはそのパス計算だけを持ち、接続設定は r2_utils / hosting_utils が持つ。

なぜ2か所に置くか:
  配信ドメイン cdn.manholecardnavi.com が、経路上のフィルタリング装置に遮断される
  端末がある（2026-07-27 の R2 移行後に発覚。新規取得ドメインでカテゴリ未分類のため、
  既定で遮断するフィルタ製品がある）。*.web.app は Google のドメインなので
  許可リストに入っており、代替経路として機能する。
  アプリは image_url の取得に失敗したときだけ image_sub_url へフォールバックするので、
  Hosting を踏むのは遮断されているごく一部のユーザーだけ。R2 に移した意味
  （egress 無料）は保たれる。
"""

# 画像は必ず JPEG に正規化して置く。R2 は拡張子から Content-Type を推測しないので
# アップロード時に明示する（省略すると application/octet-stream になり、
# ブラウザや CachedNetworkImage が画像として扱わない）。
# Hosting は拡張子から判定するので .jpg で置けばよい。
CONTENT_TYPE = "image/jpeg"

# URL に master バージョンを含めるので、同じ URL の中身が変わることはない。
# 長期キャッシュを許可して CDN / 端末のヒット率を上げる。
# Hosting 側は各 Firebase プロジェクトの firebase.json の headers で同じ値を設定済み
# （source: "/master/**/images/**"）。
DEFAULT_CACHE_CONTROL = "public, max-age=31536000, immutable"

EXT = ".jpg"


def image_prefix(version):
    """master バージョンの画像の接頭辞（末尾スラッシュ付き）。

    R2 ではオブジェクトキーの接頭辞、Hosting では public/ 配下の相対ディレクトリ。
    """
    return f"master/v{version}/images/"


def image_key(version, image_id):
    """画像1件のパス（R2 のオブジェクトキー / Hosting の public 相対パス）。"""
    return f"{image_prefix(version)}{image_id}{EXT}"


def image_url(base_url, version, image_id):
    """配信 URL。base_url を差し替えれば主系にも代替にもなる。"""
    return f"{base_url.rstrip('/')}/{image_key(version, image_id)}"


def id_from_key(key):
    """パスから画像ID（= カード記載ID）を復元する。"""
    return key.rsplit("/", 1)[-1][:-len(EXT)] if key.endswith(EXT) else None
