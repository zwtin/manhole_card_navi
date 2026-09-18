import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/app_info_dto.dart';
import '../repository/app_info_repository.dart';

final appInfoUseCaseProvider = Provider.autoDispose<AppInfoUseCase>(
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

  Future<Result<AppInfoDTO>> get() async {
    switch (await _appInfoRepository.getAppInfo()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        return Result.success(
          AppInfoDTO(
            name: value.name,
            version: value.version,
          ),
        );
    }
  }

  void dispose() {
    _logger.d('AppInfoUseCase dispose');
  }
}
