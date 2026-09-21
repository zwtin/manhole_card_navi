// FirebaseException は firebase_core のもので、firebase_auth も公開している。
import 'package:firebase_auth/firebase_auth.dart' show FirebaseException;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/remote_config_data_source.dart';

class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

void main() {
  late MockFirebaseRemoteConfig remoteConfig;
  late RemoteConfigDataSource reader;

  setUp(() {
    remoteConfig = MockFirebaseRemoteConfig();
    reader = RemoteConfigDataSource(
      remoteConfig,
      minimumFetchInterval: const Duration(hours: 12),
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
      throwsA(isA<FormatException>()),
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

    test('待ち時間を 10 秒、取り直さない時間を渡されたものにして取得する', () async {
      await reader.activate();

      final settings = verify(
        () => remoteConfig.setConfigSettings(captureAny()),
      ).captured.single as RemoteConfigSettings;
      expect(settings.fetchTimeout, const Duration(seconds: 10));
      expect(settings.minimumFetchInterval, const Duration(hours: 12));
      verify(() => remoteConfig.fetchAndActivate()).called(1);
    });

    test('取得に失敗しても止まらない', () async {
      when(() => remoteConfig.fetchAndActivate()).thenThrow(
        FirebaseException(plugin: 'firebase_remote_config', code: 'internal'),
      );

      await expectLater(reader.activate(), completes);
    });
  });
}
