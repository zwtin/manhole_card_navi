import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

/// [crashlytics] の recordError が呼ばれても何もしないようにする。
void stubRecordError(MockFirebaseCrashlytics crashlytics) {
  registerFallbackValue(StackTrace.empty);
  registerFallbackValue(<Object>[]);
  when(
    () => crashlytics.recordError(
      any(),
      any(),
      reason: any(named: 'reason'),
      information: any(named: 'information'),
      printDetails: any(named: 'printDetails'),
      fatal: any(named: 'fatal'),
    ),
  ).thenAnswer((_) async {});
}

/// recordError に渡された例外・スタック・fatal を、呼ばれた順に返す。
List<({Object? error, StackTrace? stackTrace, bool fatal})> recordedErrors(
  MockFirebaseCrashlytics crashlytics,
) {
  final captured = verify(
    () => crashlytics.recordError(
      captureAny(),
      captureAny(),
      reason: any(named: 'reason'),
      information: any(named: 'information'),
      printDetails: any(named: 'printDetails'),
      fatal: captureAny(named: 'fatal'),
    ),
  ).captured;
  return [
    for (var i = 0; i < captured.length; i += 3)
      (
        error: captured[i],
        stackTrace: captured[i + 1] as StackTrace?,
        fatal: captured[i + 2] as bool,
      ),
  ];
}
