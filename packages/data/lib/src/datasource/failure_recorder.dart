import 'dart:async';

import 'package:domain/domain.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// data が返す失敗のうち、調べる必要のあるものを Crashlytics の非重大に記録する。
///
/// Repository は失敗をすべてこれを通して返す（ふつうは [guard] を使う）。
/// 通信できない・タイムアウト（[UnavailableException]）は、時間をおけば直り、調べても
/// 直せないうえ件数に埋もれて調べるべき失敗が見えにくくなるので記録しない。
class FailureRecorder {
  FailureRecorder({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics;

  final FirebaseCrashlytics? _crashlytics;

  /// [body] を実行し、その値を成功として返す。
  ///
  /// 例外が出たら [convert] で失敗の種類に変換し、[failure] を通して返す。[body] の
  /// 中で投げた [DomainException] は、変換されずにそのまま失敗になる。
  Future<Result<T>> guard<T>(
    Future<T> Function() body, {
    required DomainException Function(Object error, StackTrace stackTrace)
        convert,
  }) async {
    try {
      return Result.success(await body());
    } on Exception catch (error, stackTrace) {
      return failure(convert(error, stackTrace), stackTrace);
    }
  }

  /// [exception] を失敗として返す。調べる必要のある種類なら記録する。
  ///
  /// 記録するスタックは、変換前の例外のもの（[DomainException.stackTrace]）、
  /// なければ [stackTrace]（失敗を受け取った場所）、それもなければ呼び出した場所。
  Result<T> failure<T>(DomainException exception, [StackTrace? stackTrace]) {
    if (_needsInvestigation(exception)) {
      unawaited(
        (_crashlytics ?? FirebaseCrashlytics.instance)
            .recordError(
              exception,
              exception.stackTrace ?? stackTrace ?? StackTrace.current,
            )
            // 記録の失敗で本体の動作を止めない。
            .onError((_, __) {}),
      );
    }
    return Result.failure(exception);
  }

  static bool _needsInvestigation(DomainException exception) {
    return switch (exception) {
      UnavailableException() => false,
      CorruptedDataException() ||
      NotFoundException() ||
      PersistenceException() ||
      UnknownException() =>
        true,
    };
  }
}
