import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_prefectures.dart';
import '/domain/entity/manhole_card_volume.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/domain/entity/manhole_cards.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/domain/repository/master_version_repository.dart';
import '/domain/repository/prefecture_repository.dart';
import '/domain/repository/volume_repository.dart';
import '/infra/repository_impl/card_repository_impl.dart';
import '/infra/repository_impl/master_version_repository_impl.dart';
import '/infra/repository_impl/prefecture_repository_impl.dart';
import '/infra/repository_impl/volume_repository_impl.dart';
import '/use_case/dto/need_master_update_dto.dart';

final checkMasterUpdateUseCaseProvider =
    Provider.autoDispose<CheckMasterUpdateUseCase>(
  (ref) {
    final checkMasterUpdateUseCase = CheckMasterUpdateUseCase(
      ref.watch(cardRepositoryProvider),
      ref.watch(masterVersionRepositoryProvider),
      ref.watch(prefectureRepositoryProvider),
      ref.watch(volumeRepositoryProvider),
    );
    ref.onDispose(checkMasterUpdateUseCase.dispose);
    return checkMasterUpdateUseCase;
  },
);

class CheckMasterUpdateUseCase {
  CheckMasterUpdateUseCase(
    this._cardRepository,
    this._masterVersionRepository,
    this._prefectureRepository,
    this._volumeRepository,
  );

  final CardRepository _cardRepository;
  final MasterVersionRepository _masterVersionRepository;
  final PrefectureRepository _prefectureRepository;
  final VolumeRepository _volumeRepository;

  final _logger = Logger();

  Future<Result<NeedMasterUpdateDTO>> getNeedUpdate() async {
    final result = await Future.wait([
      _masterVersionRepository.getCurrentVersion(),
      _masterVersionRepository.getInquiredVersion(),
    ]);

    if (result.whereType<Failure>().isNotEmpty) {
      return _convertFailure(
        (result.firstWhere((element) => element is Failure) as Failure)
            .exception,
      );
    }

    final currentVersion =
        (result.elementAt(0) as Success<CurrentMasterVersion>).value;
    final inquiredVersion =
        (result.elementAt(1) as Success<InquiredMasterVersion>).value;

    return Result.success(
      NeedMasterUpdateDTO(value: currentVersion.value != inquiredVersion.value),
    );
  }

  Future<Result<void>> updateMaster() async {
    final getInquiredVersionResult =
        await _masterVersionRepository.getInquiredVersion();
    if (getInquiredVersionResult is Failure) {
      return _convertFailure((getInquiredVersionResult as Failure).exception);
    }
    final inquiredVersion =
        (getInquiredVersionResult as Success<InquiredMasterVersion>).value;

    // 都道府県・弾はカードから参照するため、カードより先に取り込む。
    final updatePrefectureMasterResult = await _updatePrefectureMaster(
      inquiredVersion: inquiredVersion,
    );
    if (updatePrefectureMasterResult is Failure) {
      return _convertFailure(
        (updatePrefectureMasterResult as Failure).exception,
      );
    }
    final manholeCardPrefectures =
        (updatePrefectureMasterResult as Success<ManholeCardPrefectures>).value;

    final updateVolumeMasterResult = await _updateVolumeMaster(
      inquiredVersion: inquiredVersion,
    );
    if (updateVolumeMasterResult is Failure) {
      return _convertFailure((updateVolumeMasterResult as Failure).exception);
    }
    final manholeCardVolumes =
        (updateVolumeMasterResult as Success<ManholeCardVolumes>).value;

    final updateCardMasterResult = await _updateCardMaster(
      inquiredVersion: inquiredVersion,
      manholeCardPrefectures: manholeCardPrefectures,
      manholeCardVolumes: manholeCardVolumes,
    );
    if (updateCardMasterResult is Failure) {
      return _convertFailure(updateCardMasterResult.exception);
    }

    final currentMasterVersion = CurrentMasterVersion(
      value: inquiredVersion.value,
    );
    final setCurrentMasterVersionResult = await _masterVersionRepository
        .setCurrentVersion(currentMasterVersion: currentMasterVersion);
    if (setCurrentMasterVersionResult is Failure) {
      return _convertFailure(setCurrentMasterVersionResult.exception);
    }

    return const Result.success(null);
  }

