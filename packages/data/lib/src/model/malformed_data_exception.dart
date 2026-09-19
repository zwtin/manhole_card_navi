/// 外から受け取ったデータが、想定した形ではない。
class MalformedDataException implements Exception {
  const MalformedDataException(this.message, {this.cause, this.stackTrace});

  final String message;

  final Object? cause;

  /// [cause] が起きたときのスタックトレース。
  final StackTrace? stackTrace;

  @override
  String toString() => 'MalformedDataException: $message';
}
