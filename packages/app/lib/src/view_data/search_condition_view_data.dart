import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_condition_view_data.freezed.dart';

/// 弾の選択肢（ID と表示名）。
typedef VolumeOption = ({String id, String name});

/// 配布状態の選択肢（値と表示名）。
typedef DistributionStateOption = ({
  ManholeCardDistributionState state,
  String name,
});

@freezed
abstract class SearchConditionViewData with _$SearchConditionViewData {
  const factory SearchConditionViewData({
    /// 編集中のドラフト。適用するまで端末保存も他画面も変更しない。
    required SearchCondition draft,
    @Default(<VolumeOption>[]) List<VolumeOption> volumeOptions,
  }) = _SearchConditionViewData;
  const SearchConditionViewData._();

  DisplayFilter get displayFilter => draft.common.displayFilter;

  MapCoordinateType get coordinateType => draft.map.coordinateType;

  bool isVolumeSelected(String volumeId) =>
      draft.common.volumeIds.contains(volumeId);

  bool isDistributionStateSelected(ManholeCardDistributionState state) =>
      draft.common.distributionStates.contains(state);
}
