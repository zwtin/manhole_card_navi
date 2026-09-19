import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/repository/already_get_card_repository.dart';

final alreadyGetCardUseCaseProvider =
    Provider<AlreadyGetCardUseCase>(
  (ref) => AlreadyGetCardUseCase(
    ref.watch(alreadyGetCardRepositoryProvider),
  ),
);

class AlreadyGetCardUseCase {
  AlreadyGetCardUseCase(
    this._alreadyGetCardRepository,
  );

  final AlreadyGetCardRepository _alreadyGetCardRepository;

  Stream<Set<String>> watch() {
    return _alreadyGetCardRepository.watch();
  }

  Future<Result<void>> save({
    required String id,
  }) {
    return _alreadyGetCardRepository.save(cardId: id);
  }

  Future<Result<void>> delete({
    required String id,
  }) {
    return _alreadyGetCardRepository.delete(cardId: id);
  }
}
