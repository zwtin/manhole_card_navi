import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/list_prefectures_view_data_mapper.dart';
import '../router/navigation_service.dart';
import '../view_data/list_prefectures_view_data.dart';
import '../view_data/manhole_card_list_view_data.dart';

final manholeCardListViewModelProvider = AsyncNotifierProvider.autoDispose<
    ManholeCardListViewModel, ManholeCardListViewData>(
  ManholeCardListViewModel.new,
);

/// リストタブの ViewModel。
class ManholeCardListViewModel
    extends AutoDisposeAsyncNotifier<ManholeCardListViewData> {
  late final AlreadyGetCardUseCase _alreadyGetCardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final CardUseCase _cardUseCase;
  late final SearchConditionUseCase _searchConditionUseCase;
  late final NavigationService _navigationService;

  List<ManholeCard> _cards = [];
  Set<String> _alreadyGetCardIds = {};
  SearchCondition _searchCondition = SearchCondition.initial();

  /// 展開中の都道府県。取得状態や検索条件が変わって一覧を作り直しても開いたままにする。
  final Set<String> _expandedPrefectureIds = {};

  @override
  Future<ManholeCardListViewData> build() async {
    _alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _cardUseCase = ref.watch(cardUseCaseProvider);
    _searchConditionUseCase = ref.watch(searchConditionUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    switch (await _cardUseCase.fetchAll()) {
      case Success(:final value):
        _cards = value;
      case Failure(:final exception):
        unawaited(
          _navigationService.showFailure(
            title: 'カード一覧を取得できませんでした',
            exception: exception,
          ),
        );
    }
    final conditionResult = await _searchConditionUseCase.get();
    if (conditionResult is Success<SearchCondition>) {
      _searchCondition = conditionResult.value;
    }
    final alreadyGetResult = await _alreadyGetCardUseCase.get();
    if (alreadyGetResult is Success<Set<String>>) {
      _alreadyGetCardIds = alreadyGetResult.value;
    }

    final alreadyGetSubscription = _alreadyGetCardUseCase
        .getStream()
        .listen((cardIds) async {
      // 購読開始時にも現在値が流れてくるため、変わっていなければ作り直さない。
      if (setEquals(cardIds, _alreadyGetCardIds)) {
        return;
      }
      _alreadyGetCardIds = cardIds;
      state = AsyncData(await _buildViewData());
    });
    ref.onDispose(alreadyGetSubscription.cancel);

    final searchConditionSubscription = _searchConditionUseCase
        .getStream()
        .listen((condition) async {
      if (condition == _searchCondition) {
        return;
      }
      _searchCondition = condition;
      state = AsyncData(await _buildViewData());
    });
    ref.onDispose(searchConditionSubscription.cancel);

    return _buildViewData();
  }

  Future<void> onTap(String cardId) async {
    await _navigationService.pushCardDetail(cardId: cardId);
  }

  /// 検索条件画面へ遷移する。
  Future<void> onTapSearchCondition() async {
    await _navigationService.presentSearchCondition();
  }

  void onExpandedChanged(bool expanded, String prefectureId) {
    if (expanded) {
      _expandedPrefectureIds.add(prefectureId);
    } else {
      _expandedPrefectureIds.remove(prefectureId);
    }
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(
      current.copyWith(
        prefectures: current.prefectures.onExpandedChanged(
          expanded,
          prefectureId,
        ),
      ),
    );
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'manhole_card_list_view',
        'active_filter_count': _searchCondition.activeFilterCount,
      },
    );
  }

  Future<ManholeCardListViewData> _buildViewData() async {
    final prefectures = await ListPrefecturesViewDataMapper.convertToViewData(
      cards: _cards,
      alreadyGetCardIds: _alreadyGetCardIds,
      searchCondition: _searchCondition.common,
    );
    return ManholeCardListViewData(
      prefectures: ListPrefecturesViewData(
        list: prefectures.list
            .map(
              (prefecture) => prefecture.copyWith(
                initiallyExpanded: _expandedPrefectureIds.contains(
                  prefecture.id,
                ),
              ),
            )
            .toList(),
      ),
      totalCount: _cards.length,
      alreadyGetCount: _alreadyGetCardIds.length,
      activeFilterCount: _searchCondition.activeFilterCount,
    );
  }
}
