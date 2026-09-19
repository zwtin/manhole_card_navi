import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/data.dart';
import 'package:domain/domain.dart';

import 'crashlytics_mock.dart';

final _bugProvider = FutureProvider.autoDispose<int>(
  (ref) async => throw StateError('バグ'),
);

final _syncBugProvider = Provider.autoDispose<int>(
  (ref) => throw StateError('バグ'),
);

final _failureProvider = FutureProvider.autoDispose<int>(
  (ref) async => throw const UnknownException(),
);

void main() {
  late MockFirebaseCrashlytics crashlytics;
  late ProviderContainer container;

  setUp(() {
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    container = ProviderContainer(
      observers: [UncaughtErrorObserver(crashlytics: crashlytics)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('provider の中で扱われなかったバグを、クラッシュとして記録する', () async {
    final subscription = container.listen(_bugProvider, (_, __) {});
    await expectLater(container.read(_bugProvider.future), throwsStateError);
    subscription.close();

    final recorded = recordedErrors(crashlytics);
    expect(recorded.single.error, isA<StateError>());
    expect(recorded.single.fatal, isTrue);
  });

  test('同期の provider で起きたバグも記録する', () {
    expect(() => container.read(_syncBugProvider), throwsStateError);

    expect(recordedErrors(crashlytics).single.error, isA<StateError>());
  });

  test('data が返した失敗（DomainException）は記録し直さない', () async {
    final subscription = container.listen(_failureProvider, (_, __) {});
    await expectLater(
      container.read(_failureProvider.future),
      throwsA(isA<UnknownException>()),
    );
    subscription.close();

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
}
