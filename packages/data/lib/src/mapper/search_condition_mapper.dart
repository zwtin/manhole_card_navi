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
        pinSize: _toPinSizeModel(condition.map.pinSize),
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
        pinSize: _toMapPinSize(model.map.pinSize),
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

  static PinSizeModel _toPinSizeModel(MapPinSize size) {
    return switch (size) {
      MapPinSize.smallest => PinSizeModel.smallest,
      MapPinSize.small => PinSizeModel.small,
      MapPinSize.medium => PinSizeModel.medium,
      MapPinSize.large => PinSizeModel.large,
      MapPinSize.largest => PinSizeModel.largest,
    };
  }

  static MapPinSize _toMapPinSize(PinSizeModel model) {
    return switch (model) {
      PinSizeModel.smallest => MapPinSize.smallest,
      PinSizeModel.small => MapPinSize.small,
      PinSizeModel.medium => MapPinSize.medium,
      PinSizeModel.large => MapPinSize.large,
      PinSizeModel.largest => MapPinSize.largest,
    };
  }
}
