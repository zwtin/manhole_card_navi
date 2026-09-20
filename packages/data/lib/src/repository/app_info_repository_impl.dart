import 'package:package_info_plus/package_info_plus.dart';

import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  AppInfoRepositoryImpl(
    this._packageInfo,
    this._remoteConfig,
    this._failureRecorder,
  );

  static const _inquiredVersionKey = 'inquired_app_version';

  final PackageInfo _packageInfo;
  final RemoteConfigDataSource _remoteConfig;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<AppInfo>> getAppInfo() {
    return _failureRecorder.guard(
      () async {
        final version = AppVersion.tryParse(_packageInfo.version);
        if (version == null) {
          throw CorruptedDataException(
            detail: 'アプリのバージョン "${_packageInfo.version}" が読めません',
          );
        }
        return AppInfo(
          name: const String.fromEnvironment('appName'),
          version: version,
        );
      },
      convert: DomainExceptionMapper.fromPlatform,
    );
  }

  @override
  Future<Result<AppVersion>> getInquiredVersion() {
    return _failureRecorder.guard(
      () async {
        final value = await _remoteConfig.readString(_inquiredVersionKey);
        // コンソールで入力したときに紛れ込む前後の空白・改行は許す。
        final version = AppVersion.tryParse(value.trim());
        if (version == null) {
          throw CorruptedDataException(
            detail: 'Remote Config の $_inquiredVersionKey "$value" が'
                'バージョンの形ではありません',
          );
        }
        return version;
      },
      convert: DomainExceptionMapper.fromRemoteConfig,
    );
  }
}
