import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(
    this._preferences,
    this._remoteConfig,
    this._failureRecorder,
  );

  static const _inquiredVersionKey = 'inquired_master_version';
  static const _currentVersionKey = 'current_master_version';

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
}
