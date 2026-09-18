import 'package:app/src/service/uncaught_error_observer.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockErrorReporter extends Mock implements ErrorReporter {}

final _bugProvider = FutureProvider.autoDispose<int>(
  (ref) async => throw StateError('バグ'),
);

final _syncBugProvider = Provider.autoDispose<int>(
  (ref) => throw StateError('バグ'),
);

final _failureProvider = FutureProvider.autoDispose<int>(
  (ref) async => throw const OfflineException(),
);

void main() {
  late MockErrorReporter errorReporter;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    errorReporter = MockErrorReporter();
    when(
      () => errorReporter.recordUncaught(
        any(),
        any(),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async {});
    container = ProviderContainer(
      overrides: [errorReporterProvider.overrideWithValue(errorReporter)],
      observers: [UncaughtErrorObserver()],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('provider の中で扱われなかったバグを記録する', () async {
    final subscription = container.listen(_bugProvider, (_, __) {});
    await expectLater(container.read(_bugProvider.future), throwsStateError);
    subscription.close();

    verify(
      () => errorReporter.recordUncaught(
        any(that: isA<StateError>()),
        any(),
        reason: any(named: 'reason'),
      ),
    ).called(1);
  });

  test('同期の provider で起きたバグも記録する', () {
    expect(() => container.read(_syncBugProvider), throwsStateError);

    verify(
      () => errorReporter.recordUncaught(
        any(that: isA<StateError>()),
        any(),
        reason: any(named: 'reason'),
      ),
    ).called(1);
  });

  test('知らせてから投げた失敗（DomainException）は記録し直さない', () async {
    final subscription = container.listen(_failureProvider, (_, __) {});
    await expectLater(
      container.read(_failureProvider.future),
      throwsA(isA<OfflineException>()),
    );
    subscription.close();

    verifyNever(
      () => errorReporter.recordUncaught(
        any(),
        any(),
        reason: any(named: 'reason'),
      ),
    );
  });
}
