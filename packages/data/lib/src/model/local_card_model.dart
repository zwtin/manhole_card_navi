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

@JsonSerializable(checked: true)
class LocalCoordinateModel {
  const LocalCoordinateModel({required this.latitude, required this.longitude});

  factory LocalCoordinateModel.fromJson(Map<String, dynamic> json) =>
      _$LocalCoordinateModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalCoordinateModelToJson(this);

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
