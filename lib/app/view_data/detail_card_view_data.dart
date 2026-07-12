import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_card_view_data.freezed.dart';

@freezed
abstract class DetailCardViewData with _$DetailCardViewData {
  const factory DetailCardViewData({
    required String id,
    required String imageUrl,
    required bool alreadyGet,
    required String name,
    required String prefecture,
    required String volume,
    required String publicationDate,
    required String distributionPlaceHtml,
    required String stockHtml,
  }) = _DetailCardViewData;
  const DetailCardViewData._();
}
