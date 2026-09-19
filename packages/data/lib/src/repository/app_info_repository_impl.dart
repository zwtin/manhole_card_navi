import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../exception/domain_exception_converter.dart';
import '../remote_config/remote_config_reader.dart';
import '../service/failure_recorder.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  AppInfoRepositoryImpl(
    this._packageInfo,
    this._remoteConfigReader,
    this._failureRecorder,
  );

  /// 動かすのに必要な最低限のアプリのバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_app_version';

  final _logger = Logger();
  final PackageInfo _packageInfo;
  final RemoteConfigReader _remoteConfigReader;
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
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  @override
  Future<Result<AppVersion>> getInquiredVersion() {
    return _failureRecorder.guard(
      () async {
        final value = await _remoteConfigReader.readString(_inquiredVersionKey);
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
      convert: DomainExceptionConverter.fromRemoteConfig,
    );
  }

  void dispose() {
    _logger.d('AppInfoRepositoryImpl dispose');
  }
}
