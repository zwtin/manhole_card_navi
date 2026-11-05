import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/mapper/list_prefectures_view_data_mapper.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/manhole_card_list_view_data.dart';
import 'package:domain/domain.dart';

final manholeCardListViewModelProvider = AsyncNotifierProvider.autoDispose<
  ManholeCardListViewModel,
  ManholeCardListViewData
>(ManholeCardListViewModel.new);

class ManholeCardListViewModel
    extends AutoDisposeAsyncNotifier<ManholeCardListViewData> {
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  CardUseCase get _cardUseCase => ref.read(cardUseCaseProvider);
  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);

  List<ManholeCard> _cards = [];
  Set<String> _alreadyGetCardIds = {};
  SearchCondition _searchCondition = SearchCondition.initial();

  /// 展開中の都道府県。取得状態や検索条件が変わって一覧を作り直しても開いたままにする。
  final Set<String> _expandedPrefectureIds = {};

  @override
  Future<ManholeCardListViewData> build() async {
    final alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    final cardUseCase = ref.watch(cardUseCaseProvider);
    final searchConditionUseCase = ref.watch(searchConditionUseCaseProvider);
    final navigationService = ref.watch(navigationServiceProvider);

    switch (await cardUseCase.fetchAll()) {
      case Success(:final value):
        _cards = value;
      case Failure(:final exception):
        unawaited(
          navigationService.showFailure(
            title: 'カード一覧を取得できませんでした',
            exception: exception,
          ),
        );
    }
    _searchCondition = await searchConditionUseCase.watch().first;
    _alreadyGetCardIds = await alreadyGetCardUseCase.watch().first;

    final alreadyGetSubscription = alreadyGetCardUseCase.watch().listen((
      cardIds,
    ) {
      // 購読開始時にも現在値が流れてくるため、変わっていなければ作り直さない。
      if (setEquals(cardIds, _alreadyGetCardIds)) {
        return;
      }
      _alreadyGetCardIds = cardIds;
      state = AsyncData(_buildViewData(cardUseCase));
    });
    ref.onDispose(alreadyGetSubscription.cancel);

    final searchConditionSubscription = searchConditionUseCase.watch().listen((
      condition,
    ) {
      if (condition == _searchCondition) {
        return;
      }
      _searchCondition = condition;
      state = AsyncData(_buildViewData(cardUseCase));
    });
    ref.onDispose(searchConditionSubscription.cancel);

    return _buildViewData(cardUseCase);
  }

  Future<void> onTap(String cardId) async {
    await _navigationService.pushCardDetail(cardId: cardId);
  }

  Future<void> onTapSearchCondition() async {
    await _navigationService.presentSearchCondition();
  }

  void onExpandedChanged(bool expanded, String prefectureId) {
    if (expanded) {
      _expandedPrefectureIds.add(prefectureId);
    } else {
      _expandedPrefectureIds.remove(prefectureId);
    }
    if (!state.hasValue) {
      return;
    }
    // 一覧はスクロールで外れた行を作り直すので、開いた状態も ViewData に持たせる。
    state = AsyncData(_buildViewData(_cardUseCase));
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: AnalyticsEvent.screenView(
        screenName: 'manhole_card_list_view',
        parameters: {'active_filter_count': _searchCondition.activeFilterCount},
      ),
    );
  }

  ManholeCardListViewData _buildViewData(CardUseCase cardUseCase) {
    // 都道府県の分母は、取得済みで絞り込む前の枚数にする。
    final countCards = cardUseCase.filter(
      searchCondition: _searchCondition.copyWith(
        common: _searchCondition.common.copyWith(
          alreadyGetFilter: AlreadyGetFilter.all,
        ),
      ),
      cards: _cards,
      alreadyGetCardIds: _alreadyGetCardIds,
    );
    final visibleCards = cardUseCase.filter(
      searchCondition: _searchCondition,
      cards: countCards,
      alreadyGetCardIds: _alreadyGetCardIds,
    );
    return ManholeCardListViewData(
      prefectures: ListPrefecturesViewDataMapper.toViewData(
        countCards: countCards,
        visibleCards: visibleCards,
        alreadyGetCardIds: _alreadyGetCardIds,
        expandedPrefectureIds: _expandedPrefectureIds,
      ),
      totalCount: _cards.length,
      alreadyGetCount: _alreadyGetCardIds.length,
      activeFilterCount: _searchCondition.activeFilterCount,
    );
  }
}
