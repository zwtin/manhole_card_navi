import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_condition_view_data.freezed.dart';

/// 選択肢 1 つ分。押されたことは、リストの何番目かで ViewModel に返す。
typedef OptionViewData = ({String label, bool selected});

@freezed
abstract class SearchConditionViewData with _$SearchConditionViewData {
  const factory SearchConditionViewData({
    required List<OptionViewData> alreadyGetFilters,
    required List<OptionViewData> volumes,
    required List<OptionViewData> distributionStates,
    required List<OptionViewData> coordinateTypes,
  }) = _SearchConditionViewData;
}
