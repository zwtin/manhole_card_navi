import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 状態は利用規約の HTML。
final termsOfServiceViewModelProvider =
    AsyncNotifierProvider.autoDispose<TermsOfServiceViewModel, String>(
  TermsOfServiceViewModel.new,
);

/// 利用規約画面の ViewModel。
class TermsOfServiceViewModel extends AutoDisposeAsyncNotifier<String> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final TermsOfServiceUseCase _termsOfServiceUseCase;
  late final NavigationService _navigationService;

  @override
  Future<String> build() async {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _termsOfServiceUseCase = ref.watch(termsOfServiceUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    final result = await _termsOfServiceUseCase.get();
    if (result is Failure) {
      unawaited(
        _navigationService.showAlert(
          title: 'エラー',
          message: '利用規約の取得に失敗しました',
        ),
      );
      return '';
    }
    return (result as Success<TermsOfServiceDTO>).value.value;
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'terms_of_service_view',
      },
    );
  }
}
