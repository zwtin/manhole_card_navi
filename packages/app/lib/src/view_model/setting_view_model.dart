import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_data/setting_view_data.dart';

final settingViewModelProvider =
    AsyncNotifierProvider.autoDispose<SettingViewModel, SettingViewData>(
  SettingViewModel.new,
);

/// 設定タブの ViewModel。
class SettingViewModel extends AutoDisposeAsyncNotifier<SettingViewData> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final AppInfoUseCase _appInfoUseCase;
  late final NavigationService _navigationService;

  @override
  Future<SettingViewData> build() async {
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
      return const SettingViewData();
    }
    final appInfo = (result as Success<AppInfo>).value;
    return SettingViewData(
      appName: appInfo.name,
      appVersion: appInfo.version,
    );
  }

  Future<void> onTapHowToUse() async {
    await _navigationService.pushHowToUse();
  }

  Future<void> onTapRequestImprovement() async {
    await _navigationService.openUrl('https://forms.gle/JVEuCBxCJhAZFSQA7');
  }

  Future<void> onTapTermsOfService() async {
    await _navigationService.pushTermsOfService();
  }

  Future<void> onTapPrivacyPolicy() async {
    await _navigationService.pushPrivacyPolicy();
  }

  Future<void> onTapLicense() async {
    await _navigationService.pushLicense();
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {'screen_name': 'setting_view'},
    );
  }
}
