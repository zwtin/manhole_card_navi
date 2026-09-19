import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

import 'firestore_converters.dart';
import 'json_decoding.dart';

part 'firestore_master_models.g.dart';

/// Firestore の `master/{バージョン}/cards/{ID}` のドキュメント。
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

  /// 形が想定と違えば [CorruptedDataException] を投げる。[path] はドキュメントの
  /// パスで、どれがおかしいかを調べるための補足に使う。
  factory FirestoreCardModel.fromDocument(
    Map<String, dynamic> data, {
    required String path,
  }) {
    return decodeModel(data, _$FirestoreCardModelFromJson, source: path);
  }

  final String id;

  /// マンホールの位置。
  @GeoPointConverter()
  final GeoPoint location;

  final String name;

  @SlashDateConverter()
  final DateTime publicationDate;

  final ManholeCardDistributionState distributionState;

  final String imageUrl;

  /// 代替の配信元。これを持たない世代の master もある。
  final String? imageSubUrl;

  final String distributionPlaceHtml;
  final String distributionTimeHtml;
  final String stockHtml;

  /// 配布場所の位置（0〜複数）。座標でない要素は読み飛ばす。
  @GeoPointListConverter()
  final List<GeoPoint> distributionPoints;

  final String prefectureId;
  final String volumeId;
}

/// Firestore の `master/{バージョン}/prefectures/{ID}` のドキュメント。
@JsonSerializable(checked: true, createToJson: false)
class FirestorePrefectureModel {
  const FirestorePrefectureModel({required this.id, required this.name});

  factory FirestorePrefectureModel.fromDocument(
    Map<String, dynamic> data, {
    required String path,
  }) {
    return decodeModel(data, _$FirestorePrefectureModelFromJson, source: path);
  }

  final String id;
  final String name;
}

/// Firestore の `master/{バージョン}/volumes/{ID}` のドキュメント。
@JsonSerializable(checked: true, createToJson: false)
class FirestoreVolumeModel {
  const FirestoreVolumeModel({required this.id, required this.name});

  factory FirestoreVolumeModel.fromDocument(
    Map<String, dynamic> data, {
    required String path,
  }) {
    return decodeModel(data, _$FirestoreVolumeModelFromJson, source: path);
  }

  final String id;
  final String name;
}
