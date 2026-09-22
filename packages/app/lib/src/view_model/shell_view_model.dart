import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_data/shell_view_data.dart';

/// 位置情報の利用許可を求め終えたか。マップが現在地の表示を切り替えるために見る。
final locationPermissionRequestedProvider = StateProvider<bool>((ref) => false);

final shellViewModelProvider =
    NotifierProvider.autoDispose<ShellViewModel, ShellViewData>(
  ShellViewModel.new,
);

/// 下タブ（マップ・リスト・設定）を持つ画面の ViewModel。
class ShellViewModel extends AutoDisposeNotifier<ShellViewData> {
  late final AlreadyGetCardUseCase _alreadyGetCardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final AppBadgeUseCase _appBadgeUseCase;
  late final LocationUseCase _locationUseCase;
  late final PushNotificationUseCase _pushNotificationUseCase;

  int _alreadyGetCardCount = 0;

  @override
  ShellViewData build() {
    _alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _appBadgeUseCase = ref.watch(appBadgeUseCaseProvider);
    _locationUseCase = ref.watch(locationUseCaseProvider);
    _pushNotificationUseCase = ref.watch(pushNotificationUseCaseProvider);
    return const ShellViewData();
  }

  Future<void> onLoad() async {
    await _sendScreenView();
    await _listenAlreadyGetCard();
    await _pushNotificationUseCase.requestPermission();
    await _locationUseCase.requestPermission();
    ref.read(locationPermissionRequestedProvider.notifier).state = true;
    await _appBadgeUseCase.remove();
  }

  Future<void> _sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(screenName: 'bottom_tab_view'),
    );
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardCount = (await _alreadyGetCardUseCase.watch().first).length;
    final subscription = _alreadyGetCardUseCase.watch().listen((
      cardIds,
    ) {
      if (cardIds.length > _alreadyGetCardCount) {
        state = state.copyWith(partyCount: state.partyCount + 1);
      }
      _alreadyGetCardCount = cardIds.length;
    });
    ref.onDispose(subscription.cancel);
  }
}
