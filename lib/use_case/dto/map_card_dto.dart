import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_card_dto.freezed.dart';

@freezed
abstract class MapCardDTO with _$MapCardDTO {
  const factory MapCardDTO({
    required String id,
    required String pinImagePath,
    required String cardImagePath,
    required double latitude,
    required double longitude,
  }) = _MapCardDTO;
  const MapCardDTO._();
}
