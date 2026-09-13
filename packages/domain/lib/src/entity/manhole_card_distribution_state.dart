import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_distribution_state.freezed.dart';

@freezed
sealed class ManholeCardDistributionState with _$ManholeCardDistributionState {
  const factory ManholeCardDistributionState.distributing() = Distributing;
  const factory ManholeCardDistributionState.stopped() = Stopped;
  const factory ManholeCardDistributionState.notClear() = NotClear;

  factory ManholeCardDistributionState.fromString(String value) {
    switch (value) {
      case 'distributing':
        return const ManholeCardDistributionState.distributing();
      case 'stopped':
        return const ManholeCardDistributionState.stopped();
      case 'notClear':
        return const ManholeCardDistributionState.notClear();
      default:
        throw ArgumentError(
          'Unknown ManholeCardDistributionState value: $value',
        );
    }
  }
}

extension ManholeCardDistributionStateExtension
    on ManholeCardDistributionState {
  String toStringValue() {
    switch (runtimeType) {
      case const (Distributing):
        return 'distributing';
      case const (Stopped):
        return 'stopped';
      case const (NotClear):
        return 'notClear';
      default:
        throw StateError(
          'Unknown ManholeCardDistributionState type: $runtimeType',
        );
    }
  }
}
