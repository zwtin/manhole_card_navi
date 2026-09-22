sealed class DomainException implements Exception {
  const DomainException({this.detail});

  /// 調べるための補足。画面には出さない。
  final String? detail;

  @override
  String toString() => '$runtimeType(detail: $detail)';
}

/// 時間をおいてやり直せば成功しうる。
sealed class UnavailableException extends DomainException {
  const UnavailableException({super.detail});
}

final class OfflineException extends UnavailableException {
  const OfflineException({super.detail});
}

final class TimedOutException extends UnavailableException {
  const TimedOutException({super.detail});
}

/// 受け取ったデータが想定した形ではない（項目の欠け・型の違い・知らない値など）。
final class CorruptedDataException extends DomainException {
  const CorruptedDataException({super.detail});
}

final class NotFoundException extends DomainException {
  const NotFoundException({super.detail});
}

/// 端末の保存領域に読み書きできない。
final class PersistenceException extends DomainException {
  const PersistenceException({super.detail});
}

final class UnknownException extends DomainException {
  const UnknownException({super.detail});
}
