import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:domain/domain.dart';

class FailureRecorder {
  FailureRecorder({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics;

  final FirebaseCrashlytics? _crashlytics;

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
      // 時間をおけば直り、調べても直せない。記録すると調べるべき失敗が埋もれる。
      UnavailableException() => false,
      CorruptedDataException() ||
      NotFoundException() ||
      PersistenceException() ||
      UnknownException() =>
        true,
    };
  }
}
