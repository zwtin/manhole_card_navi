import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/already_get_card_repository.dart';

final alreadyGetCardUseCaseProvider =
    Provider.autoDispose<AlreadyGetCardUseCase>(
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

  /// 取得済みカードの ID。購読を始めたときに今の値が流れ、変わるたびに流れる。
  Stream<Set<String>> watch() {
    return _alreadyGetCardRepository.watch();
  }

  /// [id] のカードを取得済みにする。
  Future<Result<void>> save({
    required String id,
  }) {
    return _alreadyGetCardRepository.save(cardId: id);
  }

  /// [id] のカードを未取得に戻す。
  Future<Result<void>> delete({
    required String id,
  }) {
    return _alreadyGetCardRepository.delete(cardId: id);
  }

  void dispose() {
    _logger.d('AlreadyGetCardUseCase dispose');
  }
}
