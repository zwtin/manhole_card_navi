import 'package:data/src/service/failure_recorder.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'crashlytics_mock.dart';

void main() {
  late MockFirebaseCrashlytics crashlytics;
  late FailureRecorder recorder;

  setUp(() {
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    recorder = FailureRecorder(crashlytics: crashlytics);
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
}
