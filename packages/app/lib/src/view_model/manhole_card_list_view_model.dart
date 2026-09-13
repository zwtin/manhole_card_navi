import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/list_prefectures_view_data_mapper.dart';
import '../view_data/list_prefectures_view_data.dart';
import '../view_data/manhole_card_list_view_data.dart';

final manholeCardListViewModelProvider = AsyncNotifierProvider.autoDispose<
    ManholeCardListViewModel, ManholeCardListViewData>(
  ManholeCardListViewModel.new,
);

/// リストタブの ViewModel。
class ManholeCardListViewModel
    extends AutoDisposeAsyncNotifier<ManholeCardListViewData> {
  late final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  late final AnalyticsUseCase _analyticsUseCase;
  late final ListCardsQueryService _listCardsQueryService;
  late final SearchConditionQueryService _searchConditionQueryService;
  late final NavigationService _navigationService;

  List<ListCardDTO> _listCardDTOList = [];
  List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];
  SearchCondition _searchCondition = SearchCondition.initial();

  /// 展開中の都道府県。取得状態や検索条件が変わって一覧を作り直しても開いたままにする。
  final Set<String> _expandedPrefectureIds = {};

  @override
  Future<ManholeCardListViewData> build() async {
    _alreadyGetCardQueryService = ref.watch(alreadyGetCardQueryServiceProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _listCardsQueryService = ref.watch(listCardsQueryServiceProvider);
    _searchConditionQueryService = ref.watch(
      searchConditionQueryServiceProvider,
    );
    _navigationService = ref.watch(navigationServiceProvider);

    final cardsResult = await _listCardsQueryService.fetch();
    if (cardsResult is Success<List<ListCardDTO>>) {
      _listCardDTOList = cardsResult.value;
    } else {
      unawaited(
        _navigationService.showAlert(
          title: 'エラー',
          message: 'カード情報の取得に失敗しました',
        ),
      );
    }
    final conditionResult = await _searchConditionQueryService.get();
    if (conditionResult is Success<SearchCondition>) {
      _searchCondition = conditionResult.value;
    }
    final alreadyGetResult = await _alreadyGetCardQueryService.get();
    if (alreadyGetResult is Success<List<AlreadyGetCardDTO>>) {
      _alreadyGetCardDTOList = alreadyGetResult.value;
    }

    final alreadyGetSubscription = _alreadyGetCardQueryService
        .getStream()
        .listen((dtoList) async {
      // 購読開始時にも現在値が流れてくるため、変わっていなければ作り直さない。
      if (_sameCardIds(dtoList, _alreadyGetCardDTOList)) {
        return;
      }
      _alreadyGetCardDTOList = dtoList;
      state = AsyncData(await _buildViewData());
    });
    ref.onDispose(alreadyGetSubscription.cancel);

    final searchConditionSubscription = _searchConditionQueryService
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
      listCardDTOList: _listCardDTOList,
      alreadyGetCardDTOList: _alreadyGetCardDTOList,
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
      totalCount: _listCardDTOList.length,
      alreadyGetCount: _alreadyGetCardDTOList.length,
      activeFilterCount: _searchCondition.activeFilterCount,
    );
  }

  static bool _sameCardIds(
    List<AlreadyGetCardDTO> a,
    List<AlreadyGetCardDTO> b,
  ) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].cardId != b[i].cardId) {
        return false;
      }
    }
    return true;
  }
}
