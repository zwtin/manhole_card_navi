import 'package:domain/domain.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../mapper/domain_exception_mapper.dart';
import 'failure_recorder.dart';

/// Remote Config。
class RemoteConfigDataSource {
  RemoteConfigDataSource(
    this._remoteConfig,
    this._failureRecorder,
  );

  final FirebaseRemoteConfig _remoteConfig;
  final FailureRecorder _failureRecorder;

  /// 起動時に 1 回呼び、最新の値を取って使える状態にする。
  ///
  /// 通信できなくても止まらない。取れなければ前回取った値で続け、前回の値もなければ
  /// [readString] で読むときに取り直す。
  Future<void> activate() async {
    try {
      await _remoteConfig.setConfigSettings(
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
      await _remoteConfig.fetchAndActivate();
    } on Exception catch (error, stackTrace) {
      // 通信できない失敗は記録されない（FailureRecorder）。
      _failureRecorder.failure<void>(
        DomainExceptionMapper.fromRemoteConfig(error, stackTrace),
        stackTrace,
      );
    }
  }

  /// [key] の値を読む。
  ///
  /// 起動時の取得（[activate]）に失敗していると値が空のままなので、空なら取り直す。
  /// 呼ぶ側がやり直したときに、通信が戻っていれば取得できる。取り直しても空なら、
  /// 設定の漏れとして [CorruptedDataException] を投げる。取得の失敗はそのまま投げる。
  Future<String> readString(String key) async {
    var value = _remoteConfig.getString(key);
    if (value.isEmpty) {
      await _remoteConfig.fetchAndActivate();
      value = _remoteConfig.getString(key);
    }
    if (value.isEmpty) {
      throw CorruptedDataException(detail: 'Remote Config の $key が空です');
    }
    return value;
  }
}
