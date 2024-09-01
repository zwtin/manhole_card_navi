import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/infra/repository_impl/card_repository_impl.dart';
import '/use_case/dto/card_dto.dart';
import '/use_case/dto/contact_dto.dart';

final cardUseCaseProvider = Provider.autoDispose<CardUseCase>(
  (ref) {
    final cardUseCase = CardUseCase(
      ref.watch(cardRepositoryProvider),
    );
    ref.onDispose(cardUseCase.dispose);
    return cardUseCase;
  },
);

class CardUseCase {
  CardUseCase(
    this._cardRepository,
  );

  final CardRepository _cardRepository;
  final _logger = Logger();

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

    return Result.success(
      CardDTO(
        id: card.id,
        name: card.name,
        colorImageUrl: card.image.colorOriginal,
        grayImageUrl: card.image.grayOriginal,
        latitude: card.latitude,
        longitude: card.longitude,
        prefectureId: card.prefecture.id,
        prefectureName: card.prefecture.name,
        volumeId: card.volume.id,
        volumeName: card.volume.name,
        publicationDate: card.publicationDate,
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
