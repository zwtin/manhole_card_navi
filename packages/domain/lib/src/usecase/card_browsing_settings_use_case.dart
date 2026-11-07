import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/card_browsing_settings.dart';
import 'package:domain/src/entity/distribution_state.dart';
import 'package:domain/src/entity/manhole_card.dart';
import 'package:domain/src/repository/card_browsing_settings_repository.dart';
import 'package:domain/src/repository/card_repository.dart';

final cardBrowsingSettingsUseCaseProvider =
    Provider<CardBrowsingSettingsUseCase>(
      (ref) => CardBrowsingSettingsUseCase(
        ref.watch(cardRepositoryProvider),
        ref.watch(cardBrowsingSettingsRepositoryProvider),
      ),
    );

class CardBrowsingSettingsUseCase {
  CardBrowsingSettingsUseCase(
    this._cardRepository,
    this._cardBrowsingSettingsRepository,
  );

  final CardRepository _cardRepository;
  final CardBrowsingSettingsRepository _cardBrowsingSettingsRepository;

  Stream<CardBrowsingSettings> watch() {
    return _cardBrowsingSettingsRepository.watch();
  }

  /// 検索条件のうち、すべて選んだ項目は、空（絞り込まない）にして保存する。全弾を
  /// 選んで保存した条件でも、後から出た新弾を対象に含め、絞り込みの数にも数えない
  /// ため。
  ///
  /// 全弾かどうかは、保存する時点の端末のマスターで判断する。
  Future<Result<void>> save({required CardBrowsingSettings settings}) async {
    final List<ManholeCard> cards;
    switch (await _cardRepository.fetchAll()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        cards = value;
    }

    final searchCondition = settings.searchCondition;
    // 弾の ID が空のカードは検索画面の弾の選択肢に出ないので、全弾にも含めない。
    final allVolumeIds = {
      for (final card in cards)
        if (card.volume.id.isNotEmpty) card.volume.id,
    };
    var volumeIds = searchCondition.volumeIds;
    if (allVolumeIds.isNotEmpty &&
        volumeIds.length == allVolumeIds.length &&
        volumeIds.containsAll(allVolumeIds)) {
      volumeIds = const {};
    }
    var distributionStates = searchCondition.distributionStates;
    if (distributionStates.containsAll(DistributionState.values)) {
      distributionStates = const {};
    }

    return _cardBrowsingSettingsRepository.save(
      settings: settings.copyWith(
        searchCondition: searchCondition.copyWith(
          volumeIds: volumeIds,
          distributionStates: distributionStates,
        ),
      ),
    );
  }
}
