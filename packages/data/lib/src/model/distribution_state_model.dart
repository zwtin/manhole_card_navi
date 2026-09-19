/// カードの配布状態。Firestore の `distribution_state` と、端末に保存するカード・
/// 検索条件の値。
///
/// 値の名前がそのまま保存される文字列になる。名前を変えると、サーバーのデータや
/// 保存済みの値が読めなくなるので変えない。
enum DistributionStateModel {
  distributing,
  stopped,
  notClear,
}
