import 'package:test/test.dart';

import 'package:domain/domain.dart';

void main() {
  test('範囲の端の値で作れる', () {
    for (final (latitude, longitude) in [
      (90.0, 180.0),
      (-90.0, -180.0),
      (0.0, 0.0),
    ]) {
      final coordinate = Coordinate(latitude: latitude, longitude: longitude);

      expect(coordinate.latitude, latitude);
      expect(coordinate.longitude, longitude);
    }
  });

  test('範囲外・NaN・無限大は作れない', () {
    for (final (latitude, longitude) in [
      (90.000001, 0.0),
      (-90.000001, 0.0),
      (0.0, 180.000001),
      (0.0, -180.000001),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.infinity, 0.0),
      (0.0, double.negativeInfinity),
    ]) {
      expect(
        () => Coordinate(latitude: latitude, longitude: longitude),
        throwsFormatException,
        reason: '$latitude, $longitude',
      );
    }
  });

  test('同じ緯度・経度なら等しい', () {
    final a = Coordinate(latitude: 35.68, longitude: 139.76);
    final b = Coordinate(latitude: 35.68, longitude: 139.76);

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(Coordinate(latitude: 35.68, longitude: 139.77)));
  });
}
