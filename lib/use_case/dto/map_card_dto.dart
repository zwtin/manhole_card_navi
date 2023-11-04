import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_card_dto.freezed.dart';

@freezed
abstract class MapCardDTO with _$MapCardDTO {
  const factory MapCardDTO({
    required String id,
    required String imagePath,
    required DistributionStateDTO distributionState,
    required double latitude,
    required double longitude,
  }) = _MapCardDTO;
  const MapCardDTO._();
}

enum DistributionStateDTO {
  distributing,
  stopped,
  notClear,
}
