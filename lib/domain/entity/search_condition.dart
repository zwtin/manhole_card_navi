import '/domain/entity/display_filter.dart';
import '/domain/entity/manhole_card_distribution_state.dart';
import '/domain/entity/map_coordinate_type.dart';

/// 配布状態のすべての選択肢。「すべて選択」を「空（＝すべて通過）」へ正規化する
/// 際の基準として使う。
///
/// freezed の union 型は `==` をオーバーライドするため const Set の要素にできない
/// （primitive equality 制約）。そのため const ではなく final で保持する。
final allDistributionStates = <ManholeCardDistributionState>{
  const ManholeCardDistributionState.distributing(),
  const ManholeCardDistributionState.stopped(),
  const ManholeCardDistributionState.notClear(),
};

/// アプリ全体で共有される検索条件。
///
/// 一覧・マップの両画面で一貫して使う。永続化（端末保存）は infra 層が JSON 化して
/// 担当し、変更は QueryService の Stream を通じて両画面へ伝播する。
///
/// - [common] : 一覧・マップに横断して効く絞り込み条件。
/// - [map]    : マップ画面にのみ効く表示オプション（座標種別）。
///
/// 将来リスト専用の条件が必要になったら `ListSearchCondition list` を追加できる
/// よう、画面ごとにサブ条件へ分けて保持している。
class SearchCondition {
  const SearchCondition({
    this.common = const CommonSearchCondition(),
    this.map = const MapSearchCondition(),
  });

  /// 一切絞り込まない初期状態。
  factory SearchCondition.initial() => const SearchCondition();

  final CommonSearchCondition common;
  final MapSearchCondition map;

  /// 有効な絞り込みの数。マップ座標種別は絞り込みではないため含めない。
  int get activeFilterCount => common.activeFilterCount;

  SearchCondition copyWith({
    CommonSearchCondition? common,
    MapSearchCondition? map,
  }) {
    return SearchCondition(
      common: common ?? this.common,
      map: map ?? this.map,
    );
  }

  /// 「すべて選択」を「空（＝すべて通過）」へ畳んで正規化する。
  ///
  /// 空と全選択は絞り込み結果が同じなので、保存 JSON・有効フィルタ数を素直に保つ
  /// ため空へ寄せる。弾数は選択肢がデータ依存なので [allVolumeIds] を渡す。
  SearchCondition normalized({required Set<String> allVolumeIds}) {
    var volumeIds = common.volumeIds;
    if (allVolumeIds.isNotEmpty &&
        volumeIds.length == allVolumeIds.length &&
        volumeIds.containsAll(allVolumeIds)) {
      volumeIds = const {};
    }
    var distributionStates = common.distributionStates;
    if (distributionStates.length == allDistributionStates.length &&
        distributionStates.containsAll(allDistributionStates)) {
      distributionStates = const {};
    }
    return copyWith(
      common: common.copyWith(
        volumeIds: volumeIds,
        distributionStates: distributionStates,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SearchCondition &&
        other.common == common &&
        other.map == map;
  }

  @override
  int get hashCode => Object.hash(common, map);
}

/// 一覧・マップに横断して効く絞り込み条件。
///
/// いずれの集合系フィールドも「空 = その軸では絞り込まない（すべて通過）」という
/// 規約で扱う。これにより「フィルターなし」を空集合で素直に表現できる。
class CommonSearchCondition {
  const CommonSearchCondition({
    this.displayFilter = DisplayFilter.all,
    this.volumeIds = const {},
    this.distributionStates = const {},
  });

  /// 取得状態による絞り込み。
  final DisplayFilter displayFilter;

  /// 対象とする弾（volume）の ID 集合。空なら弾で絞り込まない。
  final Set<String> volumeIds;

  /// 対象とする配布状態の集合。空なら配布状態で絞り込まない。
  final Set<ManholeCardDistributionState> distributionStates;

  /// 有効な絞り込みの数。
  int get activeFilterCount {
    var count = 0;
    if (displayFilter != DisplayFilter.all) {
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

  /// 弾の条件に合致するか（空なら常に true）。
  bool matchesVolume(String volumeId) {
    return volumeIds.isEmpty || volumeIds.contains(volumeId);
  }

  /// 配布状態の条件に合致するか（空なら常に true）。[stateValue] は DTO が保持する
  /// 文字列値（'distributing' / 'stopped' / 'notClear'）。
  bool matchesDistributionState(String stateValue) {
    if (distributionStates.isEmpty) {
      return true;
    }
    return distributionStates
        .map((state) => state.toStringValue())
        .contains(stateValue);
  }

  /// 取得状態の条件に合致するか。
  bool matchesDisplay({required bool alreadyGet}) {
    switch (displayFilter) {
      case DisplayFilter.all:
        return true;
      case DisplayFilter.acquired:
        return alreadyGet;
      case DisplayFilter.unacquired:
        return !alreadyGet;
    }
  }

  CommonSearchCondition copyWith({
    DisplayFilter? displayFilter,
    Set<String>? volumeIds,
    Set<ManholeCardDistributionState>? distributionStates,
  }) {
    return CommonSearchCondition(
      displayFilter: displayFilter ?? this.displayFilter,
      volumeIds: volumeIds ?? this.volumeIds,
      distributionStates: distributionStates ?? this.distributionStates,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CommonSearchCondition &&
        other.displayFilter == displayFilter &&
        _setEquals(other.volumeIds, volumeIds) &&
        _setEquals(other.distributionStates, distributionStates);
  }

  @override
  int get hashCode => Object.hash(
        displayFilter,
        Object.hashAllUnordered(volumeIds),
        Object.hashAllUnordered(distributionStates),
      );
}

/// マップ画面にのみ効く表示オプション。
class MapSearchCondition {
  const MapSearchCondition({
    this.coordinateType = MapCoordinateType.distribution,
  });

  /// 表示する座標の種別。
  final MapCoordinateType coordinateType;

  MapSearchCondition copyWith({
    MapCoordinateType? coordinateType,
  }) {
    return MapSearchCondition(
      coordinateType: coordinateType ?? this.coordinateType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MapSearchCondition && other.coordinateType == coordinateType;
  }

  @override
  int get hashCode => coordinateType.hashCode;
}

bool _setEquals<T>(Set<T> a, Set<T> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  return a.containsAll(b);
}
