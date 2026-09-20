import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/app_badge_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/repository/app_badge_repository_impl.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockAppBadgeDataSource extends Mock implements AppBadgeDataSource {}

void main() {
  late MockAppBadgeDataSource appBadge;
  late MockFirebaseCrashlytics crashlytics;
  late AppBadgeRepositoryImpl repository;

  setUp(() {
    appBadge = MockAppBadgeDataSource();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = AppBadgeRepositoryImpl(
      appBadge,
      FailureRecorder(CrashlyticsDataSource(crashlytics)),
    );
  });

  test('バッジの数を渡す', () async {
    when(() => appBadge.updateCount(any())).thenAnswer((_) async {});

    expect(await repository.updateCount(count: 3), isA<Success<void>>());
    verify(() => appBadge.updateCount(3)).called(1);
  });

  test('バッジを消せないときは、不明な失敗として返して記録する', () async {
    when(appBadge.remove).thenThrow(Exception('だめ'));

    final result = await repository.remove();

    expect((result as Failure<void>).exception, isA<UnknownException>());
    expect(recordedErrors(crashlytics).single.error, isA<UnknownException>());
  });
}
