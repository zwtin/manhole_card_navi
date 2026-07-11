#!/usr/bin/env python3
"""
座標に関する共通ユーティリティ:
  - DMS（度分秒）文字列 -> 10進度 変換
  - 日本の緯度経度範囲バリデーション（誤読検出）

カード印字の形式例:
  緯度: 43°03'44.8"N
  経度: 141°21'12.8"E
DMS -> 10進:  deg + min/60 + sec/3600 （南緯/西経は負。日本は基本 N/E のみ）
"""
import re

# 日本の概ねの緯度経度範囲（離島含む余裕を持たせた範囲）。
# 南端: 沖ノ鳥島 約20.4N / 北端: 択捉島 約45.6N
# 西端: 与那国島 約122.9E / 東端: 南鳥島 約153.99E
JP_LAT_MIN, JP_LAT_MAX = 20.0, 46.0
JP_LON_MIN, JP_LON_MAX = 122.0, 154.0

# 度分秒を拾う正規表現。記号のゆれ（' ′ ’ / " ″ ” / ° º 度分秒）に耐える。
_DMS_RE = re.compile(
    r"""(\d{1,3})\s*[°º度]\s*
        (\d{1,2})\s*['′’分]\s*
        (\d{1,2}(?:\.\d+)?)\s*["″”秒]?\s*
        ([NSEWnsew北南東西])?""",
    re.X,
)


def dms_to_decimal(deg, minutes, seconds, hemisphere=""):
    """度分秒(数値) -> 10進度。半球指定 S/W/南/西 は負。"""
    val = float(deg) + float(minutes) / 60.0 + float(seconds) / 3600.0
    h = (hemisphere or "").upper()
    if h in ("S", "W", "南", "西"):
        val = -val
    return round(val, 7)


def parse_dms_string(s):
    """
    '43°03'44.8"N' のような1つのDMS文字列 -> 10進度（float）。
    解釈できなければ None。
    """
    if not s:
        return None
    m = _DMS_RE.search(s)
    if not m:
        return None
    deg, minutes, seconds, hemi = m.groups()
    try:
        return dms_to_decimal(deg, minutes, seconds, hemi or "")
    except (ValueError, TypeError):
        return None


def validate_jp_latlon(lat, lon):
    """
    (lat, lon) が日本範囲内か。戻り値: (ok: bool, reason: str)
    緯度と経度が入れ替わっている可能性も検出する。
    """
    if lat is None or lon is None:
        return False, "緯度または経度が None"
    lat_ok = JP_LAT_MIN <= lat <= JP_LAT_MAX
    lon_ok = JP_LON_MIN <= lon <= JP_LON_MAX
    if lat_ok and lon_ok:
        return True, ""
    # 入れ替わり検出
    if (JP_LAT_MIN <= lon <= JP_LAT_MAX) and (JP_LON_MIN <= lat <= JP_LON_MAX):
        return False, "緯度と経度が入れ替わっている可能性"
    reasons = []
    if not lat_ok:
        reasons.append(f"緯度 {lat} が日本範囲({JP_LAT_MIN}-{JP_LAT_MAX})外")
    if not lon_ok:
        reasons.append(f"経度 {lon} が日本範囲({JP_LON_MIN}-{JP_LON_MAX})外")
    return False, " / ".join(reasons)


if __name__ == "__main__":
    # 簡易自己テスト
    assert abs(parse_dms_string("43°03'44.8\"N") - 43.062444) < 1e-5
    assert abs(parse_dms_string("141°21'12.8\"E") - 141.353556) < 1e-5
    ok, _ = validate_jp_latlon(43.062444, 141.353556)
    assert ok
    ok, reason = validate_jp_latlon(141.35, 43.06)
    assert not ok and "入れ替わ" in reason
    ok, _ = validate_jp_latlon(5.0, 200.0)
    assert not ok
    print("geo_utils 自己テスト OK")
