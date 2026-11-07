import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/model/distribution_state_model.dart';

part 'local_card_model.g.dart';

@JsonSerializable(checked: true, explicitToJson: true)
class LocalCardModel {
  const LocalCardModel({
    required this.id,
    required this.position,
    required this.name,
    required this.publicationDate,
    required this.distributionState,
    required this.image,
    required this.imageSub,
    required this.distributionPlaceHtml,
    required this.distributionTimeHtml,
    required this.stockHtml,
    required this.distributionPoints,
    required this.prefecture,
    required this.volume,
  });

  factory LocalCardModel.fromJson(Map<String, dynamic> json) =>
      _$LocalCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalCardModelToJson(this);

  final String id;
  final LocalCoordinateModel position;
  final String name;
  final DateTime publicationDate;
  final DistributionStateModel distributionState;
  final String image;
  final String imageSub;
  final String distributionPlaceHtml;
  final String distributionTimeHtml;
  final String stockHtml;
  final List<LocalCoordinateModel> distributionPoints;
  final LocalNamedModel prefecture;
  final LocalNamedModel volume;
}

/// 緯度・経度が地球上の範囲になければ作れない。端末のファイルが壊れていても、
/// 範囲外の座標を domain に渡さないため。
@JsonSerializable(checked: true)
class LocalCoordinateModel {
  /// 範囲外・NaN・無限大は [FormatException]。
  LocalCoordinateModel({required this.latitude, required this.longitude}) {
    if (!isValid(latitude: latitude, longitude: longitude)) {
      throw FormatException('緯度・経度が範囲外です', '$latitude, $longitude');
    }
  }

  factory LocalCoordinateModel.fromJson(Map<String, dynamic> json) =>
      _$LocalCoordinateModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalCoordinateModelToJson(this);

  /// domain の Coordinate と同じ範囲。NaN はどの比較も false になるので、範囲の
  /// 比較だけで NaN・無限大も弾ける。
  static bool isValid({required double latitude, required double longitude}) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  final double latitude;
  final double longitude;
}

@JsonSerializable(checked: true)
class LocalNamedModel {
  const LocalNamedModel({required this.id, required this.name});

  factory LocalNamedModel.fromJson(Map<String, dynamic> json) =>
      _$LocalNamedModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalNamedModelToJson(this);

  final String id;
  final String name;
}
