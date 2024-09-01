import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/mapper/detail_card_view_data_mapper.dart';
import '/app/provider/alert_provider.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_data/detail_card_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/view_model/manhole_card_map_view_model.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/use_case/already_get_card_use_case.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/card_use_case.dart';

final detailViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<DetailViewModel, Key?>(
  (ref, key) {
    return DetailViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
      ref.watch(alreadyGetCardUseCaseProvider),
      ref.watch(analyticsUseCaseProvider),
      ref.watch(cardUseCaseProvider),
    );
  },
);

class DetailViewModel extends ChangeNotifier {
  DetailViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._alreadyGetCardUseCase,
    this._analyticsUseCase,
    this._cardUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;

  final AlreadyGetCardUseCase _alreadyGetCardUseCase;
  final AnalyticsUseCase _analyticsUseCase;
  final CardUseCase _cardUseCase;

  bool isLoading = true;
  late DetailCardViewData viewData;
  String get alreadyGetActionButtonTitle {
    if (_alreadyGet) {
      return '未取得に戻す';
    } else {
      return '取得済みにする';
    }
  }

  String _cardId = '';
  late CardDTO _cardDTO;
  bool _alreadyGet = false;
  late StreamSubscription<List<AlreadyGetCardDTO>>
      _alreadyGetCardStreamSubscription;

  Future<void> onLoad(
    String cardId,
  ) async {
    _cardId = cardId;
    await onCameBack();
    await _fetch();
    await _listenAlreadyGetCard();
  }

  Future<void> onTapCheckWithMapButton() async {
    final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
    _ref.read(bottomTabViewModelProvider(bottomTabKey).notifier).onTap(0);
    final mapKey = _ref.read(tabKeyStorageProvider).getMapKey();
    _ref.read(routerProvider(mapKey).notifier).popToRoot();
    _ref
        .read(manholeCardMapViewModelProvider(mapKey))
        .onTapCheckWithMapButton(_cardId);
  }

  Future<void> onTapAlreadyGetButton() async {
    if (_alreadyGet) {
      _deleteCard();
    } else {
      _saveCard();
    }
  }

  Future<void> onTapImage(String heroTag) async {
    await _transitionToImageDetailView(heroTag);
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'detail_view',
        'card_id': _cardId,
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

  Future<void> _fetch() async {
    final result = await _cardUseCase.get(id: _cardId);
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
    _cardDTO = (result as Success<CardDTO>).value;
    isLoading = false;
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardStreamSubscription =
        _alreadyGetCardQueryService.getStream().listen(
      (dto) async {
        _alreadyGet = dto.map((e) => e.cardId).contains(_cardId);
        await _resetViewData();
      },
    );
  }

  Future<void> _resetViewData() async {
    viewData = await DetailCardViewDataMapper.convertToViewData(
      cardDTO: _cardDTO,
      alreadyGet: _alreadyGet,
    );
    notifyListeners();
  }

  Future<void> _saveCard() async {
    _alreadyGetCardUseCase.save(id: _cardId);
  }

  Future<void> _deleteCard() async {
    _alreadyGetCardUseCase.delete(id: _cardId);
  }

  Future<void> _transitionToImageDetailView(String heroTag) async {
    await _ref.read(routerProvider(_key).notifier).presentImage(
          cardId: _cardId,
          imageUrl: viewData.imageUrl,
          imageTag: heroTag,
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('DetailViewModel dispose');
    _alreadyGetCardStreamSubscription.cancel();
  }
}
