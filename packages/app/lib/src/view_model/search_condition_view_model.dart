import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/navigation_service.dart';
import '../view_data/search_condition_view_data.dart';

final searchConditionViewModelProvider = AsyncNotifierProvider.autoDispose<
    SearchConditionViewModel, SearchConditionViewData>(
  SearchConditionViewModel.new,
);

/// 検索条件画面の ViewModel。
///
/// 編集内容はドラフトとして保持し、「この条件で表示」で端末保存する。保存した条件は
/// SearchConditionUseCase の Stream を通じてマップ・リストの両画面へ反映される。
class SearchConditionViewModel
    extends AutoDisposeAsyncNotifier<SearchConditionViewData> {
  /// 配布状態の選択肢。表示順は固定。
  static const List<DistributionStateOption> distributionStateOptions = [
    (state: DistributionState.distributing, name: '配布中'),
    (state: DistributionState.stopped, name: '配布停止'),
    (state: DistributionState.notClear, name: '不明'),
  ];

  late final SearchConditionUseCase _searchConditionUseCase;
  late final CardUseCase _cardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final NavigationService _navigationService;

  @override
  Future<SearchConditionViewData> build() async {
    _searchConditionUseCase = ref.watch(searchConditionUseCaseProvider);
    _cardUseCase = ref.watch(cardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    return SearchConditionViewData(
      draft: await _searchConditionUseCase.watch().first,
      volumeOptions: await _loadVolumeOptions(),
    );
  }

  void setAlreadyGetFilter(AlreadyGetFilter value) {
    _updateDraft(
      (draft) => draft.copyWith(
        common: draft.common.copyWith(alreadyGetFilter: value),
      ),
    );
  }

  void setCoordinateType(MapCoordinateType value) {
    _updateDraft(
      (draft) => draft.copyWith(
        map: draft.map.copyWith(coordinateType: value),
      ),
    );
  }

  void toggleVolume(String volumeId) {
    _updateDraft((draft) {
      final next = Set<String>.of(draft.common.volumeIds);
      if (!next.remove(volumeId)) {
        next.add(volumeId);
      }
      return draft.copyWith(common: draft.common.copyWith(volumeIds: next));
    });
  }

  /// すべての弾を選択する（結果は「すべて表示」と同じ）。
  void selectAllVolumes() {
    final volumeIds = _allVolumeIds;
    _updateDraft(
      (draft) => draft.copyWith(
        common: draft.common.copyWith(volumeIds: volumeIds),
      ),
    );
  }

  /// 弾の絞り込みをクリアする（未選択＝すべて表示）。
  void clearVolumes() {
    _updateDraft(
      (draft) => draft.copyWith(
        common: draft.common.copyWith(volumeIds: const {}),
      ),
    );
  }

  void toggleDistributionState(DistributionState state) {
    _updateDraft((draft) {
      final next = Set<DistributionState>.of(
        draft.common.distributionStates,
      );
      if (!next.remove(state)) {
        next.add(state);
      }
      return draft.copyWith(
        common: draft.common.copyWith(distributionStates: next),
      );
    });
  }

  /// すべての配布状態を選択する（結果は「すべて表示」と同じ）。
  void selectAllDistributionStates() {
    _updateDraft(
      (draft) => draft.copyWith(
        common: draft.common.copyWith(
          distributionStates:
              distributionStateOptions.map((option) => option.state).toSet(),
        ),
      ),
    );
  }

  /// 配布状態の絞り込みをクリアする（未選択＝すべて表示）。
  void clearDistributionStates() {
    _updateDraft(
      (draft) => draft.copyWith(
        common: draft.common.copyWith(distributionStates: const {}),
      ),
    );
  }

  /// 横断的な絞り込み（取得状態・弾数・配布状態）をすべてクリアする。
  /// マップ座標種別は表示オプションなので変更しない。
  void clearAllFilters() {
    _updateDraft(
      (draft) => draft.copyWith(common: const CommonSearchCondition()),
    );
  }

  Future<void> onApply() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final normalized = current.draft.normalized(allVolumeIds: _allVolumeIds);
    final result = await _searchConditionUseCase.save(
      searchCondition: normalized,
    );
    if (result case Failure(:final exception)) {
      await _navigationService.showFailure(
        title: '検索条件を保存できませんでした',
        exception: exception,
      );
      return;
    }
    _navigationService.pop();
  }

  void onClose() {
    _navigationService.pop();
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'search_condition_view',
      },
    );
  }

  Set<String> get _allVolumeIds =>
      (state.valueOrNull?.volumeOptions ?? const <VolumeOption>[])
          .map((option) => option.id)
          .toSet();

  void _updateDraft(SearchCondition Function(SearchCondition draft) update) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(draft: update(current.draft)));
  }

  Future<List<VolumeOption>> _loadVolumeOptions() async {
    final result = await _cardUseCase.fetchAll();
    if (result is! Success<List<ManholeCard>>) {
      return const [];
    }
    final byVolume = <String, String>{};
    for (final card in result.value) {
      if (card.volume.id.isEmpty) {
        continue;
      }
      byVolume.putIfAbsent(card.volume.id, () => card.volume.name);
    }
    final entries = byVolume.entries.toList()
      // volumeId は「弾番号 - 1」を 4 桁ゼロ埋めした値（第01弾=0000 … 第18弾=0017）
      // なので、ID の降順に並べれば発行日データの揺れに依存せず新しい弾から表示できる。
      // （発行日ソートでは 17弾/18弾 の発行日が同日・逆転していると順序が狂っていた）
      ..sort((a, b) => b.key.compareTo(a.key));
    return entries.map((entry) => (id: entry.key, name: entry.value)).toList();
  }
}
