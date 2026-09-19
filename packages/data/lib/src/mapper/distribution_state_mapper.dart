import 'package:data/src/model/distribution_state_model.dart';
import 'package:domain/domain.dart';

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
