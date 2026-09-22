import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/navigation_service.dart';

/// 引数は、初回起動時のチュートリアルとして表示するか（設定の「アプリの使い方」なら false）。
final customIntroductionViewModelProvider = NotifierProvider.autoDispose
    .family<CustomIntroductionViewModel, void, bool>(
  CustomIntroductionViewModel.new,
);

/// アプリの使い方（チュートリアル）画面の ViewModel。
class CustomIntroductionViewModel extends AutoDisposeFamilyNotifier<void, bool> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final NavigationService _navigationService;

  @override
  void build(bool isTutorial) {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);
  }

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
