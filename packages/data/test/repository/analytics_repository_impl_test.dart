import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/repository/analytics_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../datasource/crashlytics_mock.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics analytics;
  late AnalyticsRepositoryImpl repository;

  setUp(() {
    analytics = MockFirebaseAnalytics();
    final crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    when(() => analytics.logAppOpen()).thenAnswer((_) async {});
    when(
      () => analytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});
    repository = AnalyticsRepositoryImpl(
      analytics,
      FailureRecorder(crashlytics: crashlytics),
    );
  });

  test('アプリを開いたら app_open を送る', () async {
    await repository.send(event: const AnalyticsEvent.appOpen());

    verify(() => analytics.logAppOpen()).called(1);
  });

  test('画面の表示は、画面の名前と補足を screen_pv で送る', () async {
    await repository.send(
      event: const AnalyticsEvent.screenView(
        screenName: 'detail_view',
        parameters: {'card_id': '27-226-B001'},
      ),
    );

    verify(
      () => analytics.logEvent(
        name: 'screen_pv',
        parameters: {'screen_name': 'detail_view', 'card_id': '27-226-B001'},
      ),
    ).called(1);
  });
}
