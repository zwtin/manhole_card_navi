import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/search_condition_view_data_mapper.dart';
import '../router/navigation_service.dart';
import '../view_data/search_condition_view_data.dart';

final searchConditionViewModelProvider = AsyncNotifierProvider.autoDispose<
  SearchConditionViewModel,
  SearchConditionViewData
>(SearchConditionViewModel.new);

/// 検索条件画面の ViewModel。
///
/// 編集内容はドラフトとして保持し、「この条件で表示」で端末保存する。保存した条件は
/// SearchConditionUseCase の Stream を通じてマップ・リストの両画面へ反映される。
class SearchConditionViewModel
    extends AutoDisposeAsyncNotifier<SearchConditionViewData> {
  late final SearchConditionUseCase _searchConditionUseCase;
  late final CardUseCase _cardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final NavigationService _navigationService;

  /// 編集中のドラフト。適用するまで端末保存も他画面も変更しない。
  late SearchCondition _draft;

  late List<Volume> _volumes;

  @override
  Future<SearchConditionViewData> build() async {
    _searchConditionUseCase = ref.watch(searchConditionUseCaseProvider);
    _cardUseCase = ref.watch(cardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    _draft = await _searchConditionUseCase.watch().first;
    _volumes = await _loadVolumes();
    return _toViewData();
  }

  void selectAlreadyGetFilter(int index) {
    _updateDraft(
      (draft) => draft.copyWith(
        common: draft.common.copyWith(
          alreadyGetFilter:
              SearchConditionViewDataMapper.alreadyGetFilters[index],
        ),
      ),
    );
  }

  void selectCoordinateType(int index) {
    _updateDraft(
      (draft) => draft.copyWith(
        map: draft.map.copyWith(
          coordinateType: SearchConditionViewDataMapper.coordinateTypes[index],
        ),
      ),
    );
  }

  void toggleVolume(int index) {
    final volumeId = _volumes[index].id;
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
      (draft) =>
          draft.copyWith(common: draft.common.copyWith(volumeIds: volumeIds)),
    );
  }

  /// 弾の絞り込みをクリアする（未選択＝すべて表示）。
  void clearVolumes() {
    _updateDraft(
      (draft) =>
          draft.copyWith(common: draft.common.copyWith(volumeIds: const {})),
    );
  }

  void toggleDistributionState(int index) {
    final state = SearchConditionViewDataMapper.distributionStates[index];
    _updateDraft((draft) {
      final next = Set<DistributionState>.of(draft.common.distributionStates);
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
              SearchConditionViewDataMapper.distributionStates.toSet(),
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
    if (!state.hasValue) {
      return;
    }
    final normalized = _draft.normalized(allVolumeIds: _allVolumeIds);
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
      event: const AnalyticsEvent.screenView(
        screenName: 'search_condition_view',
      ),
    );
  }

  Set<String> get _allVolumeIds => _volumes.map((volume) => volume.id).toSet();

  void _updateDraft(SearchCondition Function(SearchCondition draft) update) {
    // 読み込みが終わるまでは、ドラフトも選択肢もまだない。
    if (!state.hasValue) {
      return;
    }
    _draft = update(_draft);
    state = AsyncData(_toViewData());
  }

  SearchConditionViewData _toViewData() {
    return SearchConditionViewDataMapper.toViewData(
      draft: _draft,
      volumes: _volumes,
    );
  }

  Future<List<Volume>> _loadVolumes() async {
    final result = await _cardUseCase.fetchAll();
    if (result is! Success<List<ManholeCard>>) {
      return const [];
    }
    return SearchConditionViewDataMapper.toVolumes(result.value);
  }
}
