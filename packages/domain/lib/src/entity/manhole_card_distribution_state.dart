/// カードの配布状態。
///
/// 値の名前（[name]）が、サーバーのデータや端末に保存する値
/// （`distributing` / `stopped` / `notClear`）になる。名前を変えると保存済みの
/// 値が読めなくなるので変えない。
enum ManholeCardDistributionState {
  /// 配布中。
  distributing,

  /// 配布を停止している。
  stopped,

  /// 配布しているか分からない。
  notClear,
}
