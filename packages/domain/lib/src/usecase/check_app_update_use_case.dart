import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/need_app_update_dto.dart';
import '../entity/app_info.dart';
import '../entity/inquired_app_version.dart';
import '../repository/app_info_repository.dart';

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
    final AppInfo appInfo;
    switch (await _appInfoRepository.getAppInfo()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        appInfo = value;
    }

    final InquiredAppVersion inquiredVersion;
    switch (await _appInfoRepository.getInquiredAppVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        inquiredVersion = value;
    }

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
