import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/mapper/search_condition_view_data_mapper.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/search_condition_view_data.dart';
import 'package:domain/domain.dart';

final searchConditionViewModelProvider = AsyncNotifierProvider.autoDispose<
  SearchConditionViewModel,
  SearchConditionViewData
>(SearchConditionViewModel.new);

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

  void selectAllVolumes() {
    final volumeIds = _allVolumeIds;
    _updateDraft(
      (draft) =>
          draft.copyWith(common: draft.common.copyWith(volumeIds: volumeIds)),
    );
  }

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

  void clearDistributionStates() {
    _updateDraft(
      (draft) => draft.copyWith(
        common: draft.common.copyWith(distributionStates: const {}),
      ),
    );
  }

  /// 座標の種類は絞り込みではなく、マップの表示の選択なので残す。
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
