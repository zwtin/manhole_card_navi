import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/datasource/auth_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/repository/user_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockAnalyticsDataSource extends Mock implements AnalyticsDataSource {}

void main() {
  late MockAuthDataSource auth;
  late MockAnalyticsDataSource analytics;
  late MockFirebaseCrashlytics crashlytics;
  late UserRepositoryImpl repository;

  setUp(() {
    auth = MockAuthDataSource();
    analytics = MockAnalyticsDataSource();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    when(() => analytics.setUserId(any()))
        .thenAnswer((_) async {});
    when(() => crashlytics.setUserIdentifier(any())).thenAnswer((_) async {});
    repository = UserRepositoryImpl(
      auth,
      analytics,
      CrashlyticsDataSource(crashlytics),
    );
  });

  test('登録済みなら通信せず、その利用者の ID を記録に付ける', () async {
    when(() => auth.currentUserId).thenReturn('uid-1');

    final result = await repository.signIn();

    expect(result, isA<Success<void>>());
    verifyNever(auth.signInAnonymously);
    verify(() => analytics.setUserId('uid-1')).called(1);
    verify(() => crashlytics.setUserIdentifier('uid-1')).called(1);
  });

  test('まだなら匿名で登録し、その利用者の ID を記録に付ける', () async {
    when(() => auth.currentUserId).thenReturn(null);
    when(auth.signInAnonymously).thenAnswer((_) async => 'uid-2');

    final result = await repository.signIn();

    expect(result, isA<Success<void>>());
    verify(() => analytics.setUserId('uid-2')).called(1);
  });

  test('通信できずに登録できなければ、通信できない失敗にする', () async {
    when(() => auth.currentUserId).thenReturn(null);
    when(auth.signInAnonymously).thenThrow(
      FirebaseAuthException(code: 'network-request-failed'),
    );

    final result = await repository.signIn();

    expect((result as Failure<void>).exception, isA<OfflineException>());
    verifyNever(() => analytics.setUserId(any()));
  });

  test('利用者の ID を付けられなくても、登録はできたことにする', () async {
    when(() => auth.currentUserId).thenReturn('uid-3');
    final thrown = Exception('送れない');
    when(() => analytics.setUserId(any())).thenThrow(thrown);

    final result = await repository.signIn();

    expect(result, isA<Success<void>>());
    expect(recordedErrors(crashlytics).single.error, same(thrown));
  });
}
