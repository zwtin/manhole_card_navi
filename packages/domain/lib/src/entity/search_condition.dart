import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:domain/src/entity/distribution_state.dart';

part 'search_condition.freezed.dart';

@freezed
abstract class SearchCondition with _$SearchCondition {
  const factory SearchCondition({
    @Default(CommonSearchCondition()) CommonSearchCondition common,
    @Default(MapSearchCondition()) MapSearchCondition map,
  }) = _SearchCondition;
  const SearchCondition._();

  factory SearchCondition.initial() => const SearchCondition();

  int get activeFilterCount => common.activeFilterCount;

  /// すべて選んだ項目を、空（絞り込まない）にそろえる。そろえないと、絞り込んで
  /// いないのに有効な絞り込みの数に数えられる。
  SearchCondition normalized({required Set<String> allVolumeIds}) {
    var volumeIds = common.volumeIds;
    if (allVolumeIds.isNotEmpty &&
        volumeIds.length == allVolumeIds.length &&
        volumeIds.containsAll(allVolumeIds)) {
      volumeIds = const {};
    }
    var distributionStates = common.distributionStates;
    if (distributionStates.containsAll(DistributionState.values)) {
      distributionStates = const {};
    }
    return copyWith(
      common: common.copyWith(
        volumeIds: volumeIds,
        distributionStates: distributionStates,
      ),
    );
  }
}

/// 集合が空なら、その項目では絞り込まない。
@freezed
abstract class CommonSearchCondition with _$CommonSearchCondition {
  const factory CommonSearchCondition({
    @Default(AlreadyGetFilter.all) AlreadyGetFilter alreadyGetFilter,
    @Default(<String>{}) Set<String> volumeIds,
    @Default(<DistributionState>{})
    Set<DistributionState> distributionStates,
  }) = _CommonSearchCondition;
  const CommonSearchCondition._();

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

  bool matchesVolume(String volumeId) {
    return volumeIds.isEmpty || volumeIds.contains(volumeId);
  }

  bool matchesDistributionState(DistributionState state) {
    return distributionStates.isEmpty || distributionStates.contains(state);
  }

  bool matchesAlreadyGet({required bool alreadyGet}) {
    switch (alreadyGetFilter) {
      case AlreadyGetFilter.all:
        return true;
      case AlreadyGetFilter.alreadyGet:
        return alreadyGet;
      case AlreadyGetFilter.notAlreadyGet:
        return !alreadyGet;
    }
  }
}

/// 絞り込みではなく、マップの表示の設定。
@freezed
abstract class MapSearchCondition with _$MapSearchCondition {
  const factory MapSearchCondition({
    @Default(MapCoordinateType.distribution) MapCoordinateType coordinateType,
  }) = _MapSearchCondition;
}

enum AlreadyGetFilter {
  all,
  alreadyGet,
  notAlreadyGet,
}

enum MapCoordinateType {
  /// 配布場所。
  distribution,

  /// 蓋（マンホール）の場所。
  position,
}
