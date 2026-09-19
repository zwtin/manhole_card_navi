import 'package:data/src/mapper/distribution_state_mapper.dart';
import 'package:data/src/model/search_condition_model.dart';
import 'package:domain/domain.dart';

abstract final class SearchConditionMapper {
  static SearchConditionModel toModel(SearchCondition condition) {
    return SearchConditionModel(
      common: CommonSearchConditionModel(
        displayFilter: _toDisplayFilterModel(condition.common.alreadyGetFilter),
        volumeIds: condition.common.volumeIds,
        distributionStates: {
          for (final state in condition.common.distributionStates)
            DistributionStateMapper.toModel(state),
        },
      ),
      map: MapSearchConditionModel(
        coordinateType: _toCoordinateTypeModel(condition.map.coordinateType),
      ),
    );
  }

  static SearchCondition toSearchCondition(SearchConditionModel model) {
    return SearchCondition(
      common: CommonSearchCondition(
        alreadyGetFilter: _toAlreadyGetFilter(model.common.displayFilter),
        volumeIds: model.common.volumeIds,
        distributionStates: {
          for (final state in model.common.distributionStates)
            DistributionStateMapper.toDistributionState(state),
        },
      ),
      map: MapSearchCondition(
        coordinateType: _toMapCoordinateType(model.map.coordinateType),
      ),
    );
  }

  static DisplayFilterModel _toDisplayFilterModel(AlreadyGetFilter filter) {
    return switch (filter) {
      AlreadyGetFilter.all => DisplayFilterModel.all,
      AlreadyGetFilter.alreadyGet => DisplayFilterModel.acquired,
      AlreadyGetFilter.notAlreadyGet => DisplayFilterModel.unacquired,
    };
  }

  static AlreadyGetFilter _toAlreadyGetFilter(DisplayFilterModel model) {
    return switch (model) {
      DisplayFilterModel.all => AlreadyGetFilter.all,
      DisplayFilterModel.acquired => AlreadyGetFilter.alreadyGet,
      DisplayFilterModel.unacquired => AlreadyGetFilter.notAlreadyGet,
    };
  }

  static CoordinateTypeModel _toCoordinateTypeModel(MapCoordinateType type) {
    return switch (type) {
      MapCoordinateType.distribution => CoordinateTypeModel.distribution,
      MapCoordinateType.position => CoordinateTypeModel.position,
    };
  }

  static MapCoordinateType _toMapCoordinateType(CoordinateTypeModel model) {
    return switch (model) {
      CoordinateTypeModel.distribution => MapCoordinateType.distribution,
      CoordinateTypeModel.position => MapCoordinateType.position,
    };
  }
}
