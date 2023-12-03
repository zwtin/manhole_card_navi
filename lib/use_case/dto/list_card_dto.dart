import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_card_dto.freezed.dart';

@freezed
abstract class ListCardDTO with _$ListCardDTO {
  const factory ListCardDTO({
    required String id,
    required String name,
    required String imagePath,
    required String prefectureId,
    required String prefectureName,
    required String volumeId,
    required String volumeName,
    required DateTime publicationDate,
  }) = _ListCardDTO;
  const ListCardDTO._();
}
