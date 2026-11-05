import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/distribution_state.dart';
import 'package:domain/src/entity/manhole_card.dart';
import 'package:domain/src/entity/search_condition.dart';
import 'package:domain/src/repository/card_repository.dart';
import 'package:domain/src/repository/search_condition_repository.dart';

final searchConditionUseCaseProvider = Provider<SearchConditionUseCase>(
  (ref) => SearchConditionUseCase(
    ref.watch(cardRepositoryProvider),
    ref.watch(searchConditionRepositoryProvider),
  ),
);

class SearchConditionUseCase {
  SearchConditionUseCase(this._cardRepository, this._searchConditionRepository);

  final CardRepository _cardRepository;
  final SearchConditionRepository _searchConditionRepository;

  Stream<SearchCondition> watch() {
    return _searchConditionRepository.watch();
  }

  /// すべて選んだ項目は、空（絞り込まない）にして保存する。全弾を選んで保存した
  /// 条件でも、後から出た新弾を対象に含め、絞り込みの数にも数えないため。
  ///
  /// 全弾かどうかは、保存する時点の端末のマスターで判断する。
  Future<Result<void>> save({required SearchCondition searchCondition}) async {
    final List<ManholeCard> cards;
    switch (await _cardRepository.fetchAll()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        cards = value;
    }

    final common = searchCondition.common;
    // 弾の ID が空のカードは検索画面の弾の選択肢に出ないので、全弾にも含めない。
    final allVolumeIds = {
      for (final card in cards)
        if (card.volume.id.isNotEmpty) card.volume.id,
    };
    var volumeIds = common.volumeIds;
    if (allVolumeIds.isNotEmpty &&
        volumeIds.length == allVolumeIds.length &&
        volumeIds.containsAll(allVolumeIds)) {
      volumeIds = const {};
    }
    var distributionStates = common.distributionStates;
    if (distributionStates.containsAll(DistributionState.values)) {
      distributionStates = const {};
    }

    return _searchConditionRepository.save(
      searchCondition: searchCondition.copyWith(
        common: common.copyWith(
          volumeIds: volumeIds,
          distributionStates: distributionStates,
        ),
      ),
    );
  }
}
