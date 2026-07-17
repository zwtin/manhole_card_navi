import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/mapper/list_prefectures_view_data_mapper.dart';
import '/app/provider/alert_provider.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view/detail_view.dart';
import '/app/view/search_condition_view.dart';
import '/app/view_data/list_prefectures_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/domain/entity/result.dart';
import '/domain/entity/search_condition.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/infra/query_service_impl/list_cards_query_service_impl.dart';
import '/infra/query_service_impl/search_condition_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/list_card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/query_service/list_cards_query_service.dart';
import '/use_case/query_service/search_condition_query_service.dart';
import '/use_case/use_case/analytics_use_case.dart';

final manholeCardListViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<ManholeCardListViewModel, Key?>(
  (ref, key) {
    return ManholeCardListViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
      ref.watch(analyticsUseCaseProvider),
      ref.watch(listCardsQueryServiceProvider),
      ref.watch(searchConditionQueryServiceProvider),
    );
  },
);

class ManholeCardListViewModel extends ChangeNotifier {
  ManholeCardListViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._analyticsUseCase,
    this._listCardsQueryService,
    this._searchConditionQueryService,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;

  final AnalyticsUseCase _analyticsUseCase;
  final ListCardsQueryService _listCardsQueryService;
  final SearchConditionQueryService _searchConditionQueryService;

  ListPrefecturesViewData prefecturesViewData =
      const ListPrefecturesViewData(list: []);
  final List<ListCardDTO> _listCardDTOList = [];
  final List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];
  SearchCondition _searchCondition = SearchCondition.initial();
  StreamSubscription<List<AlreadyGetCardDTO>>? _alreadyGetCardStreamSubscription;
  StreamSubscription<SearchCondition>? _searchConditionStreamSubscription;

  String get navigationTitle {
    final totalCount = _listCardDTOList.length;
    final alreadyGetCount = _alreadyGetCardDTOList.length;
    return 'マンホールカード　$alreadyGetCount/$totalCount';
  }

  /// 有効な絞り込みの数。検索ボタンのバッジ表示に使う。
  int get activeFilterCount => _searchCondition.activeFilterCount;

  Future<void> onLoad() async {
    _ref.read(tabKeyStorageProvider).setTabKey(1, _key);
    await onCameBack();
    await _fetchCards();
    await _loadSearchCondition();
    await _listenAlreadyGetCard();
    await _listenSearchCondition();
  }

  Future<void> onTap(String cardId) async {
    await _transitionToDetailView(cardId);
  }

  /// 検索条件画面へ遷移する。
  Future<void> onTapSearchCondition() async {
    await _ref.read(routerProvider(_key).notifier).present(
          nextWidget: SearchConditionView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> onExpandedChanged(
    bool initiallyExpanded,
    String prefectureId,
  ) async {
    prefecturesViewData = prefecturesViewData.onExpandedChanged(
      initiallyExpanded,
      prefectureId,
    );
    notifyListeners();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'manhole_card_list_view',
        'active_filter_count': activeFilterCount,
      },
    );
  }

  Future<void> onCameBack() async {
    final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
    final selectedIndex = _ref
        .read(bottomTabViewModelProvider(bottomTabKey).notifier)
        .selectedIndex;
    _ref.read(tabKeyStorageProvider).setTabKey(selectedIndex, _key);
    _ref.read(pvSendProvider.notifier).send();
  }

  Future<void> _fetchCards() async {
    final result = await _listCardsQueryService.fetch();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dto = (result as Success<List<ListCardDTO>>).value;
    _listCardDTOList.clear();
    _listCardDTOList.addAll(dto);
  }

  Future<void> _loadSearchCondition() async {
    final result = await _searchConditionQueryService.get();
    if (result is Success<SearchCondition>) {
      _searchCondition = result.value;
    }
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardStreamSubscription =
        _alreadyGetCardQueryService.getStream().listen((dtoList) async {
      _alreadyGetCardDTOList
        ..clear()
        ..addAll(dtoList);
      await _rebuild();
    });
  }

  Future<void> _listenSearchCondition() async {
    _searchConditionStreamSubscription =
        _searchConditionQueryService.getStream().listen((condition) async {
      _searchCondition = condition;
      await _rebuild();
    });
  }

  Future<void> _rebuild() async {
    prefecturesViewData = await ListPrefecturesViewDataMapper.convertToViewData(
      listCardDTOList: _listCardDTOList,
      alreadyGetCardDTOList: _alreadyGetCardDTOList,
      searchCondition: _searchCondition.common,
    );
    notifyListeners();
  }

  Future<void> _transitionToDetailView(String cardId) async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: DetailView(
            key: UniqueKey(),
            cardId: cardId,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('ManholeCardListViewModel dispose');
    _alreadyGetCardStreamSubscription?.cancel();
    _searchConditionStreamSubscription?.cancel();
  }
}
