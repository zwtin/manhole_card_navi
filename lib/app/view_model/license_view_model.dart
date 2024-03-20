import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/app_info_dto.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/app_info_use_case.dart';

final licenseViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<LicenseViewModel, Key?>(
  (ref, key) {
    return LicenseViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(appInfoUseCaseProvider),
    );
  },
);

class LicenseViewModel extends ChangeNotifier {
  LicenseViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._appInfoUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final AppInfoUseCase _appInfoUseCase;

  String appName = '';
  String appVersion = '';

  Future<void> onLoad() async {
    await onCameBack();
    await _fetchAppInfo();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'license_view',
      },
    );
  }

  Future<void> onCameBack() async {
    final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
    final selectedIndex = _ref
        .read(bottomTabViewModelProvider(bottomTabKey).notifier)
        .selectedIndex;
    _ref.read(tabKeyStorageProvider).setTabKey(selectedIndex, _key);
    _ref.read(pvSendProvider.notifier).send();
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

  @override
  void dispose() {
    super.dispose();
    _logger.d('LicenseViewModel dispose');
  }
}
