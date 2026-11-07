import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/preferences_data_source.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/repository/already_get_card_repository_impl.dart';
import 'package:data/src/repository/card_browsing_settings_repository_impl.dart';
import 'package:data/src/repository/master_version_repository_impl.dart';
import 'package:data/src/repository/terms_of_service_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockRemoteConfigReader extends Mock implements RemoteConfigDataSource {}

class MockPreferencesDataSource extends Mock implements PreferencesDataSource {}

void main() {
  late StreamingSharedPreferences store;
  late PreferencesDataSource preferences;
  late MockFirebaseCrashlytics crashlytics;
  late CrashlyticsDataSource crashlyticsDataSource;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    store = await StreamingSharedPreferences.instance;
    preferences = PreferencesDataSource(store);
  });

  setUp(() async {
    await store.clear();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    crashlyticsDataSource = CrashlyticsDataSource(crashlytics);
  });

  group('AlreadyGetCardRepositoryImpl', () {
    late AlreadyGetCardRepositoryImpl repository;

    setUp(() {
      repository = AlreadyGetCardRepositoryImpl(
        preferences,
        crashlyticsDataSource,
      );
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

  group('CardBrowsingSettingsRepositoryImpl', () {
    test('保存した検索条件とマップの表示を読める。保存前は絞り込みなし', () async {
      final repository = CardBrowsingSettingsRepositoryImpl(
        preferences,
        crashlyticsDataSource,
      );
      expect(await repository.watch().first, CardBrowsingSettings.initial());

      const settings = CardBrowsingSettings(
        searchCondition: SearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
        ),
        mapDisplaySettings: MapDisplaySettings(
          coordinateType: MapCoordinateType.position,
        ),
      );
      final result = await repository.save(settings: settings);

      expect(result, isA<Success<void>>());
      expect(await repository.watch().first, settings);
    });

    test('以前のバージョンが保存した値を、そのまま読める', () async {
      await store.setString(
        'search_condition',
        '{"common":{"displayFilter":"unacquired","volumeIds":["0001"],'
            '"distributionStates":["distributing"]},'
            '"map":{"coordinateType":"position","pinSize":"large"}}',
      );
      final repository = CardBrowsingSettingsRepositoryImpl(
        preferences,
        crashlyticsDataSource,
      );

      expect(
        await repository.watch().first,
        CardBrowsingSettings(
          searchCondition: SearchCondition(
            alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
            volumeIds: {'0001'},
            distributionStates: {DistributionState.distributing},
          ),
          mapDisplaySettings: const MapDisplaySettings(
            coordinateType: MapCoordinateType.position,
            pinSize: MapPinSize.large,
          ),
        ),
      );
    });

    test('検索条件とマップの表示を、1 つのキーへ 1 回で書く', () async {
      final mock = MockPreferencesDataSource();
      when(() => mock.writeString(any(), any())).thenAnswer((_) async => true);
      final repository = CardBrowsingSettingsRepositoryImpl(
        mock,
        crashlyticsDataSource,
      );

      await repository.save(
        settings: const CardBrowsingSettings(
          searchCondition: SearchCondition(
            alreadyGetFilter: AlreadyGetFilter.alreadyGet,
          ),
          mapDisplaySettings: MapDisplaySettings(pinSize: MapPinSize.large),
        ),
      );

      final captured = verify(
        () => mock.writeString(captureAny(), captureAny()),
      ).captured;
      expect(captured, hasLength(2));
      expect(captured[0], 'search_condition');
      expect(captured[1], contains('"displayFilter":"acquired"'));
      expect(captured[1], contains('"pinSize":"large"'));
    });

    test('保存できなければ、保存の失敗を返して記録する', () async {
      final mock = MockPreferencesDataSource();
      when(() => mock.writeString(any(), any())).thenAnswer((_) async => false);
      final repository = CardBrowsingSettingsRepositoryImpl(
        mock,
        crashlyticsDataSource,
      );

      final result = await repository.save(
        settings: CardBrowsingSettings.initial(),
      );

      expect((result as Failure<void>).exception, isA<PersistenceException>());
      expect(
        recordedErrors(crashlytics).single.error,
        isA<PersistenceException>(),
      );
    });

    test('保存した値が壊れていたら、絞り込みなしで続け、元の例外を記録する', () async {
      await store.setString('search_condition', '{"common":3}');
      final repository = CardBrowsingSettingsRepositoryImpl(
        preferences,
        crashlyticsDataSource,
      );

      expect(await repository.watch().first, CardBrowsingSettings.initial());
      expect(
        recordedErrors(crashlytics).single.error,
        isA<CheckedFromJsonException>(),
      );
    });
  });

  group('TermsOfServiceRepositoryImpl', () {
    test('まだ同意していなければ null、同意したらそのバージョン', () async {
      final repository = TermsOfServiceRepositoryImpl(
        preferences,
        MockRemoteConfigReader(),
        crashlyticsDataSource,
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
    test('使うべきバージョンは Remote Config から読む', () async {
      final remoteConfig = MockRemoteConfigReader();
      when(
        () => remoteConfig.readString('inquired_master_version'),
      ).thenAnswer((_) async => '0006');
      final repository = MasterVersionRepositoryImpl(
        remoteConfig,
        crashlyticsDataSource,
      );

      expect(
        (await repository.getInquiredVersion() as Success<MasterVersion>).value,
        const MasterVersion(value: '0006'),
      );
    });
  });
}
