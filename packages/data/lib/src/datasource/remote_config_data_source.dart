import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigDataSource {
  RemoteConfigDataSource(
    this._remoteConfig, {
    required Duration minimumFetchInterval,
  }) : _minimumFetchInterval = minimumFetchInterval;

  final FirebaseRemoteConfig _remoteConfig;

  /// 前に取ってからこの時間は取り直さない。
  final Duration _minimumFetchInterval;

  /// 取れなくても止まらず、前回取った値で続ける。前回の値もなければ [readString] で
  /// 読むときに取り直す。
  Future<void> activate() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          // 既定の 60 秒だと、電波が弱いときにスプラッシュ画面のまま待たせる。
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: _minimumFetchInterval,
        ),
      );
      await _remoteConfig.fetchAndActivate();
    } on Exception catch (_) {
      // 記録もしない。値が要るときに readString が取り直し、そこでも取れなければ
      // Repository が失敗として記録する。
    }
  }

  /// [activate] で取れていないと空なので、空なら取り直す。取り直しても空なら
  /// 設定の漏れ。
  Future<String> readString(String key) async {
    var value = _remoteConfig.getString(key);
    if (value.isEmpty) {
      await _remoteConfig.fetchAndActivate();
      value = _remoteConfig.getString(key);
    }
    if (value.isEmpty) {
      throw FormatException('Remote Config の $key が空です');
    }
    return value;
  }
}
