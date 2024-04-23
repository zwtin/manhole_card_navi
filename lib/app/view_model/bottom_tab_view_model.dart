import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/location_permission_provider.dart';
import '/app/provider/party_animation_provider.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/app_badge_use_case.dart';
import '/use_case/use_case/location_use_case.dart';
import '/use_case/use_case/push_notification_use_case.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<BottomTabViewModel, Key?>(
  (ref, key) {
    return BottomTabViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
      ref.watch(analyticsUseCaseProvider),
      ref.watch(appBadgeUseCaseProvider),
      ref.watch(locationUseCaseProvider),
      ref.watch(pushNotificationUseCaseProvider),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._analyticsUseCase,
    this._appBadgeUseCase,
    this._locationUseCase,
    this._pushNotificationUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;

  final AnalyticsUseCase _analyticsUseCase;
  final AppBadgeUseCase _appBadgeUseCase;
  final LocationUseCase _locationUseCase;
  final PushNotificationUseCase _pushNotificationUseCase;

  int selectedIndex = 0;
  late StreamSubscription<List<AlreadyGetCardDTO>>
      _alreadyGetCardStreamSubscription;
  final List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];

  Future<void> onLoad() async {
    _ref.read(tabKeyStorageProvider).setBottomTabKey(_key);
    await sendPV();
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
      _ref.read(pvSendProvider.notifier).send();
    }
  }

  void pop() {
    final tabKey = _ref.read(tabKeyStorageProvider).getTabKey(selectedIndex);
    _ref.read(routerProvider(tabKey).notifier).pop();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'bottom_tab_view',
      },
    );
  }

  Future<void> onCameBack() async {}

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
    await _locationUseCase.requestPermission();
    _ref.read(locationPermissionProvider.notifier).requested();
  }

  Future<void> _removeAppBadge() async {
    _appBadgeUseCase.remove();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BottomTabViewModel dispose');
    _alreadyGetCardStreamSubscription.cancel();
  }
}