  /// カードは 1 クエリで全件取れる。都道府県名・弾名は id しか持たないため、
  /// 取り込み済みのマスタから引き当てて肉付けする。
  Future<Result<void>> _updateCardMaster({
    required InquiredMasterVersion inquiredVersion,
    required ManholeCardPrefectures manholeCardPrefectures,
    required ManholeCardVolumes manholeCardVolumes,
  }) async {
    final fetchResult = await _cardRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      return _convertFailure((fetchResult as Failure).exception);
    }
    final fetchedManholeCards = (fetchResult as Success<ManholeCards>).value;

    final prefectureById = <String, ManholeCardPrefecture>{
      for (final prefecture in manholeCardPrefectures.list)
        prefecture.id: prefecture,
    };
    final volumeById = <String, ManholeCardVolume>{
      for (final volume in manholeCardVolumes.list) volume.id: volume,
    };

    final manholeCards = ManholeCards(
      list: fetchedManholeCards.map(
        (manholeCard) {
          return manholeCard.copyWith(
            prefecture: prefectureById[manholeCard.prefecture.id] ??
                manholeCard.prefecture,
            volume: volumeById[manholeCard.volume.id] ?? manholeCard.volume,
          );
        },
      ).toList(),
    );

    final deleteResult = await _cardRepository.deleteMaster();
    if (deleteResult is Failure) {
      return _convertFailure(deleteResult.exception);
    }

    final saveResult = await _cardRepository.saveMaster(
      manholeCards: manholeCards,
    );
    if (saveResult is Failure) {
      return _convertFailure(saveResult.exception);
    }

    return const Result.success(null);
  }

  Future<Result<ManholeCardPrefectures>> _updatePrefectureMaster({
    required InquiredMasterVersion inquiredVersion,
  }) async {
    final fetchResult = await _prefectureRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      return _convertFailure((fetchResult as Failure).exception);
    }
    final manholeCardPrefectures =
        (fetchResult as Success<ManholeCardPrefectures>).value;

    final deleteResult = await _prefectureRepository.deleteMaster();
    if (deleteResult is Failure) {
      return _convertFailure(deleteResult.exception);
    }

    final saveResult = await _prefectureRepository.saveMaster(
      manholeCardPrefectures: manholeCardPrefectures,
    );
    if (saveResult is Failure) {
      return _convertFailure(saveResult.exception);
    }

    return Result.success(manholeCardPrefectures);
  }

  Future<Result<ManholeCardVolumes>> _updateVolumeMaster({
    required InquiredMasterVersion inquiredVersion,
  }) async {
    final fetchResult = await _volumeRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      return _convertFailure((fetchResult as Failure).exception);
    }
    final manholeCardVolumes =
        (fetchResult as Success<ManholeCardVolumes>).value;

    final deleteResult = await _volumeRepository.deleteMaster();
    if (deleteResult is Failure) {
      return _convertFailure(deleteResult.exception);
    }

    final saveResult = await _volumeRepository.saveMaster(
      manholeCardVolumes: manholeCardVolumes,
    );
    if (saveResult is Failure) {
      return _convertFailure(saveResult.exception);
    }

    return Result.success(manholeCardVolumes);
  }

  /// 失敗した Result を、呼び出し元が返せる型の Result に詰め替える。
  Result<T> _convertFailure<T>(Exception exception) {
    if (exception is CustomException) {
      return Result.failure(exception);
    }
    return const Result.failure(
      CustomException(title: 'エラー', text: '不明なエラーが発生しました。'),
    );
  }

  void dispose() {
    _logger.d('CheckMasterUpdateUseCase dispose');
  }
}
