import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/current_app_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/domain/repository/app_version_repository.dart';
import '/infra/repository_impl/app_version_repository_impl.dart';
import '/use_case/dto/current_app_version_dto.dart';

final currentAppVersionUseCaseProvider =
    Provider.autoDispose<CurrentAppVersionUseCase>(
  (ref) {
    final currentAppVersionUseCase = CurrentAppVersionUseCase(
      ref.watch(appVersionRepositoryProvider),
    );
    ref.onDispose(currentAppVersionUseCase.dispose);
    return currentAppVersionUseCase;
  },
);

class CurrentAppVersionUseCase {
  CurrentAppVersionUseCase(
    this._appVersionRepository,
  );

  final AppVersionRepository _appVersionRepository;

  final _logger = Logger();

  Future<Result<CurrentAppVersionDTO>> get() async {
    final result = await _appVersionRepository.getCurrentAppVersion();
    if (result is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'アプリバージョンの確認に失敗しました',
        ),
      );
    }
    final currentAppVersion = (result as Success<CurrentAppVersion>).value;
    return Result.success(
      CurrentAppVersionDTO(
        value: currentAppVersion.value,
      ),
    );
  }

  void dispose() {
    _logger.d('CurrentAppVersionUseCase dispose');
  }
}
