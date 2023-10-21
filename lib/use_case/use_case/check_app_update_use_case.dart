import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/current_app_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/app_version_repository.dart';
import '/infra/repository_impl/app_version_repository_impl.dart';
import '/use_case/dto/need_app_update_dto.dart';

final checkAppUpdateUseCaseProvider =
    Provider.autoDispose<CheckAppUpdateUseCase>(
  (ref) {
    final checkAppUpdateUseCase = CheckAppUpdateUseCase(
      ref.watch(appVersionRepositoryProvider),
    );
    ref.onDispose(checkAppUpdateUseCase.dispose);
    return checkAppUpdateUseCase;
  },
);

class CheckAppUpdateUseCase {
  CheckAppUpdateUseCase(
    this._appversionRepository,
  );

  final AppVersionRepository _appversionRepository;

  final _logger = Logger();

  Future<Result<NeedAppUpdateDTO>> getNeedUpdate() async {
    final result = await Future.wait([
      _appversionRepository.getCurrentAppVersion(),
      _appversionRepository.getInquiredAppVersion(),
    ]);

    if (result.whereType<Failure>().isNotEmpty) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'アプリバージョンの確認に失敗しました',
        ),
      );
    }

    final currentAppVersion =
        (result.elementAt(0) as Success<CurrentAppVersion>).value;
    final inquiredAppVersion =
        (result.elementAt(1) as Success<InquiredAppVersion>).value;

    return Result.success(
      NeedAppUpdateDTO(
        need: _checkNeedAppUpdate(
          currentAppVersion: currentAppVersion,
          inquiredAppVersion: inquiredAppVersion,
        ),
      ),
    );
  }

  bool _checkNeedAppUpdate({
    required CurrentAppVersion currentAppVersion,
    required InquiredAppVersion inquiredAppVersion,
  }) {
    final currentAppVersionList =
        currentAppVersion.version.split('.').map(int.parse).toList();
    final inquiredAppVersionList =
        inquiredAppVersion.version.split('.').map(int.parse).toList();

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
