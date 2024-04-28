import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/domain/entity/app_info.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/app_info_repository.dart';
import '/temporary_provider.dart';

final appInfoRepositoryProvider = Provider.autoDispose<AppInfoRepository>(
  (ref) {
    final appInfoRepository = AppInfoRepositoryImpl(
      ref.watch(packageInfoProvider),
    );
    ref.onDispose(appInfoRepository.dispose);
    return appInfoRepository;
  },
);

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
