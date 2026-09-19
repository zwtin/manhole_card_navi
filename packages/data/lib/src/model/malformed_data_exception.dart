/// 外から受け取ったデータ（Firestore のドキュメント・端末のファイル・Remote Config
/// の値）が、想定した形ではない。
///
/// data の中だけで使う例外で、DataSource と model が投げる。Repository が
/// DomainExceptionMapper で domain の失敗の種類（壊れたデータ）に変換する。
class MalformedDataException implements Exception {
  const MalformedDataException(this.message, {this.cause, this.stackTrace});

  /// どのデータのどこがおかしいか。調べるための補足。
  final String message;

  /// 読めなかった元の例外（JSON の変換の失敗など）。
  final Object? cause;

  /// [cause] が起きたときのスタックトレース。
  final StackTrace? stackTrace;

  @override
  String toString() => 'MalformedDataException: $message';
}
