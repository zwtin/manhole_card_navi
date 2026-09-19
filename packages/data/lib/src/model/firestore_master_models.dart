import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/model/distribution_state_model.dart';
import 'package:data/src/model/firestore_converters.dart';
import 'package:data/src/model/json_decoding.dart';

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

  factory FirestoreCardModel.fromDocument(
    Map<String, dynamic> data, {
    required String path,
  }) {
    return decodeModel(data, _$FirestoreCardModelFromJson, source: path);
  }

  final String id;

  /// 蓋（マンホール）の位置。
  @GeoPointConverter()
  final GeoPoint location;

  final String name;

  @SlashDateConverter()
  final DateTime publicationDate;

  final DistributionStateModel distributionState;

  final String imageUrl;

  /// これを持たない世代の master もある。
  final String? imageSubUrl;

  final String distributionPlaceHtml;
  final String distributionTimeHtml;
  final String stockHtml;

  @GeoPointListConverter()
  final List<GeoPoint> distributionPoints;

  final String prefectureId;
  final String volumeId;
}

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
