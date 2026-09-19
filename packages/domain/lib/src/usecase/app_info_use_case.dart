import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/app_info.dart';
import 'package:domain/src/repository/app_info_repository.dart';

final appInfoUseCaseProvider = Provider<AppInfoUseCase>(
  (ref) {
    final appInfoUseCase = AppInfoUseCase(
      ref.watch(appInfoRepositoryProvider),
    );
    ref.onDispose(appInfoUseCase.dispose);
    return appInfoUseCase;
  },
);

class AppInfoUseCase {
  AppInfoUseCase(
    this._appInfoRepository,
  );

  final AppInfoRepository _appInfoRepository;

  final _logger = Logger();

  Future<Result<AppInfo>> get() {
    return _appInfoRepository.getAppInfo();
  }

  void dispose() {
    _logger.d('AppInfoUseCase dispose');
  }
}
