import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_marker_dto.freezed.dart';

@freezed
abstract class MapMarkerDTO with _$MapMarkerDTO {
  const factory MapMarkerDTO({
    required String cardId,
    required String colorImageUrl,
    required String grayImageUrl,
    required double latitude,
    required double longitude,
  }) = _MapMarkerDTO;
  const MapMarkerDTO._();
}
