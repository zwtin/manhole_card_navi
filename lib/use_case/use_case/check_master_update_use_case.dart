import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/manhole_card_contact.dart';
import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_images.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_prefectures.dart';
import '/domain/entity/manhole_card_volume.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/domain/entity/manhole_cards.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/domain/repository/contact_repository.dart';
import '/domain/repository/image_repository.dart';
import '/domain/repository/master_version_repository.dart';
import '/domain/repository/prefecture_repository.dart';
import '/domain/repository/remote_config_repository.dart';
import '/domain/repository/volume_repository.dart';
import '/infra/repository_impl/card_repository_impl.dart';
import '/infra/repository_impl/contact_repository_impl.dart';
import '/infra/repository_impl/image_repository_impl.dart';
import '/infra/repository_impl/master_version_repository_impl.dart';
import '/infra/repository_impl/prefecture_repository_impl.dart';
import '/infra/repository_impl/remote_config_repository_impl.dart';
import '/infra/repository_impl/volume_repository_impl.dart';
import '/use_case/dto/need_master_update_dto.dart';

final checkMasterUpdateUseCaseProvider =
    Provider.autoDispose<CheckMasterUpdateUseCase>(
  (ref) {
    final checkMasterUpdateUseCase = CheckMasterUpdateUseCase(
      ref.watch(cardRepositoryProvider),
      ref.watch(contactRepositoryProvider),
      ref.watch(imageRepositoryProvider),
      ref.watch(masterVersionRepositoryProvider),
      ref.watch(prefectureRepositoryProvider),
      ref.watch(remoteConfigRepositoryProvider),
      ref.watch(volumeRepositoryProvider),
    );
    ref.onDispose(checkMasterUpdateUseCase.dispose);
    return checkMasterUpdateUseCase;
  },
);

class CheckMasterUpdateUseCase {
  CheckMasterUpdateUseCase(
    this._cardRepository,
    this._contactRepository,
    this._imageRepository,
    this._masterVersionRepository,
    this._prefectureRepository,
    this._remoteConfigRepository,
    this._volumeRepository,
  );

  final CardRepository _cardRepository;
  final ContactRepository _contactRepository;
  final ImageRepository _imageRepository;
  final MasterVersionRepository _masterVersionRepository;
  final PrefectureRepository _prefectureRepository;
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
      _updateContactMaster(currentMasterVersion: currentMasterVersion),
      _updateImageMaster(currentMasterVersion: currentMasterVersion),
      _updatePrefectureMaster(currentMasterVersion: currentMasterVersion),
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

    final updateCardMasterResult =
        await _updateCardMaster(currentMasterVersion: currentMasterVersion);
    if (updateCardMasterResult is Failure) {
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

  Future<Result<void>> _updateCardMaster({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final fetchResult = await _cardRepository.fetchMaster(
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
    final tmpManholeCards = (fetchResult as Success<ManholeCards>).value;

    final manholeCardList = await Future.wait(
      tmpManholeCards.map(
        (manholeCard) async {
          final contactsResult = await Future.wait(
            manholeCard.contacts.map(
              (manholeCardContact) async {
                return _contactRepository.get(
                  id: manholeCardContact.id,
                );
              },
            ),
          );
          final imageResult = await _imageRepository.get(
            id: manholeCard.image.id,
          );
          final prefectureResult = await _prefectureRepository.get(
            id: manholeCard.prefecture.id,
          );
          final volumeResult = await _volumeRepository.get(
            id: manholeCard.volume.id,
          );
          if (contactsResult.whereType<Failure>().isNotEmpty ||
              imageResult is Failure ||
              prefectureResult is Failure ||
              volumeResult is Failure) {
            return null;
          }
          final contactList = contactsResult
              .whereType<Success<ManholeCardContact>>()
              .map((e) => e.value)
              .toList();
          final contacts = ManholeCardContacts(list: contactList);

          final image = (imageResult as Success<ManholeCardImage>).value;
          final prefecture =
              (prefectureResult as Success<ManholeCardPrefecture>).value;
          final volume = (volumeResult as Success<ManholeCardVolume>).value;

          return manholeCard.copyWith(
            contacts: contacts,
            image: image,
            prefecture: prefecture,
            volume: volume,
          );
        },
      ),
    );
    final manholeCards = ManholeCards(
      list: manholeCardList.whereType<ManholeCard>().toList(),
    );

    final deleteResult = await _cardRepository.deleteMaster();
    if (deleteResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    final saveResult = await _cardRepository.saveMaster(
      manholeCards: manholeCards,
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

  Future<Result<void>> _updateContactMaster({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final fetchResult = await _contactRepository.fetchMaster(
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
    final manholeCardContacts =
        (fetchResult as Success<ManholeCardContacts>).value;

    final deleteResult = await _contactRepository.deleteMaster();
    if (deleteResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    final saveResult = await _contactRepository.saveMaster(
      manholeCardContacts: manholeCardContacts,
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

  Future<Result<void>> _updateImageMaster({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final fetchResult = await _imageRepository.fetchMaster(
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
    final tmpManholeCardImages =
        (fetchResult as Success<ManholeCardImages>).value;

    final fetchImageResult = await _imageRepository.fetchImage(
      manholeCardImages: tmpManholeCardImages,
    );
    if (fetchImageResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }
    final manholeCardImages =
        (fetchImageResult as Success<ManholeCardImages>).value;

    final deleteResult = await _imageRepository.deleteMaster();
    if (deleteResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    final saveResult = await _imageRepository.saveMaster(
      manholeCardImages: manholeCardImages,
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

  Future<Result<void>> _updatePrefectureMaster({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final fetchResult = await _prefectureRepository.fetchMaster(
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
    final manholeCardPrefectures =
        (fetchResult as Success<ManholeCardPrefectures>).value;

    final deleteResult = await _prefectureRepository.deleteMaster();
    if (deleteResult is Failure) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの更新に失敗しました',
        ),
      );
    }

    final saveResult = await _prefectureRepository.saveMaster(
      manholeCardPrefectures: manholeCardPrefectures,
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
