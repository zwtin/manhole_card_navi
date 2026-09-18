import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_data/check_terms_of_service_update_view_data.dart';

final checkTermsOfServiceUpdateViewModelProvider = NotifierProvider.autoDispose<
    CheckTermsOfServiceUpdateViewModel, CheckTermsOfServiceUpdateViewData>(
  CheckTermsOfServiceUpdateViewModel.new,
);

/// 起動時に利用規約が更新されていないか確認し、更新されていれば再同意を求める ViewModel。
class CheckTermsOfServiceUpdateViewModel
    extends AutoDisposeNotifier<CheckTermsOfServiceUpdateViewData> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final CheckTermsOfServiceUpdateUseCase _checkTermsOfServiceUpdateUseCase;
  late final SaveTermsOfServiceAgreeVersionUseCase
      _saveTermsOfServiceAgreeVersionUseCase;
  late final NavigationService _navigationService;

  @override
  CheckTermsOfServiceUpdateViewData build() {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _checkTermsOfServiceUpdateUseCase = ref.watch(
      checkTermsOfServiceUpdateUseCaseProvider,
    );
    _saveTermsOfServiceAgreeVersionUseCase = ref.watch(
      saveTermsOfServiceAgreeVersionUseCaseProvider,
    );
    _navigationService = ref.watch(navigationServiceProvider);
    return const CheckTermsOfServiceUpdateViewData();
  }

  Future<void> onLoad() async {
    while (true) {
      state = state.copyWith(isLoading: true);
      final result = await _checkTermsOfServiceUpdateUseCase.getNeedUpdate();
      state = state.copyWith(isLoading: false);
      if (result case Failure(:final exception)) {
        await _navigationService.showFailure(
          title: '利用規約の更新を確認できませんでした',
          exception: exception,
        );
        continue;
      }
      final needUpdate = (result as Success<bool>).value;
      if (needUpdate) {
        state = state.copyWith(inquireUpdate: true);
      } else {
        _navigationService.goToHome();
      }
      return;
    }
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
      name: 'screen_pv',
      parameters: {
        'screen_name': 'check_terms_of_service_update_view',
      },
    );
  }

  /// 同意したバージョンを保存する。失敗したら成功するまでやり直す。
  Future<void> _saveAgreedVersion() async {
    while (true) {
      state = state.copyWith(isLoading: true);
      final result = await _saveTermsOfServiceAgreeVersionUseCase.save();
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
