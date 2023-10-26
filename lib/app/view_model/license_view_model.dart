import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/app_info_dto.dart';
import '/use_case/use_case/app_info_use_case.dart';

final licenseViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<LicenseViewModel, Key?>(
  (ref, key) {
    return LicenseViewModel(
      key,
      ref,
      ref.watch(appInfoUseCaseProvider),
    );
  },
);

class LicenseViewModel extends ChangeNotifier {
  LicenseViewModel(
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
    _logger.d('LicenseViewModel');
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

  @override
  void dispose() {
    super.dispose();
    _logger.d('LicenseViewModel dispose');
  }
}
