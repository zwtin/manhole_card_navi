import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/terms_of_service_view_data.dart';
import 'package:domain/domain.dart';

final termsOfServiceViewModelProvider = AsyncNotifierProvider.autoDispose<
  TermsOfServiceViewModel,
  TermsOfServiceViewData
>(TermsOfServiceViewModel.new);

class TermsOfServiceViewModel
    extends AutoDisposeAsyncNotifier<TermsOfServiceViewData> {
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);

  @override
  Future<TermsOfServiceViewData> build() async {
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
      return const TermsOfServiceViewData();
    }
    return TermsOfServiceViewData(
      html: (result as Success<TermsOfService>).value.value,
    );
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(
        screenName: 'terms_of_service_view',
      ),
    );
  }
}
