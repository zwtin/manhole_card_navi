import 'package:riverpod/riverpod.dart';

import '../exception/domain_exception.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => throw UnimplementedError('errorReporterProvider must be overridden'),
);

/// 調査のために、起きた失敗やバグを記録する窓口。data が Crashlytics で実装する。
abstract class ErrorReporter {
  /// 利用者に知らせた失敗を記録する。[reason] には何に失敗したかを渡す。
  Future<void> recordFailure(
    DomainException exception, {
    required String reason,
  });

  /// どこでも扱われなかった例外や Error（バグ）を、アプリが落ちたのと同じ重さで
  /// 記録する。[reason] にはどこで起きたかを渡す。
  Future<void> recordUncaught(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  });
}
