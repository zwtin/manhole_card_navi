import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/mapper/modal_card_view_data_mapper.dart';
import 'package:manhole_card_navi/app/provider/alert_provider.dart';
import 'package:manhole_card_navi/domain/entity/result.dart';

import '/app/provider/router_provider.dart';
import '/app/view/detail_view.dart';
import '/app/view_data/modal_card_view_data.dart';
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
  StreamSubscription<List<AlreadyGetCardDTO>>?
      _alreadyGetCardStreamSubscription;

  Future<void> onLoad(
    String cardId,
    LatLng position,
  ) async {
    _logger.d('CardModalViewModel');
    _cardId = cardId;
    _position = position;
    await _fetch();
    await _listenAlreadyGetCard();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'card_modal_view',
      },
    );
  }

  Future<void> onTapAlreadyGetButton() async {
    if (_alreadyGet) {
      _deleteCard();
    } else {
      _saveCard();
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

  Future<void> _deleteCard() async {
    _alreadyGetCardUseCase.delete(id: _cardId);
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
    _logger.d('CardModalViewModel dispose');
    _alreadyGetCardStreamSubscription?.cancel();
  }
}
