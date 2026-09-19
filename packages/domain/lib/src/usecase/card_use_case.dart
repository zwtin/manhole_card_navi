import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/manhole_card.dart';
import '../repository/card_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
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

  /// 端末に取り込んだすべてのカード。
  Future<Result<List<ManholeCard>>> fetchAll() {
    return _cardRepository.fetchAll();
  }

  void dispose() {
    _logger.d('CardUseCase dispose');
  }
}
