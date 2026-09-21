import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/repository/app_info_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';

class MockRemoteConfigReader extends Mock implements RemoteConfigDataSource {}

void main() {
  late MockRemoteConfigReader remoteConfig;
  late AppInfoRepositoryImpl Function(String version) repository;

  setUp(() {
    remoteConfig = MockRemoteConfigReader();
    final crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = (version) => AppInfoRepositoryImpl(
          PackageInfo(
            appName: 'マンホールカードナビ',
            packageName: 'com.example',
            version: version,
            buildNumber: '1',
          ),
          remoteConfig,
          CrashlyticsDataSource(crashlytics),
        );
  });

  test('端末のアプリのバージョンを読む。読めなければ壊れたデータの失敗', () async {
    expect(
      (await repository('1.5.0').getAppInfo() as Success<AppInfo>).value.version,
      AppVersion.parse('1.5.0'),
    );
    expect(
      (await repository('1.5.0-dev').getAppInfo() as Failure<AppInfo>).exception,
      isA<CorruptedDataException>(),
    );
  });

  test('要求バージョンの前後の空白・改行は許す', () async {
    when(() => remoteConfig.readString('inquired_app_version'))
        .thenAnswer((_) async => ' 1.4.0\n');

    final result = await repository('1.5.0').getInquiredVersion();

    expect((result as Success<AppVersion>).value, AppVersion.parse('1.4.0'));
  });

  test('要求バージョンがバージョンの形でなければ、壊れたデータの失敗', () async {
    when(() => remoteConfig.readString('inquired_app_version'))
        .thenAnswer((_) async => 'latest');

    final result = await repository('1.5.0').getInquiredVersion();

    expect(
      (result as Failure<AppVersion>).exception,
      isA<CorruptedDataException>(),
    );
  });
}
