import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/model/analytics_event_model.dart';
import 'package:data/src/repository/analytics_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockAnalyticsDataSource extends Mock implements AnalyticsDataSource {}

void main() {
  late MockAnalyticsDataSource analytics;
  late MockFirebaseCrashlytics crashlytics;
  late AnalyticsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const AnalyticsEventModel(name: '', parameters: {}),
    );
  });

  setUp(() {
    analytics = MockAnalyticsDataSource();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    when(() => analytics.send(any())).thenAnswer((_) async {});
    repository = AnalyticsRepositoryImpl(
      analytics,
      CrashlyticsDataSource(crashlytics),
    );
  });

  test('イベントを Analytics に送る形にして渡す', () async {
    await repository.send(
      event: const AnalyticsEvent.screenView(
        screenName: 'detail_view',
        parameters: {'card_id': '27-226-B001'},
      ),
    );

    final sent = verify(() => analytics.send(captureAny()))
        .captured
        .single as AnalyticsEventModel;
    expect(sent.name, 'screen_pv');
    expect(sent.parameters, {
      'screen_name': 'detail_view',
      'card_id': '27-226-B001',
    });
  });

  test('送れなければ、不明な失敗として返し、元の例外を記録する', () async {
    final thrown = Exception('だめ');
    when(() => analytics.send(any())).thenThrow(thrown);

    final result = await repository.send(
      event: const AnalyticsEvent.appOpen(),
    );

    expect((result as Failure<void>).exception, isA<UnknownException>());
    expect(recordedErrors(crashlytics).single.error, same(thrown));
  });
}
