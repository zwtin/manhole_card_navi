import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/view_model/manhole_card_map_view_model.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/use_case/already_get_card_use_case.dart';

final detailViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<DetailViewModel, Key?>(
  (ref, key) {
    return DetailViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
      ref.watch(alreadyGetCardUseCaseProvider),
    );
  },
);

class DetailViewModel extends ChangeNotifier {
  DetailViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._alreadyGetCardUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  String cardId = '';
  bool alreadyGet = false;
  late StreamSubscription<List<AlreadyGetCardDTO>>
      _alreadyGetCardStreamSubscription;

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;

  final AlreadyGetCardUseCase _alreadyGetCardUseCase;

  Future<void> onLoad(
    String cardId,
  ) async {
    _logger.d('DetailViewModel');
    this.cardId = cardId;
    await _listenAlreadyGetCard();
  }

  Future<void> onTapCheckWithMapButton() async {
    final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
    _ref.read(bottomTabViewModelProvider(bottomTabKey)).onTap(0);
    final mapTabKey = _ref.read(tabKeyStorageProvider).getTabKey(0);
    _ref
        .read(manholeCardMapViewModelProvider(mapTabKey))
        .onTapCheckWithMapButton(cardId);
  }

  Future<void> onTapAlreadyGetButton() async {
    if (alreadyGet) {
      _deleteCard();
    } else {
      _saveCard();
    }
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardStreamSubscription =
        _alreadyGetCardQueryService.getStream().listen(
      (dto) {
        alreadyGet = dto.map((e) => e.cardId).contains(cardId);
        notifyListeners();
      },
    );
  }

  Future<void> _saveCard() async {
    _alreadyGetCardUseCase.save(id: cardId);
  }

  Future<void> _deleteCard() async {
    _alreadyGetCardUseCase.delete(id: cardId);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('DetailViewModel dispose');
    _alreadyGetCardStreamSubscription.cancel();
  }
}
