import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/infra/repository_impl/card_repository_impl.dart';
import '/use_case/dto/card_dto.dart';

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
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'カード情報の取得に失敗しました',
        ),
      );
    }
    final card = (result as Success<ManholeCard>).value;
    return Result.success(
      CardDTO(
        id: card.id,
        name: card.name,
        imagePath: '',
        latitude: card.latitude,
        longitude: card.longitude,
      ),
    );
  }

  void dispose() {
    _logger.d('CardUseCase dispose');
  }
}
