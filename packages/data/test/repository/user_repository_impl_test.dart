import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/repository/user_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAnalyticsDataSource extends Mock implements AnalyticsDataSource {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth auth;
  late MockAnalyticsDataSource analytics;
  late MockFirebaseCrashlytics crashlytics;
  late UserRepositoryImpl repository;

  setUp(() {
    auth = MockFirebaseAuth();
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
      FailureRecorder(CrashlyticsDataSource(crashlytics)),
    );
  });

  MockUser user(String uid) {
    final user = MockUser();
    when(() => user.uid).thenReturn(uid);
    return user;
  }

  test('登録済みなら通信せず、その利用者の ID を記録に付ける', () async {
    final current = user('uid-1');
    when(() => auth.currentUser).thenReturn(current);

    final result = await repository.signIn();

    expect(result, isA<Success<void>>());
    verifyNever(() => auth.signInAnonymously());
    verify(() => analytics.setUserId('uid-1')).called(1);
    verify(() => crashlytics.setUserIdentifier('uid-1')).called(1);
  });

  test('まだなら匿名で登録し、その利用者の ID を記録に付ける', () async {
    final credential = MockUserCredential();
    final created = user('uid-2');
    when(() => credential.user).thenReturn(created);
    when(() => auth.currentUser).thenReturn(null);
    when(() => auth.signInAnonymously()).thenAnswer((_) async => credential);

    final result = await repository.signIn();

    expect(result, isA<Success<void>>());
    verify(() => analytics.setUserId('uid-2')).called(1);
  });

  test('通信できずに登録できなければ、通信できない失敗にする', () async {
    when(() => auth.currentUser).thenReturn(null);
    when(() => auth.signInAnonymously()).thenThrow(
      FirebaseAuthException(code: 'network-request-failed'),
    );

    final result = await repository.signIn();

    expect((result as Failure<void>).exception, isA<OfflineException>());
    verifyNever(() => analytics.setUserId(any()));
  });

  test('利用者の ID を付けられなくても、登録はできたことにする', () async {
    final current = user('uid-3');
    when(() => auth.currentUser).thenReturn(current);
    when(() => analytics.setUserId(any()))
        .thenThrow(Exception('送れない'));

    final result = await repository.signIn();

    expect(result, isA<Success<void>>());
    expect(recordedErrors(crashlytics).single.error, isA<UnknownException>());
  });
}
