import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/result.dart';
import '/domain/repository/already_get_card_repository.dart';
import '/domain/repository/card_repository.dart';
import '/infra/repository_impl/already_get_card_repository_impl.dart';
import '/infra/repository_impl/card_repository_impl.dart';

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

  Future<Result<void>> save({
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
    return _alreadyGetCardRepository.save(manholeCard: card);
  }

  Future<Result<void>> delete({
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
    return _alreadyGetCardRepository.delete(manholeCard: card);
  }

  void dispose() {
    _logger.d('AlreadyGetCardUseCase dispose');
  }
}
