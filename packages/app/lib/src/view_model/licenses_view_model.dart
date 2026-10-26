import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/licenses_view_data.dart';
import 'package:domain/domain.dart';

final licensesViewModelProvider =
    AsyncNotifierProvider.autoDispose<LicensesViewModel, LicensesViewData>(
      LicensesViewModel.new,
    );

class LicensesViewModel extends AutoDisposeAsyncNotifier<LicensesViewData> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final AppInfoUseCase _appInfoUseCase;
  late final NavigationService _navigationService;

  @override
  Future<LicensesViewData> build() async {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _appInfoUseCase = ref.watch(appInfoUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    final result = await _appInfoUseCase.get();
    if (result case Failure(:final exception)) {
      unawaited(
        _navigationService.showFailure(
          title: 'アプリの情報を取得できませんでした',
          exception: exception,
        ),
      );
      return const LicensesViewData();
    }
    final appInfo = (result as Success<AppInfo>).value;
    return LicensesViewData(
      appName: appInfo.name,
      appVersion: appInfo.version.value,
    );
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(screenName: 'license_view'),
    );
  }
}
