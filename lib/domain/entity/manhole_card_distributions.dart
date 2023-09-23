import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_distribution.dart';

part 'manhole_card_distributions.freezed.dart';

@freezed
abstract class ManholeCardDistributions implements _$ManholeCardDistributions {
  const factory ManholeCardDistributions({
    required List<ManholeCardDistribution> list,
  }) = _ManholeCardDistributions;
  const ManholeCardDistributions._();
}
