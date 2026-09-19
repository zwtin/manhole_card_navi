import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:domain/src/entity/coordinate.dart';
import 'package:domain/src/entity/distribution_state.dart';
import 'package:domain/src/entity/prefecture.dart';
import 'package:domain/src/entity/volume.dart';

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

    required String distributionPlaceHtml,
    required String distributionTimeHtml,
    required String stockHtml,

    /// 配布場所の位置。0 件のカードもある。
    required List<Coordinate> distributionPoints,
    required Prefecture prefecture,
    required Volume volume,
  }) = _ManholeCard;
  const ManholeCard._();
}
