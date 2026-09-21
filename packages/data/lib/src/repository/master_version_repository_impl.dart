import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(
    this._preferences,
    this._remoteConfig,
    this._crashlytics,
  );

  static const _inquiredVersionKey = 'inquired_master_version';
  static const _currentVersionKey = 'current_master_version';

  final StreamingSharedPreferences _preferences;
  final RemoteConfigDataSource _remoteConfig;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<MasterVersion>> getInquiredVersion() async {
    try {
      return Result.success(
        MasterVersion(value: await _remoteConfig.readString(_inquiredVersionKey)),
      );
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<MasterVersion?>> getCurrentVersion() async {
    try {
      final value =
          _preferences.getString(_currentVersionKey, defaultValue: '').getValue();
      return Result.success(value.isEmpty ? null : MasterVersion(value: value));
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<void>> setCurrentVersion({
    required MasterVersion version,
  }) async {
    try {
      if (!await _preferences.setString(_currentVersionKey, version.value)) {
        throw const PersistenceException(
          detail: '取り込み済みのマスターデータのバージョンを保存できませんでした',
        );
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
