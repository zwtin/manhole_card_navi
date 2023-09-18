import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/domain/entity/current_app_version.dart';
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

  @override
  Future<Result<CurrentAppVersion>> getCurrentAppVersion() async {
    final version = _packageInfo.version;
    return Result.success(
      CurrentAppVersion(
        version: version,
      ),
    );
  }

  void dispose() {
    _logger.d('AppInfoRepositoryImpl dispose');
  }
}
