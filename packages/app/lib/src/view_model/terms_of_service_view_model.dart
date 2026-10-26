import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:domain/domain.dart';

/// 状態は利用規約の HTML。
final termsOfServiceViewModelProvider =
    AsyncNotifierProvider.autoDispose<TermsOfServiceViewModel, String>(
      TermsOfServiceViewModel.new,
    );

class TermsOfServiceViewModel extends AutoDisposeAsyncNotifier<String> {
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);

  @override
  Future<String> build() async {
    final termsOfServiceUseCase = ref.watch(termsOfServiceUseCaseProvider);
    final navigationService = ref.watch(navigationServiceProvider);

    final result = await termsOfServiceUseCase.get();
    if (result case Failure(:final exception)) {
      unawaited(
        navigationService.showFailure(
          title: '利用規約を表示できませんでした',
          exception: exception,
        ),
      );
      return '';
    }
    return (result as Success<TermsOfService>).value.value;
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(
        screenName: 'terms_of_service_view',
      ),
    );
  }
}
