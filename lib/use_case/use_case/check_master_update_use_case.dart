import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/domain/entity/result.dart';
import '/domain/repository/master_version_repository.dart';
import '/domain/repository/remote_config_repository.dart';
import '/domain/repository/volume_repository.dart';
import '/infra/repository_impl/master_version_repository_impl.dart';
import '/infra/repository_impl/remote_config_repository_impl.dart';
import '/infra/repository_impl/volume_repository_impl.dart';
import '/use_case/dto/need_master_update_dto.dart';

final checkMasterUpdateUseCaseProvider =
    Provider.autoDispose<CheckMasterUpdateUseCase>(
  (ref) {
    final checkMasterUpdateUseCase = CheckMasterUpdateUseCase(
      ref.watch(masterVersionRepositoryProvider),
      ref.watch(remoteConfigRepositoryProvider),
      ref.watch(volumeRepositoryProvider),
    );
    ref.onDispose(checkMasterUpdateUseCase.dispose);
    return checkMasterUpdateUseCase;
  },
);

class CheckMasterUpdateUseCase {
  CheckMasterUpdateUseCase(
    this._masterVersionRepository,
    this._remoteConfigRepository,
    this._volumeRepository,
  );

  final MasterVersionRepository _masterVersionRepository;
  final RemoteConfigRepository _remoteConfigRepository;
  final VolumeRepository _volumeRepository;

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

  Future<Result<void>> updateMaster() async {
    final getInquiredMasterVersionResult =
        await _remoteConfigRepository.getInquiredMasterVersion();
    if (getInquiredMasterVersionResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }
    final inquiredMasterVersion =
        (getInquiredMasterVersionResult as Success<InquiredMasterVersion>)
            .value;
    final currentMasterVersion =
        CurrentMasterVersion(version: inquiredMasterVersion.version);

    final result = await Future.wait([
      _updateVolumeMaster(currentMasterVersion: currentMasterVersion),
    ]);

    if (result.whereType<Failure>().isNotEmpty) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    final setCurrentMasterVersionResult = await _masterVersionRepository
        .setCurrentMasterVersion(currentMasterVersion: currentMasterVersion);
    if (setCurrentMasterVersionResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    return const Result.success(null);
  }

  Future<Result<void>> _updateVolumeMaster({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final fetchResult = await _volumeRepository.fetchMaster(
      currentMasterVersion: currentMasterVersion,
    );
    if (fetchResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }
    final manholeCardVolumes =
        (fetchResult as Success<ManholeCardVolumes>).value;

    final deleteResult = await _volumeRepository.deleteMaster();
    if (deleteResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    final saveResult = await _volumeRepository.saveMaster(
      manholeCardVolumes: manholeCardVolumes,
    );
    if (saveResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('CheckMasterUpdateUseCase dispose');
  }
}
