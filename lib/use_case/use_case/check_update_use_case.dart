import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/current_app_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/app_info_repository.dart';
import '/domain/repository/remote_config_repository.dart';
import '/infra/repository_impl/app_info_repository_impl.dart';
import '/infra/repository_impl/remote_config_repository_impl.dart';
import '/use_case/dto/need_update_dto.dart';

final checkUpdateUseCaseProvider = Provider.autoDispose<CheckUpdateUseCase>(
  (ref) {
    final checkUpdateUseCase = CheckUpdateUseCase(
      ref.watch(appInfoRepositoryProvider),
      ref.watch(remoteConfigRepositoryProvider),
    );
    ref.onDispose(checkUpdateUseCase.dispose);
    return checkUpdateUseCase;
  },
);

class CheckUpdateUseCase {
  CheckUpdateUseCase(
    this._appInfoRepository,
    this._remoteConfigRepository,
  );

  final AppInfoRepository _appInfoRepository;
  final RemoteConfigRepository _remoteConfigRepository;

  final _logger = Logger();

  Future<Result<NeedUpdateDTO>> getNeedUpdate() async {
    final result = await Future.wait([
      _appInfoRepository.getCurrentAppVersion(),
      _remoteConfigRepository.getInquiredAppVersion(),
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
      NeedUpdateDTO(
        need: _checkNeedUpdate(
          currentAppVersion: currentAppVersion,
          inquiredAppVersion: inquiredAppVersion,
        ),
      ),
    );
  }

  bool _checkNeedUpdate({
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
    _logger.d('CheckUpdateUseCase dispose');
  }
}
