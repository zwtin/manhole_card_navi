import 'package:domain/domain.dart';

import '../model/distribution_state_model.dart';

/// 配布状態の model とエンティティの変換。
abstract final class DistributionStateMapper {
  static DistributionStateModel toModel(DistributionState state) {
    return switch (state) {
      DistributionState.distributing => DistributionStateModel.distributing,
      DistributionState.stopped => DistributionStateModel.stopped,
      DistributionState.notClear => DistributionStateModel.notClear,
    };
  }

  static DistributionState toDistributionState(DistributionStateModel model) {
    return switch (model) {
      DistributionStateModel.distributing => DistributionState.distributing,
      DistributionStateModel.stopped => DistributionState.stopped,
      DistributionStateModel.notClear => DistributionState.notClear,
    };
  }
}
