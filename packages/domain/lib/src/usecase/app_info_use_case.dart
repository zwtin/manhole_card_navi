import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../dto/app_info_dto.dart';
import '../entity/app_info.dart';
import '../entity/custom_exception.dart';
import '../entity/result.dart';
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
    final result = await _appInfoRepository.getAppInfo();
    if (result is Failure) {
      final exception = (result as Failure).exception;
      if (exception is CustomException) {
        return Result.failure(exception);
      } else {
        return const Result.failure(
          CustomException(
            title: 'エラー',
            text: '不明なエラーが発生しました。',
          ),
        );
      }
    }
    final appInfo = (result as Success<AppInfo>).value;
    return Result.success(
      AppInfoDTO(
        name: appInfo.name,
        version: appInfo.version,
      ),
    );
  }

  void dispose() {
    _logger.d('AppInfoUseCase dispose');
  }
}
