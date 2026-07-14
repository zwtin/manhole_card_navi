import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_dto.freezed.dart';

@freezed
abstract class CardDTO with _$CardDTO {
  const factory CardDTO({
    required String id,
    required String name,

    /// カード画像の Firebase Hosting 上のパス。
    required String imagePath,
    required double latitude,
    required double longitude,
    required String prefectureId,
    required String prefectureName,
    required String volumeId,
    required String volumeName,
    required DateTime publicationDate,
    required String distributionPlaceHtml,
    required String distributionTimeHtml,
    required String stockHtml,
  }) = _CardDTO;
  const CardDTO._();
}
