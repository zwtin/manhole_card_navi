import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/privacy_policy_view.dart';
import '/app/view/terms_of_service_view.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/current_app_version_dto.dart';
import '/use_case/use_case/current_app_version_use_case.dart';

final settingViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<SettingViewModel, Key?>(
  (ref, key) {
    return SettingViewModel(
      key,
      ref,
      ref.watch(currentAppVersionUseCaseProvider),
    );
  },
);

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(
    this._key,
    this._ref,
    this._currentAppVersionUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final CurrentAppVersionUseCase _currentAppVersionUseCase;

  String currentAppVersion = '';

  Future<void> onLoad() async {
    _logger.d('SettingViewModel');
    await _fetchCurrentAppVersion();
  }

  Future<void> _fetchCurrentAppVersion() async {
    final result = await _currentAppVersionUseCase.get();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'アプリバージョンの取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
    }
    final currentAppVersionDTO =
        (result as Success<CurrentAppVersionDTO>).value;
    currentAppVersion = currentAppVersionDTO.value;
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
          nextWidget: const LicensePage(),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('SettingViewModel dispose');
  }
}
