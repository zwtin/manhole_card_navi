import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/manhole_card.dart';
import 'package:domain/src/repository/card_repository.dart';

final cardUseCaseProvider = Provider<CardUseCase>(
  (ref) => CardUseCase(
    ref.watch(cardRepositoryProvider),
  ),
);

class CardUseCase {
  CardUseCase(
    this._cardRepository,
  );

  final CardRepository _cardRepository;

  Future<Result<ManholeCard>> get({required String id}) {
    return _cardRepository.get(id: id);
  }

  Future<Result<List<ManholeCard>>> fetchAll() {
    return _cardRepository.fetchAll();
  }

  Future<Result<Uint8List>> fetchImage({required String cardId}) {
    return _cardRepository.fetchImage(cardId: cardId);
  }
}
