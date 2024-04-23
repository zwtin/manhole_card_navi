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
import '/domain/repository/volume_repository.dart';
import '/infra/repository_impl/card_repository_impl.dart';
import '/infra/repository_impl/contact_repository_impl.dart';
import '/infra/repository_impl/image_repository_impl.dart';
import '/infra/repository_impl/master_version_repository_impl.dart';
import '/infra/repository_impl/prefecture_repository_impl.dart';
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
    this._volumeRepository,
  );

  final CardRepository _cardRepository;
  final ContactRepository _contactRepository;
  final ImageRepository _imageRepository;
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

    final currentVersion =
        (result.elementAt(0) as Success<CurrentMasterVersion>).value;
    final inquiredVersion =
        (result.elementAt(1) as Success<InquiredMasterVersion>).value;

    return Result.success(
      NeedMasterUpdateDTO(
        value: currentVersion.value != inquiredVersion.value,
      ),
    );
  }

  Future<Result<void>> updateMaster() async {
    final getInquiredVersionResult =
        await _masterVersionRepository.getInquiredVersion();
    if (getInquiredVersionResult is Failure) {
      final exception = (getInquiredVersionResult as Failure).exception;
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
    final inquiredVersion =
        (getInquiredVersionResult as Success<InquiredMasterVersion>).value;

    final result = await Future.wait([
      _updateContactMaster(inquiredVersion: inquiredVersion),
      _updateImageMaster(inquiredVersion: inquiredVersion),
      _updatePrefectureMaster(inquiredVersion: inquiredVersion),
      _updateVolumeMaster(inquiredVersion: inquiredVersion),
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

    final updateCardMasterResult =
        await _updateCardMaster(inquiredVersion: inquiredVersion);
    if (updateCardMasterResult is Failure) {
      final exception = updateCardMasterResult.exception;
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

    final currentMasterVersion =
        CurrentMasterVersion(value: inquiredVersion.value);
    final setCurrentMasterVersionResult = await _masterVersionRepository
        .setCurrentVersion(currentMasterVersion: currentMasterVersion);
    if (setCurrentMasterVersionResult is Failure) {
      final exception = setCurrentMasterVersionResult.exception;
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

    return const Result.success(null);
  }

  Future<Result<void>> _updateCardMaster({
    required InquiredMasterVersion inquiredVersion,
  }) async {
    final fetchResult = await _cardRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      final exception = (fetchResult as Failure).exception;
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
    final tmpManholeCards = (fetchResult as Success<ManholeCards>).value;

    final manholeCardList = await Future.wait(
      tmpManholeCards.map(
        (manholeCard) async {
          final contactsResult = await Future.wait(
            manholeCard.contacts.map(
              (manholeCardContact) async {
                return await _contactRepository.get(
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
      final exception = deleteResult.exception;
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

    final saveResult = await _cardRepository.saveMaster(
      manholeCards: manholeCards,
    );
    if (saveResult is Failure) {
      final exception = saveResult.exception;
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

    return const Result.success(null);
  }

  Future<Result<void>> _updateContactMaster({
    required InquiredMasterVersion inquiredVersion,
  }) async {
    final fetchResult = await _contactRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      final exception = (fetchResult as Failure).exception;
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
    final manholeCardContacts =
        (fetchResult as Success<ManholeCardContacts>).value;

    final deleteResult = await _contactRepository.deleteMaster();
    if (deleteResult is Failure) {
      final exception = deleteResult.exception;
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

    final saveResult = await _contactRepository.saveMaster(
      manholeCardContacts: manholeCardContacts,
    );
    if (saveResult is Failure) {
      final exception = saveResult.exception;
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

    return const Result.success(null);
  }

  Future<Result<void>> _updateImageMaster({
    required InquiredMasterVersion inquiredVersion,
  }) async {
    final fetchResult = await _imageRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      final exception = (fetchResult as Failure).exception;
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
    final tmpManholeCardImages =
        (fetchResult as Success<ManholeCardImages>).value;

    final fetchImageResult = await _imageRepository.fetchImage(
      manholeCardImages: tmpManholeCardImages,
    );
    if (fetchImageResult is Failure) {
      final exception = (fetchImageResult as Failure).exception;
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
    final manholeCardImages =
        (fetchImageResult as Success<ManholeCardImages>).value;

    final deleteResult = await _imageRepository.deleteMaster();
    if (deleteResult is Failure) {
      final exception = deleteResult.exception;
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

    final saveResult = await _imageRepository.saveMaster(
      manholeCardImages: manholeCardImages,
    );
    if (saveResult is Failure) {
      final exception = saveResult.exception;
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

    return const Result.success(null);
  }

  Future<Result<void>> _updatePrefectureMaster({
    required InquiredMasterVersion inquiredVersion,
  }) async {
    final fetchResult = await _prefectureRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      final exception = (fetchResult as Failure).exception;
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
    final manholeCardPrefectures =
        (fetchResult as Success<ManholeCardPrefectures>).value;

    final deleteResult = await _prefectureRepository.deleteMaster();
    if (deleteResult is Failure) {
      final exception = deleteResult.exception;
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

    final saveResult = await _prefectureRepository.saveMaster(
      manholeCardPrefectures: manholeCardPrefectures,
    );
    if (saveResult is Failure) {
      final exception = saveResult.exception;
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

    return const Result.success(null);
  }

  Future<Result<void>> _updateVolumeMaster({
    required InquiredMasterVersion inquiredVersion,
  }) async {
    final fetchResult = await _volumeRepository.fetchMaster(
      inquiredMasterVersion: inquiredVersion,
    );
    if (fetchResult is Failure) {
      final exception = (fetchResult as Failure).exception;
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
    final manholeCardVolumes =
        (fetchResult as Success<ManholeCardVolumes>).value;

    final deleteResult = await _volumeRepository.deleteMaster();
    if (deleteResult is Failure) {
      final exception = deleteResult.exception;
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

    final saveResult = await _volumeRepository.saveMaster(
      manholeCardVolumes: manholeCardVolumes,
    );
    if (saveResult is Failure) {
      final exception = saveResult.exception;
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

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('CheckMasterUpdateUseCase dispose');
  }
}
