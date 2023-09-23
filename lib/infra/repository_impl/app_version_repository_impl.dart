import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/domain/entity/current_app_version.dart';
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
    _logger.d('AppVersionRepositoryImpl dispose');
  }
}
