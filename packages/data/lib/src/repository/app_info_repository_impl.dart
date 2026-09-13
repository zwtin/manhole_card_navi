import 'package:domain/domain.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  AppInfoRepositoryImpl(
    this._packageInfo,
  );

  final _logger = Logger();
  final PackageInfo _packageInfo;
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<Result<InquiredAppVersion>> getInquiredAppVersion() async {
    try {
      final inquiredAppVersion =
          _remoteConfig.getString('inquired_app_version');
      return Result.success(
        InquiredAppVersion(
          value: inquiredAppVersion,
        ),
      );
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '要求アプリバージョンの取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<AppInfo>> getAppInfo() async {
    try {
      return Result.success(
        AppInfo(
          name: const String.fromEnvironment('appName'),
          version: _packageInfo.version,
        ),
      );
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'アプリバージョンの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('AppInfoRepositoryImpl dispose');
  }
}
