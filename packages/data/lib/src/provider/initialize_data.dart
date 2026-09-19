import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';
import 'data_provider_overrides.dart';
import 'platform_provider.dart';

/// 起動時に data が使う外部の仕組みを準備し、main.dart の ProviderScope に渡す
/// override を返す。Firebase の初期化の後に呼ぶ。
///
/// 通信できなくても止まらない。Remote Config は取れなければ前回の値で続け、前回の
/// 値もなければ読むときに取り直す（RemoteConfigReader）。匿名ログインは起動時の
/// チェックで行う（UserRepository）。
Future<List<Override>> initializeData() async {
  final preferences = await StreamingSharedPreferences.instance;
  final packageInfo = await PackageInfo.fromPlatform();
  await _activateRemoteConfig();
  return [
    sharedPreferencesProvider.overrideWithValue(preferences),
    packageInfoProvider.overrideWithValue(packageInfo),
    ...dataProviderOverrides,
  ];
}

Future<void> _activateRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  try {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        // 電波が弱いとスプラッシュ画面のまま待たせるので、既定の 60 秒より短くする。
        fetchTimeout: const Duration(seconds: 10),
        // 開発では Remote Config を変えたらすぐ確かめたいので、毎回取り直す。
        // 本番は既定と同じ 12 時間。
        minimumFetchInterval:
            const String.fromEnvironment('flavor') == 'development'
                ? Duration.zero
                : const Duration(hours: 12),
      ),
    );
    await remoteConfig.fetchAndActivate();
  } on Exception catch (error, stackTrace) {
    // 通信できない失敗は記録されない（FailureRecorder）。
    FailureRecorder().failure<void>(
      DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
      stackTrace,
    );
  }
}
