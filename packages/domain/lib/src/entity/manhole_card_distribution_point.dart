import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_distribution_point.freezed.dart';

@freezed
abstract class ManholeCardDistributionPoint
    with _$ManholeCardDistributionPoint {
  const factory ManholeCardDistributionPoint({
    required double latitude,
    required double longitude,
  }) = _ManholeCardDistributionPoint;
  const ManholeCardDistributionPoint._();
}
