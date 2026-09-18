import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../exception/domain_exception_converter.dart';
import '../remote_config/remote_config_reader.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  AppInfoRepositoryImpl(
    this._packageInfo,
  );

  /// 動かすのに必要な最低限のアプリのバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_app_version';

  final _logger = Logger();
  final PackageInfo _packageInfo;
  final _remoteConfigReader = RemoteConfigReader();

  @override
  Future<Result<InquiredAppVersion>> getInquiredAppVersion() async {
    try {
      final value = await _remoteConfigReader.readString(_inquiredVersionKey);
      return Result.success(InquiredAppVersion(value: value));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<AppInfo>> getAppInfo() async {
    return Result.success(
      AppInfo(
        name: const String.fromEnvironment('appName'),
        version: _packageInfo.version,
      ),
    );
  }

  void dispose() {
    _logger.d('AppInfoRepositoryImpl dispose');
  }
}
