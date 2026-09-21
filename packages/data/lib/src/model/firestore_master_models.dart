import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/model/distribution_state_model.dart';

part 'firestore_master_models.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: false,
  fieldRename: FieldRename.snake,
)
class FirestoreCardModel {
  const FirestoreCardModel({
    required this.id,
    required this.location,
    required this.name,
    required this.publicationDate,
    required this.distributionState,
    required this.imageUrl,
    required this.imageSubUrl,
    required this.distributionPlaceHtml,
    required this.distributionTimeHtml,
    required this.stockHtml,
    required this.distributionPoints,
    required this.prefectureId,
    required this.volumeId,
  });

  factory FirestoreCardModel.fromDocument(Map<String, dynamic> data) =>
      _$FirestoreCardModelFromJson(data);

  final String id;

  /// 蓋（マンホール）の位置。
  @_GeoPointConverter()
  final GeoPoint location;

  final String name;

  @_SlashDateConverter()
  final DateTime publicationDate;

  final DistributionStateModel distributionState;

  final String imageUrl;

  final String imageSubUrl;

  final String distributionPlaceHtml;
  final String distributionTimeHtml;
  final String stockHtml;

  @_GeoPointListConverter()
  final List<GeoPoint> distributionPoints;

  final String prefectureId;
  final String volumeId;
}

@JsonSerializable(checked: true, createToJson: false)
class FirestorePrefectureModel {
  const FirestorePrefectureModel({required this.id, required this.name});

  factory FirestorePrefectureModel.fromDocument(Map<String, dynamic> data) =>
      _$FirestorePrefectureModelFromJson(data);

  final String id;
  final String name;
}

@JsonSerializable(checked: true, createToJson: false)
class FirestoreVolumeModel {
  const FirestoreVolumeModel({required this.id, required this.name});

  factory FirestoreVolumeModel.fromDocument(Map<String, dynamic> data) =>
      _$FirestoreVolumeModelFromJson(data);

  final String id;
  final String name;
}

class _GeoPointConverter implements JsonConverter<GeoPoint, Object?> {
  const _GeoPointConverter();

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

class _GeoPointListConverter implements JsonConverter<List<GeoPoint>, Object?> {
  const _GeoPointListConverter();

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

class _SlashDateConverter implements JsonConverter<DateTime, String> {
  const _SlashDateConverter();

  @override
  DateTime fromJson(String json) => DateFormat('yyyy/MM/dd').parse(json);

  @override
  String toJson(DateTime object) => DateFormat('yyyy/MM/dd').format(object);
}
