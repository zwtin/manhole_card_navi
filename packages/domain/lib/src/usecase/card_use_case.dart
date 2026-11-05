import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/manhole_card.dart';
import 'package:domain/src/entity/search_condition.dart';
import 'package:domain/src/repository/card_repository.dart';

final cardUseCaseProvider = Provider<CardUseCase>(
  (ref) => CardUseCase(ref.watch(cardRepositoryProvider)),
);

class CardUseCase {
  CardUseCase(this._cardRepository);

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

  /// 画面が読み込み済みのカードと取得済みを渡す。読み直さないのは、画面が出して
  /// いる取得済みの数・ピンの見た目と、絞り込みに使う取得済みを食い違わせないため。
  List<ManholeCard> filter({
    required SearchCondition searchCondition,
    required List<ManholeCard> cards,
    required Set<String> alreadyGetCardIds,
  }) {
    final common = searchCondition.common;
    return [
      for (final card in cards)
        if (_matchesVolume(common, card) &&
            _matchesDistributionState(common, card) &&
            _matchesAlreadyGet(
              common,
              alreadyGet: alreadyGetCardIds.contains(card.id),
            ))
          card,
    ];
  }

  bool _matchesVolume(CommonSearchCondition common, ManholeCard card) {
    return common.volumeIds.isEmpty ||
        common.volumeIds.contains(card.volume.id);
  }

  bool _matchesDistributionState(
    CommonSearchCondition common,
    ManholeCard card,
  ) {
    return common.distributionStates.isEmpty ||
        common.distributionStates.contains(card.distributionState);
  }

  bool _matchesAlreadyGet(
    CommonSearchCondition common, {
    required bool alreadyGet,
  }) {
    return switch (common.alreadyGetFilter) {
      AlreadyGetFilter.all => true,
      AlreadyGetFilter.alreadyGet => alreadyGet,
      AlreadyGetFilter.notAlreadyGet => !alreadyGet,
    };
  }
}
