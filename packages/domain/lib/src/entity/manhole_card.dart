import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinate.dart';
import 'distribution_state.dart';
import 'prefecture.dart';
import 'volume.dart';

part 'manhole_card.freezed.dart';

@freezed
abstract class ManholeCard with _$ManholeCard {
  const factory ManholeCard({
    required String id,

    /// 蓋（マンホール）の位置。
    required Coordinate position,
    required String name,
    required DateTime publicationDate,
    required DistributionState distributionState,

    /// カード画像の配信用フル URL。Firestore にそのまま格納された値を用いる。
    /// 例: `https://images.example.com/master/v0003/images/00-101-A001.jpg`
    required String image,

    /// カード画像の代替配信元のフル URL（Firestore の `image_sub_url`）。
    ///
    /// [image] の配信元が取得できなかったときに使う。主系のドメインが
    /// ネットワーク側のフィルタで遮断される端末があるため、別ドメインからも
    /// 取得できるようにしている。
    ///
    /// 代替を持たない master（`image_sub_url` を含まない世代）では空文字になる。
    required String imageSub,

    /// 配布場所の HTML。施設名・住所・電話が混在したまま保持する。
    required String distributionPlaceHtml,

    /// 配布時間の HTML。曜日・時間帯・休業日が混在したまま保持する。
    required String distributionTimeHtml,

    /// 在庫状況の HTML。
    required String stockHtml,

    /// 配布場所の位置。0 件のカードもある。
    required List<Coordinate> distributionPoints,
    required Prefecture prefecture,
    required Volume volume,
  }) = _ManholeCard;
  const ManholeCard._();
}
