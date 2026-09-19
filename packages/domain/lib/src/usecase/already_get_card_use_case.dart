import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/repository/already_get_card_repository.dart';

final alreadyGetCardUseCaseProvider =
    Provider<AlreadyGetCardUseCase>(
  (ref) {
    final alreadyGetCardUseCase = AlreadyGetCardUseCase(
      ref.watch(alreadyGetCardRepositoryProvider),
    );
    ref.onDispose(alreadyGetCardUseCase.dispose);
    return alreadyGetCardUseCase;
  },
);

class AlreadyGetCardUseCase {
  AlreadyGetCardUseCase(
    this._alreadyGetCardRepository,
  );

  final AlreadyGetCardRepository _alreadyGetCardRepository;

  final _logger = Logger();

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

  void dispose() {
    _logger.d('AlreadyGetCardUseCase dispose');
  }
}
