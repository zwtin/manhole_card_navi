import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_dto.freezed.dart';

@freezed
abstract class CardDTO with _$CardDTO {
  const factory CardDTO({
    required String id,
    required String name,

    /// カード画像の配信用フル URL（Firestore 格納値をそのまま利用）。
    required String imagePath,

    /// カード画像の代替配信元のフル URL（Firestore の `image_sub_url`）。
    /// [imagePath] が取得できなかったときに使う。無ければ空文字。
    required String imageSubPath,
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
