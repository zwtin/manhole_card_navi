import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/check_master_update_view.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/check_app_update_use_case.dart';

final checkAppUpdateViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<CheckAppUpdateViewModel, Key?>(
  (ref, key) {
    return CheckAppUpdateViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(checkAppUpdateUseCaseProvider),
    );
  },
);

class CheckAppUpdateViewModel extends ChangeNotifier {
  CheckAppUpdateViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._checkAppUpdateUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final CheckAppUpdateUseCase _checkAppUpdateUseCase;

  bool isLoading = false;

  Future<void> onLoad() async {
    _logger.d('CheckAppUpdateViewModel');
    await _sendEvent();
    await _checkNeedUpdate();
  }

  Future<void> _checkNeedUpdate() async {
    isLoading = true;
    notifyListeners();
    final result = await _checkAppUpdateUseCase.getNeedUpdate();
    isLoading = false;
    notifyListeners();
    result.when(
      success: (dto) async {
        if (dto.need) {
          _ref.read(alertProvider.notifier).show(
                title: 'エラー',
                message: '最新バージョンのアプリをお使いください',
                okButtonTitle: 'OK',
                okButtonAction: () async {
                  await _checkNeedUpdate();
                },
                cancelButtonTitle: null,
                cancelButtonAction: null,
              );
        } else {
          await _ref.read(routerProvider(_key).notifier).pushReplacement(
                nextWidget: CheckMasterUpdateView(
                  key: UniqueKey(),
                ),
              );
        }
      },
      failure: (exception) async {
        _ref.read(alertProvider.notifier).show(
              title: 'エラー',
              message: 'アプリバージョンの取得に失敗しました',
              okButtonTitle: 'OK',
              okButtonAction: () async {
                await _checkNeedUpdate();
              },
              cancelButtonTitle: null,
              cancelButtonAction: null,
            );
      },
    );
  }

  Future<void> _sendEvent() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {'screen_name': 'check_app_update_view'},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('CheckAppUpdateViewModel dispose');
  }
}
