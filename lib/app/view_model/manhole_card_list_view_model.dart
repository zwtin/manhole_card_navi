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
import '/app/view_data/list_prefectures_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/infra/query_service_impl/list_cards_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/list_card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/query_service/list_cards_query_service.dart';
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
    );
  },
);

enum ListState {
  all,
  alreadyGet,
}

class ManholeCardListViewModel extends ChangeNotifier {
  ManholeCardListViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._analyticsUseCase,
    this._listCardsQueryService,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;

  final AnalyticsUseCase _analyticsUseCase;
  final ListCardsQueryService _listCardsQueryService;

  ListPrefecturesViewData prefecturesViewData =
      const ListPrefecturesViewData(list: []);
  final List<ListCardDTO> _listCardDTOList = [];
  final List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];
  late StreamSubscription<List<AlreadyGetCardDTO>>
      _alreadyGetCardStreamSubscription;
  String get navigationTitle {
    switch (listState) {
      case ListState.all:
        return 'すべて';
      case ListState.alreadyGet:
        return '取得済みのみ';
      default:
        return '';
    }
  }

  ListState listState = ListState.all;

  Future<void> onLoad() async {
    _ref.read(tabKeyStorageProvider).setTabKey(1, _key);
    await onCameBack();
    await _fetchCards();
    await _listenAlreadyGetCard();
  }

  Future<void> onTap(String cardId) async {
    await _transitionToDetailView(cardId);
  }

  Future<void> onChangeMapState(ListState newListState) async {
    listState = newListState;
    prefecturesViewData = await ListPrefecturesViewDataMapper.convertToViewData(
      listCardDTOList: _listCardDTOList,
      getCardDTOList: _alreadyGetCardDTOList,
      listState: listState,
      originalGetCardDTOList: _alreadyGetCardDTOList,
      originalViewData: prefecturesViewData,
    );
    notifyListeners();
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
        'list_state': listState.name,
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

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardStreamSubscription =
        _alreadyGetCardQueryService.getStream().listen((dtoList) async {
      prefecturesViewData =
          await ListPrefecturesViewDataMapper.convertToViewData(
        listCardDTOList: _listCardDTOList,
        getCardDTOList: dtoList,
        listState: listState,
        originalGetCardDTOList: _alreadyGetCardDTOList,
        originalViewData: prefecturesViewData,
      );
      notifyListeners();

      _alreadyGetCardDTOList.clear();
      _alreadyGetCardDTOList.addAll(dtoList);
    });
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
    _alreadyGetCardStreamSubscription.cancel();
  }
}
