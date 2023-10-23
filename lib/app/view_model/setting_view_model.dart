import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/privacy_policy_view.dart';
import '/app/view/terms_of_service_view.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/app_info_dto.dart';
import '/use_case/use_case/app_info_use_case.dart';

final settingViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<SettingViewModel, Key?>(
  (ref, key) {
    return SettingViewModel(
      key,
      ref,
      ref.watch(appInfoUseCaseProvider),
    );
  },
);

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(
    this._key,
    this._ref,
    this._appInfoUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AppInfoUseCase _appInfoUseCase;

  String appName = '';
  String appVersion = '';

  Future<void> onLoad() async {
    _logger.d('SettingViewModel');
    await _fetchAppInfo();
  }

  Future<void> _fetchAppInfo() async {
    final result = await _appInfoUseCase.get();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'アプリ情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
    }
    final appInfoDTO = (result as Success<AppInfoDTO>).value;
    appName = appInfoDTO.name;
    appVersion = appInfoDTO.version;
    notifyListeners();
  }

  Future<void> onTapTermsOfService() async {
    await _transitionToTermsOfServiceView();
  }

  Future<void> _transitionToTermsOfServiceView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: TermsOfServiceView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> onTapPrivacyPolicy() async {
    await _transitionToPrivacyPolicyView();
  }

  Future<void> _transitionToPrivacyPolicyView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: PrivacyPolicyView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> onTapLicense() async {
    await _transitionToLicenseView();
  }

  Future<void> _transitionToLicenseView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: LicensePage(
            applicationName: appName,
            applicationVersion: appVersion,
            applicationIcon: const FlutterLogo(),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('SettingViewModel dispose');
  }
}
