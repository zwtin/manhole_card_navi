import 'package:domain/domain.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';

class FailureRecorder {
  FailureRecorder(this._crashlytics);

  final CrashlyticsDataSource _crashlytics;

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
      _crashlytics.recordNonFatal(
        exception,
        exception.stackTrace ?? stackTrace ?? StackTrace.current,
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
