import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/model/malformed_data_exception.dart';

class RemoteConfigDataSource {
  RemoteConfigDataSource(
    this._remoteConfig,
    this._failureRecorder,
  );

  final FirebaseRemoteConfig _remoteConfig;
  final FailureRecorder _failureRecorder;

  /// 取れなくても止まらず、前回取った値で続ける。前回の値もなければ [readString] で
  /// 読むときに取り直す。
  Future<void> activate() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          // 既定の 60 秒だと、電波が弱いときにスプラッシュ画面のまま待たせる。
          fetchTimeout: const Duration(seconds: 10),
          // 開発では、Remote Config を変えたらすぐ確かめられるように毎回取り直す。
          minimumFetchInterval:
              const String.fromEnvironment('flavor') == 'development'
                  ? Duration.zero
                  : const Duration(hours: 12),
        ),
      );
      await _remoteConfig.fetchAndActivate();
    } on Exception catch (error, stackTrace) {
      _failureRecorder.failure<void>(
        DomainExceptionMapper.fromRemoteConfig(error, stackTrace),
        stackTrace,
      );
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
      throw MalformedDataException('Remote Config の $key が空です');
    }
    return value;
  }
}
