import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

void main() {
  late MockFirebaseCrashlytics crashlytics;
  late FailureRecorder recorder;

  setUp(() {
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    recorder = FailureRecorder(CrashlyticsDataSource(crashlytics));
  });

  test('調べる必要のある失敗は、非重大として記録してから返す', () {
    for (final exception in const <DomainException>[
      CorruptedDataException(),
      NotFoundException(),
      PersistenceException(),
      UnknownException(),
    ]) {
      final result = recorder.failure<void>(exception);

      expect((result as Failure<void>).exception, same(exception));
    }

    final recorded = recordedErrors(crashlytics);
    expect(recorded, hasLength(4));
    expect(recorded.every((record) => !record.fatal), isTrue);
  });

  test('通信できない・タイムアウトは記録しない', () {
    recorder
      ..failure<void>(const OfflineException())
      ..failure<void>(const TimedOutException());

    verifyNever(
      () => crashlytics.recordError(
        any(),
        any(),
        reason: any(named: 'reason'),
        information: any(named: 'information'),
        printDetails: any(named: 'printDetails'),
        fatal: any(named: 'fatal'),
      ),
    );
  });

  test('変換前の例外のスタックがあれば、それを記録する', () {
    final causeStackTrace = StackTrace.current;
    final catchStackTrace = StackTrace.fromString('catch');

    recorder
      ..failure<void>(
        UnknownException(cause: Exception('元'), stackTrace: causeStackTrace),
        catchStackTrace,
      )
      ..failure<void>(const NotFoundException(), catchStackTrace);

    final recorded = recordedErrors(crashlytics);
    expect(recorded[0].stackTrace, same(causeStackTrace));
    expect(recorded[1].stackTrace, same(catchStackTrace));
  });

  group('guard', () {
    DomainException convert(Object error, StackTrace stackTrace) {
      return UnknownException(cause: error, stackTrace: stackTrace);
    }

    test('例外が出なければ、値を成功として返す', () async {
      final result = await recorder.guard(() async => 1, convert: convert);

      expect((result as Success<int>).value, 1);
    });

    test('例外は変換して記録し、失敗として返す', () async {
      final result = await recorder.guard<int>(
        () async => throw const FormatException('壊れている'),
        convert: convert,
      );

      final exception = (result as Failure<int>).exception;
      expect(exception, isA<UnknownException>());
      expect(exception.cause, isA<FormatException>());
      expect(recordedErrors(crashlytics).single.error, same(exception));
    });

    test('中で投げた DomainException は、そのまま失敗になる', () async {
      const thrown = NotFoundException(detail: 'ない');

      final result = await recorder.guard<int>(
        () async => throw thrown,
        convert: (error, stackTrace) => error is DomainException
            ? error
            : UnknownException(cause: error),
      );

      expect((result as Failure<int>).exception, same(thrown));
    });
  });
}
