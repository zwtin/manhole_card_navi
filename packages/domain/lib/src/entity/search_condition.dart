import 'package:freezed_annotation/freezed_annotation.dart';

import 'display_filter.dart';
import 'manhole_card_distribution_state.dart';
import 'map_coordinate_type.dart';

part 'search_condition.freezed.dart';

/// アプリ全体で共有される検索条件。
///
/// 一覧・マップの両画面で一貫して使う。永続化（端末保存）は data が JSON 化して
/// 担当し、変更は SearchConditionUseCase の Stream を通じて両画面へ伝わる。
///
/// - [common] : 一覧・マップに横断して効く絞り込み条件。
/// - [map]    : マップ画面にのみ効く表示オプション（座標種別）。
///
/// 将来リスト専用の条件が必要になったら `ListSearchCondition list` を追加できる
/// よう、画面ごとにサブ条件へ分けて保持している。
@freezed
abstract class SearchCondition with _$SearchCondition {
  const factory SearchCondition({
    @Default(CommonSearchCondition()) CommonSearchCondition common,
    @Default(MapSearchCondition()) MapSearchCondition map,
  }) = _SearchCondition;
  const SearchCondition._();

  /// 一切絞り込まない初期状態。
  factory SearchCondition.initial() => const SearchCondition();

  /// 有効な絞り込みの数。マップ座標種別は絞り込みではないため含めない。
  int get activeFilterCount => common.activeFilterCount;

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
    if (distributionStates.containsAll(ManholeCardDistributionState.values)) {
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

/// 一覧・マップに横断して効く絞り込み条件。
///
/// いずれの集合系フィールドも「空 = その軸では絞り込まない（すべて通過）」という
/// 規約で扱う。これにより「フィルターなし」を空集合で素直に表現できる。
@freezed
abstract class CommonSearchCondition with _$CommonSearchCondition {
  const factory CommonSearchCondition({
    /// 取得状態による絞り込み。
    @Default(DisplayFilter.all) DisplayFilter displayFilter,

    /// 対象とする弾（volume）の ID 集合。空なら弾で絞り込まない。
    @Default(<String>{}) Set<String> volumeIds,

    /// 対象とする配布状態の集合。空なら配布状態で絞り込まない。
    @Default(<ManholeCardDistributionState>{})
    Set<ManholeCardDistributionState> distributionStates,
  }) = _CommonSearchCondition;
  const CommonSearchCondition._();

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

  /// 配布状態の条件に合致するか（空なら常に true）。
  bool matchesDistributionState(ManholeCardDistributionState state) {
    return distributionStates.isEmpty || distributionStates.contains(state);
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
}

/// マップ画面にのみ効く表示オプション。
@freezed
abstract class MapSearchCondition with _$MapSearchCondition {
  const factory MapSearchCondition({
    /// 表示する座標の種別。
    @Default(MapCoordinateType.distribution) MapCoordinateType coordinateType,
  }) = _MapSearchCondition;
}
