import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:domain/domain.dart';
// FirebaseException は firebase_core のもので、firebase_auth も公開している。
import 'package:firebase_auth/firebase_auth.dart' show FirebaseException;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'crashlytics_mock.dart';

class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

void main() {
  late MockFirebaseRemoteConfig remoteConfig;
  late MockFirebaseCrashlytics crashlytics;
  late RemoteConfigDataSource reader;

  setUp(() {
    remoteConfig = MockFirebaseRemoteConfig();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    reader = RemoteConfigDataSource(
      remoteConfig,
      FailureRecorder(crashlytics: crashlytics),
    );
    when(() => remoteConfig.fetchAndActivate()).thenAnswer((_) async => true);
  });

  test('値があれば、取り直さずにそのまま返す', () async {
    when(() => remoteConfig.getString('key')).thenReturn('value');

    expect(await reader.readString('key'), 'value');
    verifyNever(() => remoteConfig.fetchAndActivate());
  });

  test('空なら取り直してから読む', () async {
    final values = ['', 'value'];
    when(() => remoteConfig.getString('key'))
        .thenAnswer((_) => values.removeAt(0));

    expect(await reader.readString('key'), 'value');
    verify(() => remoteConfig.fetchAndActivate()).called(1);
  });

  test('取り直しても空なら、設定の漏れとして壊れたデータの失敗にする', () async {
    when(() => remoteConfig.getString('key')).thenReturn('');

    await expectLater(
      reader.readString('key'),
      throwsA(isA<CorruptedDataException>()),
    );
  });

  group('activate', () {
    setUpAll(() {
      registerFallbackValue(
        RemoteConfigSettings(
          fetchTimeout: Duration.zero,
          minimumFetchInterval: Duration.zero,
        ),
      );
    });

    setUp(() {
      when(() => remoteConfig.setConfigSettings(any()))
          .thenAnswer((_) async {});
    });

    test('待ち時間を 10 秒にしてから取得する', () async {
      await reader.activate();

      final settings = verify(
        () => remoteConfig.setConfigSettings(captureAny()),
      ).captured.single as RemoteConfigSettings;
      expect(settings.fetchTimeout, const Duration(seconds: 10));
      verify(() => remoteConfig.fetchAndActivate()).called(1);
    });

    test('通信できなくても止まらず、記録もしない', () async {
      when(() => remoteConfig.fetchAndActivate()).thenThrow(
        FirebaseException(plugin: 'firebase_remote_config', code: 'internal'),
      );

      await reader.activate();

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
  });
}
