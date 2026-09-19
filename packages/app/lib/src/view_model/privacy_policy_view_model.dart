import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/navigation_service.dart';

/// 状態はプライバシーポリシーの HTML。
final privacyPolicyViewModelProvider =
    AsyncNotifierProvider.autoDispose<PrivacyPolicyViewModel, String>(
  PrivacyPolicyViewModel.new,
);

/// プライバシーポリシー画面の ViewModel。
class PrivacyPolicyViewModel extends AutoDisposeAsyncNotifier<String> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final PrivacyPolicyUseCase _privacyPolicyUseCase;
  late final NavigationService _navigationService;

  @override
  Future<String> build() async {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _privacyPolicyUseCase = ref.watch(privacyPolicyUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    final result = await _privacyPolicyUseCase.get();
    if (result case Failure(:final exception)) {
      unawaited(
        _navigationService.showFailure(
          title: 'プライバシーポリシーを表示できませんでした',
          exception: exception,
        ),
      );
      return '';
    }
    return (result as Success<PrivacyPolicy>).value.value;
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'privacy_policy_view',
      },
    );
  }
}
