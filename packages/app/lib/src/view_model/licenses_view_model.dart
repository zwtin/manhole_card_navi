import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_data/licenses_view_data.dart';

final licensesViewModelProvider =
    AsyncNotifierProvider.autoDispose<LicensesViewModel, LicensesViewData>(
  LicensesViewModel.new,
);

/// ライセンス画面の ViewModel。
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
      appVersion: appInfo.version,
    );
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'license_view',
      },
    );
  }
}
