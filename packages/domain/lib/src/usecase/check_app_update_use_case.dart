import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/app_info.dart';
import 'package:domain/src/repository/app_info_repository.dart';

final checkAppUpdateUseCaseProvider =
    Provider<CheckAppUpdateUseCase>(
  (ref) {
    final checkAppUpdateUseCase = CheckAppUpdateUseCase(
      ref.watch(appInfoRepositoryProvider),
    );
    ref.onDispose(checkAppUpdateUseCase.dispose);
    return checkAppUpdateUseCase;
  },
);

class CheckAppUpdateUseCase {
  CheckAppUpdateUseCase(
    this._appInfoRepository,
  );

  final AppInfoRepository _appInfoRepository;

  final _logger = Logger();

  Future<Result<bool>> getNeedUpdate() async {
    final AppInfo appInfo;
    switch (await _appInfoRepository.getAppInfo()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        appInfo = value;
    }

    switch (await _appInfoRepository.getInquiredVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final inquiredVersion):
        return Result.success(appInfo.version < inquiredVersion);
    }
  }

  void dispose() {
    _logger.d('CheckAppUpdateUseCase dispose');
  }
}
