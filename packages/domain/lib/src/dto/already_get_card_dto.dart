import 'package:freezed_annotation/freezed_annotation.dart';

part 'already_get_card_dto.freezed.dart';

@freezed
abstract class AlreadyGetCardDTO with _$AlreadyGetCardDTO {
  const factory AlreadyGetCardDTO({
    required String cardId,
  }) = _AlreadyGetCardDTO;
  const AlreadyGetCardDTO._();
}
