import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_distribution_points.dart';
import '/domain/entity/manhole_card_distribution_state.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_volume.dart';

part 'manhole_card.freezed.dart';

@freezed
abstract class ManholeCard with _$ManholeCard {
  const factory ManholeCard({
    required String id,
    required double latitude,
    required double longitude,
    required String name,
    required DateTime publicationDate,
    required ManholeCardDistributionState distributionState,

    /// カード画像の Firebase Hosting 上のパス。
    /// 例: `master/v0003/images/00-101-A001.jpg`
    required String image,

    /// 配布場所の HTML。施設名・住所・電話が混在したまま保持する。
    required String distributionPlaceHtml,

    /// 在庫状況の HTML。
    required String stockHtml,

    /// 配布場所の座標。0 件のカードもある。
    required ManholeCardDistributionPoints distributionPoints,
    required ManholeCardPrefecture prefecture,
    required ManholeCardVolume volume,
  }) = _ManholeCard;
  const ManholeCard._();
}
