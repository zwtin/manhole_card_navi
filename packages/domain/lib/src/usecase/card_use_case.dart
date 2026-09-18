import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/card_dto.dart';
import '../repository/card_repository.dart';

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
    switch (await _cardRepository.get(id: id)) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final card):
        return Result.success(
          CardDTO(
            id: card.id,
            name: card.name,
            imagePath: card.image,
            imageSubPath: card.imageSub,
            latitude: card.latitude,
            longitude: card.longitude,
            prefectureId: card.prefecture.id,
            prefectureName: card.prefecture.name,
            volumeId: card.volume.id,
            volumeName: card.volume.name,
            publicationDate: card.publicationDate,
            distributionPlaceHtml: card.distributionPlaceHtml,
            distributionTimeHtml: card.distributionTimeHtml,
            stockHtml: card.stockHtml,
          ),
        );
    }
  }

  void dispose() {
    _logger.d('CardUseCase dispose');
  }
}
