import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_dto.freezed.dart';

@freezed
abstract class CardDTO with _$CardDTO {
  const factory CardDTO({
    required String id,
    required String name,
    required String imagePath,
    required double latitude,
    required double longitude,
  }) = _CardDTO;
  const CardDTO._();
}
