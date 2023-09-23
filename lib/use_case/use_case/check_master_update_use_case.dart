import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/master_version_repository.dart';
import '/domain/repository/remote_config_repository.dart';
import '/infra/repository_impl/master_version_repository_impl.dart';
import '/infra/repository_impl/remote_config_repository_impl.dart';
import '/use_case/dto/need_master_update_dto.dart';

final checkMasterUpdateUseCaseProvider =
    Provider.autoDispose<CheckMasterUpdateUseCase>(
  (ref) {
    final checkMasterUpdateUseCase = CheckMasterUpdateUseCase(
      ref.watch(masterVersionRepositoryProvider),
      ref.watch(remoteConfigRepositoryProvider),
    );
    ref.onDispose(checkMasterUpdateUseCase.dispose);
    return checkMasterUpdateUseCase;
  },
);

class CheckMasterUpdateUseCase {
  CheckMasterUpdateUseCase(
    this._masterVersionRepository,
    this._remoteConfigRepository,
  );

  final MasterVersionRepository _masterVersionRepository;
  final RemoteConfigRepository _remoteConfigRepository;

  final _logger = Logger();

  Future<Result<NeedMasterUpdateDTO>> getNeedMasterUpdate() async {
    final result = await Future.wait([
      _masterVersionRepository.getCurrentMasterVersion(),
      _remoteConfigRepository.getInquiredMasterVersion(),
    ]);

    if (result.whereType<Failure>().isNotEmpty) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータのバージョンの確認に失敗しました',
        ),
      );
    }

    final currentMasterVersion =
        (result.elementAt(0) as Success<CurrentMasterVersion>).value;
    final inquiredMasterVersion =
        (result.elementAt(1) as Success<InquiredMasterVersion>).value;

    return Result.success(
      NeedMasterUpdateDTO(
        need: currentMasterVersion.version != inquiredMasterVersion.version,
      ),
    );
  }

  void dispose() {
    _logger.d('CheckMasterUpdateUseCase dispose');
  }
}
