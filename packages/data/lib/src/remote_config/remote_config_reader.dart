import 'package:domain/domain.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final remoteConfigReaderProvider = Provider<RemoteConfigReader>(
  (ref) => RemoteConfigReader(FirebaseRemoteConfig.instance),
);

/// Remote Config の値を読む。
///
/// 起動時の取得（main.dart）に失敗していると値が空のままなので、空なら取り直す。
/// 呼ぶ側がやり直したときに、通信が戻っていれば取得できる。取り直しても空なら、
/// 設定の漏れとして [CorruptedDataException] を投げる。取得の失敗はそのまま投げる。
class RemoteConfigReader {
  RemoteConfigReader(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

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
