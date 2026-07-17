import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/router_provider.dart';
import '/domain/entity/display_filter.dart';
import '/domain/entity/manhole_card_distribution_state.dart';
import '/domain/entity/map_coordinate_type.dart';
import '/domain/entity/result.dart';
import '/domain/entity/search_condition.dart';
import '/infra/query_service_impl/list_cards_query_service_impl.dart';
import '/infra/query_service_impl/search_condition_query_service_impl.dart';
import '/use_case/dto/list_card_dto.dart';
import '/use_case/query_service/list_cards_query_service.dart';
import '/use_case/query_service/search_condition_query_service.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/search_condition_use_case.dart';

/// 弾の選択肢（ID と表示名）。
typedef VolumeOption = ({String id, String name});

/// 配布状態の選択肢（値と表示名）。
typedef DistributionStateOption = ({
  ManholeCardDistributionState state,
  String name,
});

final searchConditionViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<SearchConditionViewModel, Key?>(
  (ref, key) {
    return SearchConditionViewModel(
      key,
      ref,
      ref.watch(searchConditionQueryServiceProvider),
      ref.watch(searchConditionUseCaseProvider),
      ref.watch(listCardsQueryServiceProvider),
      ref.watch(analyticsUseCaseProvider),
    );
  },
);

class SearchConditionViewModel extends ChangeNotifier {
  SearchConditionViewModel(
    this._key,
    this._ref,
    this._searchConditionQueryService,
    this._searchConditionUseCase,
    this._listCardsQueryService,
    this._analyticsUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final SearchConditionQueryService _searchConditionQueryService;
  final SearchConditionUseCase _searchConditionUseCase;
  final ListCardsQueryService _listCardsQueryService;
  final AnalyticsUseCase _analyticsUseCase;

  /// 編集中のドラフト。適用するまで端末保存も他画面も変更しない。
  SearchCondition _draft = SearchCondition.initial();

  List<VolumeOption> _volumeOptions = [];

  /// 配布状態の選択肢。表示順は固定。
  static const List<DistributionStateOption> distributionStateOptions = [
    (state: ManholeCardDistributionState.distributing(), name: '配布中'),
    (state: ManholeCardDistributionState.stopped(), name: '配布停止'),
    (state: ManholeCardDistributionState.notClear(), name: '不明'),
  ];

  DisplayFilter get displayFilter => _draft.common.displayFilter;
  MapCoordinateType get coordinateType => _draft.map.coordinateType;
  List<VolumeOption> get volumeOptions => _volumeOptions;

  /// 弾が未選択（＝すべての弾を表示）か。
  bool get isVolumeFilterEmpty => _draft.common.volumeIds.isEmpty;

  /// 配布状態が未選択（＝すべての配布状態を表示）か。
  bool get isDistributionStateFilterEmpty =>
      _draft.common.distributionStates.isEmpty;

  bool isVolumeSelected(String volumeId) =>
      _draft.common.volumeIds.contains(volumeId);

  bool isDistributionStateSelected(ManholeCardDistributionState state) =>
      _draft.common.distributionStates.contains(state);

  Future<void> onLoad() async {
    final result = await _searchConditionQueryService.get();
    if (result is Success<SearchCondition>) {
      _draft = result.value;
    }
    await _loadVolumeOptions();
    notifyListeners();
  }

  void setDisplayFilter(DisplayFilter value) {
    _draft = _draft.copyWith(
      common: _draft.common.copyWith(displayFilter: value),
    );
    notifyListeners();
  }

  void setCoordinateType(MapCoordinateType value) {
    _draft = _draft.copyWith(
      map: _draft.map.copyWith(coordinateType: value),
    );
    notifyListeners();
  }

  void toggleVolume(String volumeId) {
    final next = Set<String>.of(_draft.common.volumeIds);
    if (next.contains(volumeId)) {
      next.remove(volumeId);
    } else {
      next.add(volumeId);
    }
    _draft = _draft.copyWith(
      common: _draft.common.copyWith(volumeIds: next),
    );
    notifyListeners();
  }

  /// すべての弾を選択する（結果は「すべて表示」と同じ）。
  void selectAllVolumes() {
    _draft = _draft.copyWith(
      common: _draft.common.copyWith(
        volumeIds: _volumeOptions.map((option) => option.id).toSet(),
      ),
    );
    notifyListeners();
  }

  /// 弾の絞り込みをクリアする（未選択＝すべて表示）。
  void clearVolumes() {
    _draft = _draft.copyWith(
      common: _draft.common.copyWith(volumeIds: const {}),
    );
    notifyListeners();
  }

  void toggleDistributionState(ManholeCardDistributionState state) {
    final next = Set<ManholeCardDistributionState>.of(
      _draft.common.distributionStates,
    );
    if (next.contains(state)) {
      next.remove(state);
    } else {
      next.add(state);
    }
    _draft = _draft.copyWith(
      common: _draft.common.copyWith(distributionStates: next),
    );
    notifyListeners();
  }

  /// すべての配布状態を選択する（結果は「すべて表示」と同じ）。
  void selectAllDistributionStates() {
    _draft = _draft.copyWith(
      common: _draft.common.copyWith(
        distributionStates: distributionStateOptions
            .map((option) => option.state)
            .toSet(),
      ),
    );
    notifyListeners();
  }

  /// 配布状態の絞り込みをクリアする（未選択＝すべて表示）。
  void clearDistributionStates() {
    _draft = _draft.copyWith(
      common: _draft.common.copyWith(distributionStates: const {}),
    );
    notifyListeners();
  }

  /// 横断的な絞り込み（取得状態・弾数・配布状態）をすべてクリアする。
  /// マップ座標種別は表示オプションなので変更しない。
  void clearAllFilters() {
    _draft = _draft.copyWith(
      common: const CommonSearchCondition(),
    );
    notifyListeners();
  }

  Future<void> onApply() async {
    final normalized = _draft.normalized(
      allVolumeIds: _volumeOptions.map((option) => option.id).toSet(),
    );
    await _searchConditionUseCase.save(searchCondition: normalized);
    await _ref.read(routerProvider(_key).notifier).pop();
  }

  Future<void> onClose() async {
    await _ref.read(routerProvider(_key).notifier).pop();
  }

  Future<void> _loadVolumeOptions() async {
    final result = await _listCardsQueryService.fetch();
    if (result is! Success<List<ListCardDTO>>) {
      return;
    }
    final byVolume = <String, ({String name, DateTime latest})>{};
    for (final dto in result.value) {
      if (dto.volumeId.isEmpty) {
        continue;
      }
      final existing = byVolume[dto.volumeId];
      if (existing == null || dto.publicationDate.isAfter(existing.latest)) {
        byVolume[dto.volumeId] = (
          name: dto.volumeName,
          latest: dto.publicationDate,
        );
      }
    }
    final entries = byVolume.entries.toList()
      // 新しい弾を上に表示する。
      ..sort((a, b) => b.value.latest.compareTo(a.value.latest));
    _volumeOptions =
        entries.map((entry) => (id: entry.key, name: entry.value.name)).toList();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'search_condition_view',
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('SearchConditionViewModel dispose');
  }
}
