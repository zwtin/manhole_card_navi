import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

/// Firestore の座標（GeoPoint）。
class GeoPointConverter implements JsonConverter<GeoPoint, Object?> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(Object? json) {
    if (json is GeoPoint) {
      return json;
    }
    throw FormatException('座標（GeoPoint）ではありません（${json.runtimeType}）');
  }

  @override
  Object? toJson(GeoPoint object) => object;
}

/// Firestore の座標（GeoPoint）の一覧。座標でない要素は読み飛ばす。
class GeoPointListConverter implements JsonConverter<List<GeoPoint>, Object?> {
  const GeoPointListConverter();

  @override
  List<GeoPoint> fromJson(Object? json) {
    if (json is List<dynamic>) {
      return json.whereType<GeoPoint>().toList();
    }
    throw FormatException('座標の一覧ではありません（${json.runtimeType}）');
  }

  @override
  Object? toJson(List<GeoPoint> object) => object;
}

/// `2026/01/01` の形の日付。
class SlashDateConverter implements JsonConverter<DateTime, String> {
  const SlashDateConverter();

  @override
  DateTime fromJson(String json) => DateFormat('yyyy/MM/dd').parse(json);

  @override
  String toJson(DateTime object) => DateFormat('yyyy/MM/dd').format(object);
}
