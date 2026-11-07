import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:domain/src/entity/distribution_state.dart';

part 'search_condition.freezed.dart';

/// カードの絞り込みの条件。集合が空なら、その項目では絞り込まない。
@freezed
abstract class SearchCondition with _$SearchCondition {
  const factory SearchCondition({
    @Default(AlreadyGetFilter.all) AlreadyGetFilter alreadyGetFilter,
    @Default(<String>{}) Set<String> volumeIds,
    @Default(<DistributionState>{}) Set<DistributionState> distributionStates,
  }) = _SearchCondition;
  const SearchCondition._();

  int get activeFilterCount {
    var count = 0;
    if (alreadyGetFilter != AlreadyGetFilter.all) {
      count++;
    }
    if (volumeIds.isNotEmpty) {
      count++;
    }
    if (distributionStates.isNotEmpty) {
      count++;
    }
    return count;
  }
}

enum AlreadyGetFilter { all, alreadyGet, notAlreadyGet }
