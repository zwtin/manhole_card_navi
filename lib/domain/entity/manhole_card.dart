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

    /// カード画像の配信用フル URL。Firestore にそのまま格納された値を用いる。
    /// 例: `https://images.example.com/master/v0003/images/00-101-A001.jpg`
    required String image,

    /// 配布場所の HTML。施設名・住所・電話が混在したまま保持する。
    required String distributionPlaceHtml,

    /// 配布時間の HTML。曜日・時間帯・休業日が混在したまま保持する。
    required String distributionTimeHtml,

    /// 在庫状況の HTML。
    required String stockHtml,

    /// 配布場所の座標。0 件のカードもある。
    required ManholeCardDistributionPoints distributionPoints,
    required ManholeCardPrefecture prefecture,
    required ManholeCardVolume volume,
  }) = _ManholeCard;
  const ManholeCard._();
}
