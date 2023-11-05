import 'package:freezed_annotation/freezed_annotation.dart';

import '/use_case/dto/list_card_dto.dart';

part 'list_prefecture_dto.freezed.dart';

@freezed
abstract class ListPrefectureDTO with _$ListPrefectureDTO {
  const factory ListPrefectureDTO({
    required String id,
    required String name,
    required List<ListCardDTO> cards,
  }) = _ListPrefectureDTO;
  const ListPrefectureDTO._();
}
