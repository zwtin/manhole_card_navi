import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/app_info.dart';
import 'package:domain/src/repository/app_info_repository.dart';

final appInfoUseCaseProvider = Provider<AppInfoUseCase>(
  (ref) => AppInfoUseCase(
    ref.watch(appInfoRepositoryProvider),
  ),
);

class AppInfoUseCase {
  AppInfoUseCase(
    this._appInfoRepository,
  );

  final AppInfoRepository _appInfoRepository;

  Future<Result<AppInfo>> get() {
    return _appInfoRepository.getAppInfo();
  }
}
