import 'package:data/src/repository/user_repository_impl.dart';
import 'package:data/src/datasource/failure_recorder.dart';
import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../datasource/crashlytics_mock.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth auth;
  late MockFirebaseAnalytics analytics;
  late MockFirebaseCrashlytics crashlytics;
  late UserRepositoryImpl repository;

  setUp(() {
    auth = MockFirebaseAuth();
    analytics = MockFirebaseAnalytics();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    when(() => analytics.setUserId(id: any(named: 'id')))
        .thenAnswer((_) async {});
    when(() => crashlytics.setUserIdentifier(any())).thenAnswer((_) async {});
    repository = UserRepositoryImpl(
      auth,
      analytics,
      crashlytics,
      FailureRecorder(crashlytics: crashlytics),
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

    final result = await repository.ensureSignedIn();

    expect(result, isA<Success<void>>());
    verifyNever(() => auth.signInAnonymously());
    verify(() => analytics.setUserId(id: 'uid-1')).called(1);
    verify(() => crashlytics.setUserIdentifier('uid-1')).called(1);
  });

  test('まだなら匿名で登録し、その利用者の ID を記録に付ける', () async {
    final credential = MockUserCredential();
    final created = user('uid-2');
    when(() => credential.user).thenReturn(created);
    when(() => auth.currentUser).thenReturn(null);
    when(() => auth.signInAnonymously()).thenAnswer((_) async => credential);

    final result = await repository.ensureSignedIn();

    expect(result, isA<Success<void>>());
    verify(() => analytics.setUserId(id: 'uid-2')).called(1);
  });

  test('通信できずに登録できなければ、通信できない失敗にする', () async {
    when(() => auth.currentUser).thenReturn(null);
    when(() => auth.signInAnonymously()).thenThrow(
      FirebaseAuthException(code: 'network-request-failed'),
    );

    final result = await repository.ensureSignedIn();

    expect((result as Failure<void>).exception, isA<OfflineException>());
    verifyNever(() => analytics.setUserId(id: any(named: 'id')));
  });

  test('利用者の ID を付けられなくても、登録はできたことにする', () async {
    final current = user('uid-3');
    when(() => auth.currentUser).thenReturn(current);
    when(() => analytics.setUserId(id: any(named: 'id')))
        .thenThrow(Exception('送れない'));

    final result = await repository.ensureSignedIn();

    expect(result, isA<Success<void>>());
    expect(recordedErrors(crashlytics).single.error, isA<UnknownException>());
  });
}
