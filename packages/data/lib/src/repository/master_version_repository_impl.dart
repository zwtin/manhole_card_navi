import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';
import '../remote_config/remote_config_reader.dart';
import '../service/failure_recorder.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(
    this._preferences,
    this._remoteConfigReader,
    this._failureRecorder,
  );

  /// 使うべきバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_master_version';

  /// 取り込み済みのバージョンを保存する SharedPreferences のキー。
  static const _currentVersionKey = 'current_master_version';

  final _logger = Logger();
  final StreamingSharedPreferences _preferences;
  final RemoteConfigReader _remoteConfigReader;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<MasterVersion>> getInquiredVersion() {
    return _failureRecorder.guard(
      () async => MasterVersion(
        value: await _remoteConfigReader.readString(_inquiredVersionKey),
      ),
      convert: DomainExceptionConverter.fromRemoteConfig,
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
      convert: DomainExceptionConverter.fromLocalStorage,
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
      convert: DomainExceptionConverter.fromLocalStorage,
    );
  }

  void dispose() {
    _logger.d('MasterVersionRepositoryImpl dispose');
  }
}
