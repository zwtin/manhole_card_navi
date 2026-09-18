import 'package:domain/domain.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(
    this._instance,
  );

  /// 使うべきバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_master_version';

  /// 取り込み済みのバージョンを保存する SharedPreferences のキー。
  static const _currentVersionKey = 'current_master_version';

  final _logger = Logger();
  final _remoteConfig = FirebaseRemoteConfig.instance;
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<MasterVersion>> getInquiredVersion() async {
    try {
      var value = _remoteConfig.getString(_inquiredVersionKey);
      if (value.isEmpty) {
        // 起動時の取得（main.dart）に失敗していると値が空のままなので、ここで
        // 取り直す。呼ぶ側がやり直したときに、通信が戻っていれば取得できる。
        await _remoteConfig.fetchAndActivate();
        value = _remoteConfig.getString(_inquiredVersionKey);
      }
      if (value.isEmpty) {
        return const Result.failure(
          CorruptedDataException(
            detail: 'Remote Config の inquired_master_version が空です',
          ),
        );
      }
      return Result.success(MasterVersion(value: value));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<MasterVersion?>> getCurrentVersion() async {
    try {
      final value = _instance
          .getString(_currentVersionKey, defaultValue: '')
          .getValue();
      return Result.success(value.isEmpty ? null : MasterVersion(value: value));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> setCurrentVersion({
    required MasterVersion version,
  }) async {
    try {
      final saved = await _instance.setString(
        _currentVersionKey,
        version.value,
      );
      if (!saved) {
        return const Result.failure(
          PersistenceException(
            detail: '取り込み済みのマスターデータのバージョンを保存できませんでした',
          ),
        );
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('MasterVersionRepositoryImpl dispose');
  }
}
