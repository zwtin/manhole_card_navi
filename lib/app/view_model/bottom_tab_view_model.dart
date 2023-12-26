import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/provider/party_animation_provider.dart';
import 'package:manhole_card_navi/infra/query_service_impl/already_get_card_query_service_impl.dart';
import 'package:manhole_card_navi/use_case/dto/already_get_card_dto.dart';
import 'package:manhole_card_navi/use_case/query_service/already_get_card_query_service.dart';

import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<BottomTabViewModel, Key?>(
  (ref, key) {
    return BottomTabViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;

  int selectedIndex = 0;

  late StreamSubscription<List<AlreadyGetCardDTO>>
      _alreadyGetCardStreamSubscription;
  final List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];

  Future<void> onLoad() async {
    _logger.d('BottomTabViewModel');
    _ref.read(tabKeyStorageProvider).setBottomTabKey(_key);
    await _listenAlreadyGetCard();
  }

  void onTap(int index) {
    if (selectedIndex == index) {
      final tabKey = _ref.read(tabKeyStorageProvider).getTabKey(selectedIndex);
      _ref.read(routerProvider(tabKey).notifier).popToRoot();
    } else {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void pop() {
    final tabKey = _ref.read(tabKeyStorageProvider).getTabKey(selectedIndex);
    _ref.read(routerProvider(tabKey).notifier).pop();
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardStreamSubscription =
        _alreadyGetCardQueryService.getStream().listen((dtoList) async {
      if (_alreadyGetCardDTOList.length < dtoList.length) {
        _ref.read(partyAnimationProvider.notifier).start();
      }
      _alreadyGetCardDTOList.clear();
      _alreadyGetCardDTOList.addAll(dtoList);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BottomTabViewModel dispose');
    _alreadyGetCardStreamSubscription.cancel();
  }
}
