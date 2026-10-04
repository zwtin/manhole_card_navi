import 'package:domain/domain.dart';

import '../view_data/search_condition_view_data.dart';
import 'map_coordinate_type_name_mapper.dart';

abstract final class SearchConditionViewDataMapper {
  // 画面に出す順。ViewModel は、押された番号をこの並びで値に戻す。
  static const alreadyGetFilters = [
    AlreadyGetFilter.all,
    AlreadyGetFilter.alreadyGet,
    AlreadyGetFilter.notAlreadyGet,
  ];
  static const distributionStates = [
    DistributionState.distributing,
    DistributionState.stopped,
    DistributionState.notClear,
  ];
  static const coordinateTypes = [
    MapCoordinateType.distribution,
    MapCoordinateType.position,
  ];

  /// [volumes] は [toVolumes] で並べたもの。
  static SearchConditionViewData toViewData({
    required SearchCondition draft,
    required List<Volume> volumes,
  }) {
    final common = draft.common;
    return SearchConditionViewData(
      alreadyGetFilters: [
        for (final filter in alreadyGetFilters)
          (
            label: _alreadyGetFilterName(filter),
            selected: filter == common.alreadyGetFilter,
          ),
      ],
      volumes: [
        for (final volume in volumes)
          (label: volume.name, selected: common.volumeIds.contains(volume.id)),
      ],
      distributionStates: [
        for (final state in distributionStates)
          (
            label: _distributionStateName(state),
            selected: common.distributionStates.contains(state),
          ),
      ],
      coordinateTypes: [
        for (final type in coordinateTypes)
          (
            label: MapCoordinateTypeNameMapper.nameOf(type),
            selected: type == draft.map.coordinateType,
          ),
      ],
    );
  }

  /// 選択肢に出す弾。新しい弾から並べる。
  ///
  /// 弾の ID は「弾番号 - 1」を 4 桁ゼロ埋めした値（第01弾=0000 … 第18弾=0017）
  /// なので、ID の降順に並べる。発行日で並べると、発行日が同じ日・逆転している
  /// 弾で順序が狂う。
  static List<Volume> toVolumes(List<ManholeCard> cards) {
    final byId = <String, Volume>{};
    for (final card in cards) {
      if (card.volume.id.isEmpty) {
        continue;
      }
      byId.putIfAbsent(card.volume.id, () => card.volume);
    }
    return byId.values.toList()..sort((a, b) => b.id.compareTo(a.id));
  }

  static String _alreadyGetFilterName(AlreadyGetFilter filter) {
    return switch (filter) {
      AlreadyGetFilter.all => 'すべて',
      AlreadyGetFilter.alreadyGet => '取得済みのみ',
      AlreadyGetFilter.notAlreadyGet => '未取得のみ',
    };
  }

  static String _distributionStateName(DistributionState state) {
    return switch (state) {
      DistributionState.distributing => '配布中',
      DistributionState.stopped => '配布停止',
      DistributionState.notClear => '不明',
    };
  }
}
