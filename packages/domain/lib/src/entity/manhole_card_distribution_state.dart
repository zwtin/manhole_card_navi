import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_distribution_state.freezed.dart';

@freezed
sealed class ManholeCardDistributionState with _$ManholeCardDistributionState {
  const factory ManholeCardDistributionState.distributing() = Distributing;
  const factory ManholeCardDistributionState.stopped() = Stopped;
  const factory ManholeCardDistributionState.notClear() = NotClear;

  factory ManholeCardDistributionState.fromString(String value) {
    final state = tryFromString(value);
    if (state == null) {
      throw ArgumentError(
        'Unknown ManholeCardDistributionState value: $value',
      );
    }
    return state;
  }

  /// [value] を配布状態に変換する。知らない値なら null を返す。
  ///
  /// サーバーのデータのように、知らない値が来うるものの検証に使う。
  static ManholeCardDistributionState? tryFromString(String value) {
    switch (value) {
      case 'distributing':
        return const ManholeCardDistributionState.distributing();
      case 'stopped':
        return const ManholeCardDistributionState.stopped();
      case 'notClear':
        return const ManholeCardDistributionState.notClear();
      default:
        return null;
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
