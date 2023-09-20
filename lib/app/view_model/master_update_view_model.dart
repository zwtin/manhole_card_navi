import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/bottom_tab_view.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/check_update_use_case.dart';

final masterUpdateViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<MasterUpdateViewModel, Key?>(
  (ref, key) {
    return MasterUpdateViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(checkUpdateUseCaseProvider),
    );
  },
);

class MasterUpdateViewModel extends ChangeNotifier {
  MasterUpdateViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._checkUpdateUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final CheckUpdateUseCase _checkUpdateUseCase;

  bool isLoading = false;

  Future<void> onLoad() async {
    _logger.d('MasterUpdateViewModel');
    await _checkNeedUpdate();
    await _sendEvent();
  }

  Future<void> _checkNeedUpdate() async {
    isLoading = true;
    notifyListeners();
    final result = await _checkUpdateUseCase.getNeedUpdate();
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
                nextWidget: BottomTabView(
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
      parameters: {'screen_name': 'master_update_view'},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('MasterUpdateViewModel dispose');
  }
}
