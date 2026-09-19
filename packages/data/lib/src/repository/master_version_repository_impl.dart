import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../datasource/failure_recorder.dart';
import '../datasource/remote_config_data_source.dart';
import '../mapper/domain_exception_mapper.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(
    this._preferences,
    this._remoteConfig,
    this._failureRecorder,
  );

  /// 使うべきバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_master_version';

  /// 取り込み済みのバージョンを保存する SharedPreferences のキー。
  static const _currentVersionKey = 'current_master_version';

  final _logger = Logger();
  final StreamingSharedPreferences _preferences;
  final RemoteConfigDataSource _remoteConfig;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<MasterVersion>> getInquiredVersion() {
    return _failureRecorder.guard(
      () async => MasterVersion(
        value: await _remoteConfig.readString(_inquiredVersionKey),
      ),
      convert: DomainExceptionMapper.fromRemoteConfig,
    );
  }

  @override
  Future<Result<MasterVersion?>> getCurrentVersion() {
    return _failureRecorder.guard(
      () async {
        final value = _preferences
            .getString(_currentVersionKey, defaultValue: '')
            .getValue();
        return value.isEmpty ? null : MasterVersion(value: value);
      },
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  @override
  Future<Result<void>> setCurrentVersion({
    required MasterVersion version,
  }) {
    return _failureRecorder.guard(
      () async {
        if (!await _preferences.setString(_currentVersionKey, version.value)) {
          throw const PersistenceException(
            detail: '取り込み済みのマスターデータのバージョンを保存できませんでした',
          );
        }
      },
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  void dispose() {
    _logger.d('MasterVersionRepositoryImpl dispose');
  }
}
