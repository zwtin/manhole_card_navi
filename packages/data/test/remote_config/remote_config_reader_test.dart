import 'package:data/src/remote_config/remote_config_reader.dart';
import 'package:domain/domain.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

void main() {
  late MockFirebaseRemoteConfig remoteConfig;
  late RemoteConfigReader reader;

  setUp(() {
    remoteConfig = MockFirebaseRemoteConfig();
    reader = RemoteConfigReader(remoteConfig);
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
}
