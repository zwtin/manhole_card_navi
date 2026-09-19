import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/navigation_service.dart';
import '../view_data/check_terms_of_service_agree_view_data.dart';

final checkTermsOfServiceAgreeViewModelProvider = NotifierProvider.autoDispose<
    CheckTermsOfServiceAgreeViewModel, CheckTermsOfServiceAgreeViewData>(
  CheckTermsOfServiceAgreeViewModel.new,
);

/// 初回起動時に利用規約とプライバシーポリシーへの同意を求める画面の ViewModel。
class CheckTermsOfServiceAgreeViewModel
    extends AutoDisposeNotifier<CheckTermsOfServiceAgreeViewData> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final NavigationService _navigationService;
  late final TermsOfServiceUseCase _termsOfServiceUseCase;

  @override
  CheckTermsOfServiceAgreeViewData build() {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);
    _termsOfServiceUseCase = ref.watch(termsOfServiceUseCaseProvider);
    return const CheckTermsOfServiceAgreeViewData();
  }

  void onTapCheckBox() {
    state = state.copyWith(isAgreed: !state.isAgreed);
  }

  Future<void> onTapAgreeButton() async {
    if (!state.isAgreed) {
      await _navigationService.showAlert(
        title: 'エラー',
        message: '利用規約とプライバシーポリシーに同意してください',
      );
      return;
    }
    await _saveAgreedVersion();
    _navigationService.goToHome();
  }

  Future<void> onTapTermsOfService() async {
    await _navigationService.pushTermsOfService();
  }

  Future<void> onTapPrivacyPolicy() async {
    await _navigationService.pushPrivacyPolicy();
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(
        screenName: 'check_terms_of_service_agree_view',
      ),
    );
  }

  /// 同意したバージョンを保存する。失敗したら成功するまでやり直す。
  Future<void> _saveAgreedVersion() async {
    while (true) {
      state = state.copyWith(isLoading: true);
      final result = await _termsOfServiceUseCase.agree();
      state = state.copyWith(isLoading: false);
      if (result case Failure(:final exception)) {
        await _navigationService.showFailure(
          title: '同意を保存できませんでした',
          exception: exception,
        );
        continue;
      }
      return;
    }
  }
}
