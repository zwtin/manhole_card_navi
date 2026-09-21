import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/model/analytics_event_model.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics analytics;
  late AnalyticsDataSource dataSource;

  setUp(() {
    analytics = MockFirebaseAnalytics();
    dataSource = AnalyticsDataSource(analytics);
  });

  test('イベントの名前とパラメータを送る', () async {
    when(
      () => analytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});

    await dataSource.send(
      const AnalyticsEventModel(
        name: 'screen_pv',
        parameters: {'screen_name': 'detail_view'},
      ),
    );

    verify(
      () => analytics.logEvent(
        name: 'screen_pv',
        parameters: {'screen_name': 'detail_view'},
      ),
    ).called(1);
  });

  test('利用者の ID を渡す', () async {
    when(() => analytics.setUserId(id: any(named: 'id')))
        .thenAnswer((_) async {});

    await dataSource.setUserId('user');

    verify(() => analytics.setUserId(id: 'user')).called(1);
  });
}
