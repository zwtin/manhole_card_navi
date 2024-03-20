import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/app_info.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/app_info_repository.dart';
import '/infra/repository_impl/app_info_repository_impl.dart';
import '/use_case/dto/need_app_update_dto.dart';

final checkAppUpdateUseCaseProvider =
    Provider.autoDispose<CheckAppUpdateUseCase>(
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

  Future<Result<NeedAppUpdateDTO>> getNeedUpdate() async {
    final result = await Future.wait([
      _appInfoRepository.getAppInfo(),
      _appInfoRepository.getInquiredAppVersion(),
    ]);

    if (result.whereType<Failure>().isNotEmpty) {
      final exception =
          (result.firstWhere((element) => element is Failure) as Failure)
              .exception;
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

    final appInfo = (result.elementAt(0) as Success<AppInfo>).value;
    final inquiredVersion =
        (result.elementAt(1) as Success<InquiredAppVersion>).value;

    return Result.success(
      NeedAppUpdateDTO(
        value: _checkNeedUpdate(
          appInfo: appInfo,
          inquiredVersion: inquiredVersion,
        ),
      ),
    );
  }

  bool _checkNeedUpdate({
    required AppInfo appInfo,
    required InquiredAppVersion inquiredVersion,
  }) {
    final currentAppVersionList =
        appInfo.version.split('.').map(int.parse).toList();
    final inquiredAppVersionList =
        inquiredVersion.value.split('.').map(int.parse).toList();

    final forceVersionMap = inquiredAppVersionList.asMap();
    for (final index in forceVersionMap.keys) {
      final forceVersionElement = inquiredAppVersionList.elementAt(index);
      final appVersionElement = currentAppVersionList.elementAt(index);
      if (forceVersionElement > appVersionElement) {
        return true;
      } else {
        continue;
      }
    }
    return false;
  }

  void dispose() {
    _logger.d('CheckAppUpdateUseCase dispose');
  }
}
