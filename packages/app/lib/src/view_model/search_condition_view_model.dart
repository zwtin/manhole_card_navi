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
  CardBrowsingSettingsUseCase get _settingsUseCase =>
      ref.read(cardBrowsingSettingsUseCaseProvider);
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);

  /// 編集中のドラフト。適用するまで端末保存も他画面も変更しない。
  late CardBrowsingSettings _draft;

  late List<Volume> _volumes;

  @override
  Future<SearchConditionViewData> build() async {
    final settingsUseCase = ref.watch(cardBrowsingSettingsUseCaseProvider);
    final cardUseCase = ref.watch(cardUseCaseProvider);

    _draft = await settingsUseCase.watch().first;
    _volumes = await _loadVolumes(cardUseCase);
    return _toViewData();
  }

  void selectAlreadyGetFilter(int index) {
    _updateDraft(
      (draft) => draft.copyWith(
        searchCondition: draft.searchCondition.copyWith(
          alreadyGetFilter:
              SearchConditionViewDataMapper.alreadyGetFilters[index],
        ),
      ),
    );
  }

  void selectCoordinateType(int index) {
    _updateDraft(
      (draft) => draft.copyWith(
        mapDisplaySettings: draft.mapDisplaySettings.copyWith(
          coordinateType: SearchConditionViewDataMapper.coordinateTypes[index],
        ),
      ),
    );
  }

  void selectPinSize(int index) {
    _updateDraft(
      (draft) => draft.copyWith(
        mapDisplaySettings: draft.mapDisplaySettings.copyWith(
          pinSize: SearchConditionViewDataMapper.pinSizes[index],
        ),
      ),
    );
  }

  void toggleVolume(int index) {
    final volumeId = _volumes[index].id;
    _updateDraft((draft) {
      final next = Set<String>.of(draft.searchCondition.volumeIds);
      if (!next.remove(volumeId)) {
        next.add(volumeId);
      }
      return draft.copyWith(
        searchCondition: draft.searchCondition.copyWith(volumeIds: next),
      );
    });
  }

  void selectAllVolumes() {
    final volumeIds = _allVolumeIds;
    _updateDraft(
      (draft) => draft.copyWith(
        searchCondition: draft.searchCondition.copyWith(volumeIds: volumeIds),
      ),
    );
  }

  void clearVolumes() {
    _updateDraft(
      (draft) => draft.copyWith(
        searchCondition: draft.searchCondition.copyWith(volumeIds: const {}),
      ),
    );
  }

  void toggleDistributionState(int index) {
    final state = SearchConditionViewDataMapper.distributionStates[index];
    _updateDraft((draft) {
      final next = Set<DistributionState>.of(
        draft.searchCondition.distributionStates,
      );
      if (!next.remove(state)) {
        next.add(state);
      }
      return draft.copyWith(
        searchCondition: draft.searchCondition.copyWith(
          distributionStates: next,
        ),
      );
    });
  }

  void selectAllDistributionStates() {
    _updateDraft(
      (draft) => draft.copyWith(
        searchCondition: draft.searchCondition.copyWith(
          distributionStates:
              SearchConditionViewDataMapper.distributionStates.toSet(),
        ),
      ),
    );
  }

  void clearDistributionStates() {
    _updateDraft(
      (draft) => draft.copyWith(
        searchCondition: draft.searchCondition.copyWith(
          distributionStates: const {},
        ),
      ),
    );
  }

  /// 座標の種類とピンの大きさは絞り込みではなく、マップの表示の選択なので残す。
  void clearAllFilters() {
    _updateDraft(
      (draft) => draft.copyWith(searchCondition: const SearchCondition()),
    );
  }

  Future<void> onApply() async {
    if (!state.hasValue) {
      return;
    }
    final result = await _settingsUseCase.save(settings: _draft);
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

  void _updateDraft(
    CardBrowsingSettings Function(CardBrowsingSettings draft) update,
  ) {
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

  Future<List<Volume>> _loadVolumes(CardUseCase cardUseCase) async {
    final result = await cardUseCase.fetchAll();
    if (result is! Success<List<ManholeCard>>) {
      return const [];
    }
    return SearchConditionViewDataMapper.toVolumes(result.value);
  }
}
