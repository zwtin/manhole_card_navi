/// カードの配布状態。
enum DistributionState {
  /// 配布中。
  distributing,

  /// 配布を停止している。
  stopped,

  /// 配布しているか分からない。
  notClear,
}
