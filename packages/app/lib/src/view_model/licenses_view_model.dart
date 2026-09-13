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
    if (result is Failure) {
      unawaited(
        _navigationService.showAlert(
          title: 'エラー',
          message: 'アプリ情報の取得に失敗しました',
        ),
      );
      return const LicensesViewData();
    }
    final appInfoDTO = (result as Success<AppInfoDTO>).value;
    return LicensesViewData(
      appName: appInfoDTO.name,
      appVersion: appInfoDTO.version,
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
