sealed class DomainException implements Exception {
  const DomainException({this.detail, this.cause, this.stackTrace});

  /// 調べるための補足。画面には出さない。
  final String? detail;

  final Object? cause;

  /// [cause] が起きたときのスタックトレース。
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType(detail: $detail, cause: $cause)';
}

/// 時間をおいてやり直せば成功しうる。
sealed class UnavailableException extends DomainException {
  const UnavailableException({super.detail, super.cause, super.stackTrace});
}

final class OfflineException extends UnavailableException {
  const OfflineException({super.detail, super.cause, super.stackTrace});
}

final class TimedOutException extends UnavailableException {
  const TimedOutException({super.detail, super.cause, super.stackTrace});
}

/// 受け取ったデータが想定した形ではない（項目の欠け・型の違い・知らない値など）。
final class CorruptedDataException extends DomainException {
  const CorruptedDataException({super.detail, super.cause, super.stackTrace});
}

final class NotFoundException extends DomainException {
  const NotFoundException({super.detail, super.cause, super.stackTrace});
}

/// 端末の保存領域に読み書きできない。
final class PersistenceException extends DomainException {
  const PersistenceException({super.detail, super.cause, super.stackTrace});
}

final class UnknownException extends DomainException {
  const UnknownException({super.detail, super.cause, super.stackTrace});
}
