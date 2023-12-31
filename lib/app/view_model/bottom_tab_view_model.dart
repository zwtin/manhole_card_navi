import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/location_permission_provider.dart';
import '/app/provider/party_animation_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/use_case/push_notification_use_case.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<BottomTabViewModel, Key?>(
  (ref, key) {
    return BottomTabViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
      ref.watch(pushNotificationUseCaseProvider),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._pushNotificationUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;

  final PushNotificationUseCase _pushNotificationUseCase;

  int selectedIndex = 0;

  late StreamSubscription<List<AlreadyGetCardDTO>>
      _alreadyGetCardStreamSubscription;
  final List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];

  Future<void> onLoad() async {
    _logger.d('BottomTabViewModel');
    _ref.read(tabKeyStorageProvider).setBottomTabKey(_key);
    await _initAlreadyGetCardDTOList();
    await _listenAlreadyGetCard();
    await _requestPushNotificationPermission();
    await _removeAppBadge();
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
      if (_alreadyGetCardDTOList.length == dtoList.length) {
        return;
      }
      if (_alreadyGetCardDTOList.length < dtoList.length) {
        _ref.read(partyAnimationProvider.notifier).start();
      }
      _alreadyGetCardDTOList.clear();
      _alreadyGetCardDTOList.addAll(dtoList);
    });
  }

  Future<void> _initAlreadyGetCardDTOList() async {
    final result = await _alreadyGetCardQueryService.get();
    if (result is Failure) {
      return;
    }
    final dtoList = (result as Success<List<AlreadyGetCardDTO>>).value;
    _alreadyGetCardDTOList.clear();
    _alreadyGetCardDTOList.addAll(dtoList);
  }

  Future<void> _requestPushNotificationPermission() async {
    await _pushNotificationUseCase.requestPermission();
    _ref.read(locationPermissionProvider.notifier).request();
  }

  Future<void> _removeAppBadge() async {
    FlutterAppBadger.removeBadge();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BottomTabViewModel dispose');
    _alreadyGetCardStreamSubscription.cancel();
  }
}
