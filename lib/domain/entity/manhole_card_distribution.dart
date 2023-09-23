import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_distribution.freezed.dart';

@freezed
abstract class ManholeCardDistribution implements _$ManholeCardDistribution {
  const factory ManholeCardDistribution({
    required String id,
    required String other,
    required ManholeCardDistributionState state,
  }) = _ManholeCardDistribution;
  const ManholeCardDistribution._();
}

enum ManholeCardDistributionState {
  distributing,
  stopped,
  notClear,
}
