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
}

/// 集合が空なら、その項目では絞り込まない。
@freezed
abstract class CommonSearchCondition with _$CommonSearchCondition {
  const factory CommonSearchCondition({
    @Default(AlreadyGetFilter.all) AlreadyGetFilter alreadyGetFilter,
    @Default(<String>{}) Set<String> volumeIds,
    @Default(<DistributionState>{}) Set<DistributionState> distributionStates,
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
}

/// 絞り込みではなく、マップの表示の設定。
@freezed
abstract class MapSearchCondition with _$MapSearchCondition {
  const factory MapSearchCondition({
    @Default(MapCoordinateType.distribution) MapCoordinateType coordinateType,
    @Default(MapPinSize.medium) MapPinSize pinSize,
  }) = _MapSearchCondition;
}

enum AlreadyGetFilter { all, alreadyGet, notAlreadyGet }

enum MapCoordinateType {
  /// 配布場所。
  distribution,

  /// 蓋（マンホール）の場所。
  position,
}

/// マップのピンの大きさ。小さい順。
enum MapPinSize { smallest, small, medium, large, largest }
