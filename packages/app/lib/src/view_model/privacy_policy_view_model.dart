import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/privacy_policy_view_data.dart';
import 'package:domain/domain.dart';

final privacyPolicyViewModelProvider = AsyncNotifierProvider.autoDispose<
  PrivacyPolicyViewModel,
  PrivacyPolicyViewData
>(PrivacyPolicyViewModel.new);

class PrivacyPolicyViewModel
    extends AutoDisposeAsyncNotifier<PrivacyPolicyViewData> {
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);

  @override
  Future<PrivacyPolicyViewData> build() async {
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
      return const PrivacyPolicyViewData();
    }
    return PrivacyPolicyViewData(
      html: (result as Success<PrivacyPolicy>).value.value,
    );
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(screenName: 'privacy_policy_view'),
    );
  }
}
