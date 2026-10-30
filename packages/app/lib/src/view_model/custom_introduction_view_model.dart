import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:domain/domain.dart';

/// 引数は、初回起動時のチュートリアルとして表示するか（設定の「アプリの使い方」なら false）。
final customIntroductionViewModelProvider = NotifierProvider.autoDispose
    .family<CustomIntroductionViewModel, void, bool>(
      CustomIntroductionViewModel.new,
    );

class CustomIntroductionViewModel
    extends AutoDisposeFamilyNotifier<void, bool> {
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);

  @override
  void build(bool isTutorial) {}

  Future<void> onDone() async {
    if (arg) {
      await _navigationService.pushTermsOfServiceAgree();
    } else {
      _navigationService.pop();
    }
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(
        screenName: 'custom_introduction_view',
      ),
    );
  }
}
