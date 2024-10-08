import 'package:freezed_annotation/freezed_annotation.dart';

import '/use_case/dto/contact_dto.dart';

part 'card_dto.freezed.dart';

@freezed
abstract class CardDTO with _$CardDTO {
  const factory CardDTO({
    required String id,
    required String name,
    required String colorImageUrl,
    required String grayImageUrl,
    required double latitude,
    required double longitude,
    required String prefectureId,
    required String prefectureName,
    required String volumeId,
    required String volumeName,
    required DateTime publicationDate,
    required String distributionLinkText,
    required String distributionLinkUrl,
    required String distributionText,
    required String distributionOther,
    required List<ContactDTO> contacts,
  }) = _CardDTO;
  const CardDTO._();
}
