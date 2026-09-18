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
  Future<Result<AppInfo>> getAppInfo() async {
    final version = AppVersion.tryParse(_packageInfo.version);
    if (version == null) {
      return Result.failure(
        CorruptedDataException(
          detail: 'アプリのバージョン "${_packageInfo.version}" が読めません',
        ),
      );
    }
    return Result.success(
      AppInfo(
        name: const String.fromEnvironment('appName'),
        version: version,
      ),
    );
  }

  @override
  Future<Result<AppVersion>> getInquiredVersion() async {
    try {
      final value = await _remoteConfigReader.readString(_inquiredVersionKey);
      // コンソールで入力したときに紛れ込む前後の空白・改行は許す。
      final version = AppVersion.tryParse(value.trim());
      if (version == null) {
        throw CorruptedDataException(
          detail: 'Remote Config の $_inquiredVersionKey "$value" が'
              'バージョンの形ではありません',
        );
      }
      return Result.success(version);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('AppInfoRepositoryImpl dispose');
  }
}
