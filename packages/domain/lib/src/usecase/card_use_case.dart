import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/manhole_card.dart';
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

  Future<Result<ManholeCard>> get({required String id}) {
    return _cardRepository.get(id: id);
  }

  void dispose() {
    _logger.d('CardUseCase dispose');
  }
}
