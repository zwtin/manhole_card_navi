import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/manhole_card.dart';
import 'package:domain/src/repository/card_repository.dart';

final cardUseCaseProvider = Provider<CardUseCase>(
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

  Future<Result<List<ManholeCard>>> fetchAll() {
    return _cardRepository.fetchAll();
  }

  Future<Result<Uint8List>> fetchImage({
    required String cardId,
    int? maxWidth,
  }) {
    return _cardRepository.fetchImage(cardId: cardId, maxWidth: maxWidth);
  }

  void dispose() {
    _logger.d('CardUseCase dispose');
  }
}
