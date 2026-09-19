import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinate.dart';
import 'distribution_state.dart';
import 'prefecture.dart';
import 'volume.dart';

part 'manhole_card.freezed.dart';

/// マンホールカード。
///
/// カードの画像は ID で `CardRepository.fetchImage` から受け取る。画像がどこから
/// 配信されているか（URL・代わりの配信元）は data だけが知っている。
@freezed
abstract class ManholeCard with _$ManholeCard {
  const factory ManholeCard({
    required String id,

    /// 蓋（マンホール）の位置。
    required Coordinate position,
    required String name,
    required DateTime publicationDate,
    required DistributionState distributionState,

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
