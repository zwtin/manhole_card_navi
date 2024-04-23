import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/infra/repository_impl/card_repository_impl.dart';
import '/temporary_provider.dart';
import '/use_case/dto/card_dto.dart';
import '/use_case/dto/contact_dto.dart';
import '/use_case/dto/map_marker_dto.dart';

final cardUseCaseProvider = Provider.autoDispose<CardUseCase>(
  (ref) {
    final cardUseCase = CardUseCase(
      ref.watch(cardRepositoryProvider),
      ref.watch(directoryProvider),
    );
    ref.onDispose(cardUseCase.dispose);
    return cardUseCase;
  },
);

class CardUseCase {
  CardUseCase(
    this._cardRepository,
    this._directory,
  );

  final CardRepository _cardRepository;

  final _logger = Logger();
  final Directory _directory;

  Future<Result<CardDTO>> get({
    required String id,
  }) async {
    final result = await _cardRepository.get(id: id);
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
    final card = (result as Success<ManholeCard>).value;

    final appDirectory = _directory;
    final imageDirectory = Directory('${appDirectory.path}/images');

    final DistributionStateDTO distributionState;
    switch (card.distributionState) {
      case ManholeCardDistributionState.distributing:
        distributionState = DistributionStateDTO.distributing;
        break;
      case ManholeCardDistributionState.stopped:
        distributionState = DistributionStateDTO.stopped;
        break;
      case ManholeCardDistributionState.notClear:
        distributionState = DistributionStateDTO.notClear;
        break;
    }

    return Result.success(
      CardDTO(
        id: card.id,
        name: card.name,
        imagePath: card.image.name.isEmpty
            ? ''
            : '${imageDirectory.path}/${card.image.name}',
        latitude: card.latitude,
        longitude: card.longitude,
        prefectureId: card.prefecture.id,
        prefectureName: card.prefecture.name,
        volumeId: card.volume.id,
        volumeName: card.volume.name,
        publicationDate: card.publicationDate,
        distributionState: distributionState,
        distributionLinkText: card.distributionLinkText,
        distributionLinkUrl: card.distributionLinkUrl,
        distributionText: card.distributionText,
        distributionOther: card.distributionOther,
        contacts: card.contacts.map((contact) {
          return ContactDTO(
            id: contact.id,
            name: contact.name,
            nameUrl: contact.nameUrl,
            address: contact.address,
            phoneNumber: contact.phoneNumber,
            latitude: contact.latitude,
            longitude: contact.longitude,
            other: contact.other,
            time: contact.time,
            timeOther: contact.timeOther,
          );
        }).toList(),
      ),
    );
  }

  void dispose() {
    _logger.d('CardUseCase dispose');
  }
}
