import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/domain/entity/current_app_version.dart';
import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/app_version_repository.dart';
import '/temporary_provider.dart';

final appVersionRepositoryProvider = Provider.autoDispose<AppVersionRepository>(
  (ref) {
    final appVersionRepository = AppVersionRepositoryImpl(
      ref.watch(packageInfoProvider),
    );
    ref.onDispose(appVersionRepository.dispose);
    return appVersionRepository;
  },
);

class AppVersionRepositoryImpl implements AppVersionRepository {
  AppVersionRepositoryImpl(
    this._packageInfo,
  );

  final _logger = Logger();
  final PackageInfo _packageInfo;
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<Result<InquiredAppVersion>> getInquiredAppVersion() async {
    final inquiredAppVersion = _remoteConfig.getString('inquired_app_version');
    return Result.success(
      InquiredAppVersion(
        value: inquiredAppVersion,
      ),
    );
  }

  @override
  Future<Result<CurrentAppVersion>> getCurrentAppVersion() async {
    final version = _packageInfo.version;
    return Result.success(
      CurrentAppVersion(
        value: version,
      ),
    );
  }

  void dispose() {
    _logger.d('AppVersionRepositoryImpl dispose');
  }
}
