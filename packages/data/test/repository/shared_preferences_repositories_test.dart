import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/repository/already_get_card_repository_impl.dart';
import 'package:data/src/repository/master_version_repository_impl.dart';
import 'package:data/src/repository/search_condition_repository_impl.dart';
import 'package:data/src/repository/terms_of_service_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockRemoteConfigReader extends Mock implements RemoteConfigDataSource {}

void main() {
  late StreamingSharedPreferences preferences;
  late FailureRecorder failureRecorder;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    preferences = await StreamingSharedPreferences.instance;
  });

  setUp(() async {
    await preferences.clear();
    final crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    failureRecorder = FailureRecorder(CrashlyticsDataSource(crashlytics));
  });

  group('AlreadyGetCardRepositoryImpl', () {
    late AlreadyGetCardRepositoryImpl repository;

    setUp(() {
      repository = AlreadyGetCardRepositoryImpl(preferences, failureRecorder);
    });

    test('取得済みにした ID を読める。同じ ID を 2 回保存しても 1 つ', () async {
      await repository.save(cardId: 'A');
      await repository.save(cardId: 'B');
      await repository.save(cardId: 'A');

      expect(await repository.watch().first, {'A', 'B'});
    });

    test('未取得に戻すと、その ID だけ消える', () async {
      await repository.save(cardId: 'A');
      await repository.save(cardId: 'B');

      await repository.delete(cardId: 'A');

      expect(await repository.watch().first, {'B'});
    });

    test('変わるたびに、取得済みの ID が流れる', () async {
      final values = <Set<String>>[];
      final subscription = repository.watch().listen(values.add);

      await repository.save(cardId: 'A');
      await pumpEventQueue();
      await subscription.cancel();

      expect(values.last, {'A'});
    });
  });

  group('SearchConditionRepositoryImpl', () {
    test('保存した検索条件を読める。保存前は絞り込みなし', () async {
      final repository = SearchConditionRepositoryImpl(
        preferences,
        failureRecorder,
      );
      expect(await repository.watch().first, SearchCondition.initial());

      const condition = SearchCondition(
        common: CommonSearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
        ),
        map: MapSearchCondition(coordinateType: MapCoordinateType.position),
      );
      await repository.save(searchCondition: condition);

      expect(await repository.watch().first, condition);
    });
  });

  group('TermsOfServiceRepositoryImpl', () {
    test('まだ同意していなければ null、同意したらそのバージョン', () async {
      final repository = TermsOfServiceRepositoryImpl(
        preferences,
        MockRemoteConfigReader(),
        failureRecorder,
      );
      expect(
        (await repository.getAgreedVersion() as Success<TermsOfServiceVersion?>)
            .value,
        isNull,
      );

      await repository.setAgreedVersion(
        version: const TermsOfServiceVersion(value: '2'),
      );

      expect(
        (await repository.getAgreedVersion() as Success<TermsOfServiceVersion?>)
            .value,
        const TermsOfServiceVersion(value: '2'),
      );
    });
  });

  group('MasterVersionRepositoryImpl', () {
    test('まだ取り込んでいなければ null、記録したらそのバージョン', () async {
      final repository = MasterVersionRepositoryImpl(
        preferences,
        MockRemoteConfigReader(),
        failureRecorder,
      );
      expect(
        (await repository.getCurrentVersion() as Success<MasterVersion?>).value,
        isNull,
      );

      await repository.setCurrentVersion(
        version: const MasterVersion(value: '0006'),
      );

      expect(
        (await repository.getCurrentVersion() as Success<MasterVersion?>).value,
        const MasterVersion(value: '0006'),
      );
    });
  });
}
