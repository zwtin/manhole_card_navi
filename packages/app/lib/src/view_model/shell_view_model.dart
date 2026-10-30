import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/view_data/shell_view_data.dart';
import 'package:domain/domain.dart';

final shellViewModelProvider =
    NotifierProvider.autoDispose<ShellViewModel, ShellViewData>(
      ShellViewModel.new,
    );

class ShellViewModel extends AutoDisposeNotifier<ShellViewData> {
  AlreadyGetCardUseCase get _alreadyGetCardUseCase =>
      ref.read(alreadyGetCardUseCaseProvider);
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  AppBadgeUseCase get _appBadgeUseCase => ref.read(appBadgeUseCaseProvider);
  LocationUseCase get _locationUseCase => ref.read(locationUseCaseProvider);
  PushNotificationUseCase get _pushNotificationUseCase =>
      ref.read(pushNotificationUseCaseProvider);

  int _alreadyGetCardCount = 0;

  @override
  ShellViewData build() {
    return const ShellViewData();
  }

  Future<void> onLoad() async {
    await _sendScreenView();
    await _listenAlreadyGetCard();
    await _pushNotificationUseCase.requestPermission();
    await _locationUseCase.requestPermission();
    await _appBadgeUseCase.remove();
  }

  Future<void> _sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(screenName: 'bottom_tab_view'),
    );
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardCount = (await _alreadyGetCardUseCase.watch().first).length;
    final subscription = _alreadyGetCardUseCase.watch().listen((cardIds) {
      if (cardIds.length > _alreadyGetCardCount) {
        state = state.copyWith(partyCount: state.partyCount + 1);
      }
      _alreadyGetCardCount = cardIds.length;
    });
    ref.onDispose(subscription.cancel);
  }
}
