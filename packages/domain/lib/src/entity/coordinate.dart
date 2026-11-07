/// 緯度・経度が地球上の範囲にあることを、作った時点で保証する。
final class Coordinate {
  /// 範囲外・NaN・無限大は [FormatException]。
  factory Coordinate({required double latitude, required double longitude}) {
    if (!_isValid(latitude: latitude, longitude: longitude)) {
      throw FormatException('緯度・経度が範囲外です', '$latitude, $longitude');
    }
    return Coordinate._(latitude, longitude);
  }

  const Coordinate._(this.latitude, this.longitude);

  /// NaN はどの比較も false になるので、範囲の比較だけで NaN・無限大も弾ける。
  static bool _isValid({required double latitude, required double longitude}) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is Coordinate &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'Coordinate(latitude: $latitude, longitude: $longitude)';
}
