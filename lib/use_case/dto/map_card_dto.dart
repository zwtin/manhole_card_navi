import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_card_dto.freezed.dart';

@freezed
abstract class MapCardDTO with _$MapCardDTO {
  const factory MapCardDTO({
    required String id,
    required String title,
    required String cardImagePath,
    required double latitude,
    required double longitude,
    required MapCardState state,
  }) = _MapCardDTO;
  const MapCardDTO._();
}

enum MapCardState {
  distributing,
  stopped,
  notClear,
}
