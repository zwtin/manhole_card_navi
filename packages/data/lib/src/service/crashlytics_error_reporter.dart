import 'package:domain/domain.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsErrorReporter implements ErrorReporter {
  CrashlyticsErrorReporter(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordFailure(
    DomainException exception, {
    required String reason,
  }) {
    return _crashlytics.recordError(
      exception,
      // 変換する前の例外が起きた場所で集計されるよう、そのスタックトレースを使う。
      // data の中で直接作った失敗は元の例外を持たないので、ここまでの経路を使う。
      exception.stackTrace ?? StackTrace.current,
      reason: reason,
    );
  }

  @override
  Future<void> recordUncaught(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) {
    return _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: true,
    );
  }
}
