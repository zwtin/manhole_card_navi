import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/already_get_card_repository.dart';
import '../repository/card_repository.dart';

final alreadyGetCardUseCaseProvider =
    Provider.autoDispose<AlreadyGetCardUseCase>(
  (ref) {
    final alreadyGetCardUseCase = AlreadyGetCardUseCase(
      ref.watch(alreadyGetCardRepositoryProvider),
      ref.watch(cardRepositoryProvider),
    );
    ref.onDispose(alreadyGetCardUseCase.dispose);
    return alreadyGetCardUseCase;
  },
);

class AlreadyGetCardUseCase {
  AlreadyGetCardUseCase(
    this._alreadyGetCardRepository,
    this._cardRepository,
  );

  final AlreadyGetCardRepository _alreadyGetCardRepository;
  final CardRepository _cardRepository;

  final _logger = Logger();

  /// 取得済みカードの ID。
  Future<Result<Set<String>>> get() {
    return _alreadyGetCardRepository.get();
  }

  /// 取得済みカードが変わるたびに流れる。購読を始めたときにも今の値が流れる。
  Stream<Set<String>> getStream() {
    return _alreadyGetCardRepository.getStream();
  }

  Future<Result<void>> save({
    required String id,
  }) async {
    switch (await _cardRepository.get(id: id)) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        return _alreadyGetCardRepository.save(manholeCard: value);
    }
  }

  Future<Result<void>> delete({
    required String id,
  }) async {
    switch (await _cardRepository.get(id: id)) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        return _alreadyGetCardRepository.delete(manholeCard: value);
    }
  }

  void dispose() {
    _logger.d('AlreadyGetCardUseCase dispose');
  }
}
