/// 外部の失敗（通信・サーバーのデータ・端末の保存領域など）を data が変換して返す、
/// 失敗の種類。[Result.failure] に入れて返す。
///
/// 画面に出す文言は持たない。何が起きたかだけを表し、文言は app が種類から決める。
/// 種類は「app が表示や対応を変えたいもの」の分だけ用意する。区別が必要になったら
/// 足す（sealed なので、足したときに対応の漏れている switch はコンパイラが教える）。
///
/// 本当のバグ（Error）はここに変換せず、そのまま上へ流す。
sealed class DomainException implements Exception {
  const DomainException({this.detail, this.cause, this.stackTrace});

  /// 調査用の補足（どのデータのどこがおかしいか など）。画面には出さない。
  final String? detail;

  /// 変換する前の元の例外。
  final Object? cause;

  /// [cause] が起きたときのスタックトレース。
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType(detail: $detail, cause: $cause)';
}

/// 一時的に使えない。時間をおいてやり直せば成功しうる。
sealed class UnavailableException extends DomainException {
  const UnavailableException({super.detail, super.cause, super.stackTrace});
}

/// 通信できない。
final class OfflineException extends UnavailableException {
  const OfflineException({super.detail, super.cause, super.stackTrace});
}

/// 応答が遅すぎる。
final class TimedOutException extends UnavailableException {
  const TimedOutException({super.detail, super.cause, super.stackTrace});
}

/// 受け取ったデータが使えない（項目の欠け・型の違い・知らない値など）。
/// 利用者の側では直せない。
final class CorruptedDataException extends DomainException {
  const CorruptedDataException({super.detail, super.cause, super.stackTrace});
}

/// あるはずのデータがない。
final class NotFoundException extends DomainException {
  const NotFoundException({super.detail, super.cause, super.stackTrace});
}

/// 端末に保存・読み出しできない。
final class PersistenceException extends DomainException {
  const PersistenceException({super.detail, super.cause, super.stackTrace});
}

/// 上のどれにも当てはまらない外部の失敗。
final class UnknownException extends DomainException {
  const UnknownException({super.detail, super.cause, super.stackTrace});
}
