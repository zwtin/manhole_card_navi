import 'package:domain/domain.dart';

import '../model/search_condition_model.dart';

/// 端末に保存する検索条件（model）とエンティティの変換。
abstract final class SearchConditionMapper {
  static SearchConditionModel toModel(SearchCondition condition) {
    return SearchConditionModel(
      common: CommonSearchConditionModel(
        displayFilter: condition.common.displayFilter,
        volumeIds: condition.common.volumeIds,
        distributionStates: condition.common.distributionStates,
      ),
      map: MapSearchConditionModel(
        coordinateType: condition.map.coordinateType,
      ),
    );
  }

  static SearchCondition toSearchCondition(SearchConditionModel model) {
    return SearchCondition(
      common: CommonSearchCondition(
        displayFilter: model.common.displayFilter,
        volumeIds: model.common.volumeIds,
        distributionStates: model.common.distributionStates,
      ),
      map: MapSearchCondition(coordinateType: model.map.coordinateType),
    );
  }
}
