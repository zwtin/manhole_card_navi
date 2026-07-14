import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_distribution_point.dart';

part 'manhole_card_distribution_points.freezed.dart';

@freezed
abstract class ManholeCardDistributionPoints
    with _$ManholeCardDistributionPoints {
  const factory ManholeCardDistributionPoints({
    required List<ManholeCardDistributionPoint> list,
  }) = _ManholeCardDistributionPoints;
  const ManholeCardDistributionPoints._();

  Iterable<T> map<T>(T Function(ManholeCardDistributionPoint) toElement) {
    return list.map(toElement);
  }
}
