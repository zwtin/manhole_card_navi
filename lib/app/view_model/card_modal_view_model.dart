import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/mapper/modal_card_view_data_mapper.dart';
import '/app/provider/alert_provider.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view/detail_view.dart';
import '/app/view_data/modal_card_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/use_case/already_get_card_use_case.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/card_use_case.dart';

final cardModalViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<CardModalViewModel, Key?>(
  (ref, key) {
    return CardModalViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
      ref.watch(alreadyGetCardUseCaseProvider),
      ref.watch(analyticsUseCaseProvider),
      ref.watch(cardUseCaseProvider),
    );
  },
);

class CardModalViewModel extends ChangeNotifier {
  CardModalViewModel(
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
  late ModalCardViewData viewData;
  String get alreadyGetActionButtonTitle {
    if (_alreadyGet) {
      return '未取得に戻す';
    } else {
      return '取得済みにする';
    }
  }

  String _cardId = '';
  late LatLng _position;
  late CardDTO _cardDTO;
  bool _alreadyGet = false;
  late StreamSubscription<List<AlreadyGetCardDTO>>
      _alreadyGetCardStreamSubscription;

  Future<void> onLoad(
    String cardId,
    LatLng position,
  ) async {
    _cardId = cardId;
    _position = position;
    await onCameBack();
    await _fetch();
    await _listenAlreadyGetCard();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'card_modal_view',
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

  Future<void> onTapDetailButton() async {
    await _transitionToDetailView();
  }

  Future<void> onTapAlreadyGetButton() async {
    if (_alreadyGet) {
      await _confirmToDeleteCard();
    } else {
      await _saveCard();
    }
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
    viewData = await ModalCardViewDataMapper.convertToViewData(
      cardDTO: _cardDTO,
      position: _position,
    );
    isLoading = false;
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardStreamSubscription =
        _alreadyGetCardQueryService.getStream().listen(
      (dto) async {
        _alreadyGet = dto.map((e) => e.cardId).contains(_cardId);
        notifyListeners();
      },
    );
  }

  Future<void> _saveCard() async {
    _alreadyGetCardUseCase.save(id: _cardId);
  }

  Future<void> _confirmToDeleteCard() async {
    _ref.read(alertProvider.notifier).show(
          title: '確認',
          message: 'カードを未取得に戻してよろしいですか？',
          okButtonTitle: 'OK',
          okButtonAction: () async {
            await _deleteCard();
          },
          cancelButtonTitle: 'キャンセル',
          cancelButtonAction: () async {},
        );
  }

  Future<void> _deleteCard() async {
    _alreadyGetCardUseCase.delete(id: _cardId);
  }

  Future<void> _transitionToDetailView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: DetailView(
            key: UniqueKey(),
            cardId: _cardId,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('CardModalViewModel dispose');
    _alreadyGetCardStreamSubscription.cancel();
  }
}
