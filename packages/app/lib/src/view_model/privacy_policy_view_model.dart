import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:domain/domain.dart';

/// 状態はプライバシーポリシーの HTML。
final privacyPolicyViewModelProvider =
    AsyncNotifierProvider.autoDispose<PrivacyPolicyViewModel, String>(
      PrivacyPolicyViewModel.new,
    );

class PrivacyPolicyViewModel extends AutoDisposeAsyncNotifier<String> {
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);

  @override
  Future<String> build() async {
    final privacyPolicyUseCase = ref.watch(privacyPolicyUseCaseProvider);
    final navigationService = ref.watch(navigationServiceProvider);

    final result = await privacyPolicyUseCase.get();
    if (result case Failure(:final exception)) {
      unawaited(
        navigationService.showFailure(
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
      event: const AnalyticsEvent.screenView(screenName: 'privacy_policy_view'),
    );
  }
}
