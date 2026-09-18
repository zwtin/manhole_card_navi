import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';
import '../remote_config/remote_config_reader.dart';
import '../service/failure_recorder.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(
    this._instance,
  );

  /// 使うべきバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_master_version';

  /// 取り込み済みのバージョンを保存する SharedPreferences のキー。
  static const _currentVersionKey = 'current_master_version';

  final _logger = Logger();
  final _failureRecorder = FailureRecorder();
  final _remoteConfigReader = RemoteConfigReader();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<MasterVersion>> getInquiredVersion() async {
    try {
      final value = await _remoteConfigReader.readString(_inquiredVersionKey);
      return Result.success(MasterVersion(value: value));
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
        stackTrace,
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
      return _failureRecorder.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
        stackTrace,
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
        throw const PersistenceException(
          detail: '取り込み済みのマスターデータのバージョンを保存できませんでした',
        );
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
        stackTrace,
      );
    }
  }

  void dispose() {
    _logger.d('MasterVersionRepositoryImpl dispose');
  }
}
