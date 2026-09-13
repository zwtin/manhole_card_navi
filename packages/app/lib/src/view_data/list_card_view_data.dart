import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_card_view_data.freezed.dart';

@freezed
abstract class ListCardViewData with _$ListCardViewData {
  const factory ListCardViewData({
    required String id,
    required String imageUrl,

    /// カード画像の代替配信元のフル URL。[imageUrl] が取得できなかった
    /// ときに使う。代替を持たない master では空文字。
    required String imageSubUrl,
    required bool alreadyGet,
    required String name,
    required String volume,
    required String publicationDate,
  }) = _ListCardViewData;
  const ListCardViewData._();
}
