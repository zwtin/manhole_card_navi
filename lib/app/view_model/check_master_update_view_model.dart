import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/bottom_tab_view.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/need_master_update_dto.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/check_master_update_use_case.dart';

final checkMasterUpdateViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<CheckMasterUpdateViewModel, Key?>(
  (ref, key) {
    return CheckMasterUpdateViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(checkMasterUpdateUseCaseProvider),
    );
  },
);

class CheckMasterUpdateViewModel extends ChangeNotifier {
  CheckMasterUpdateViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._checkMasterUpdateUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final CheckMasterUpdateUseCase _checkMasterUpdateUseCase;

  bool isLoading = false;

  Future<void> onLoad() async {
    _logger.d('CheckMasterUpdateViewModel');
    await _sendEvent();
    await _checkNeedUpdate();
  }

  Future<void> _checkNeedUpdate() async {
    isLoading = true;
    notifyListeners();
    final getNeedMasterUpdateResult =
        await _checkMasterUpdateUseCase.getNeedMasterUpdate();
    isLoading = false;
    notifyListeners();
    if (getNeedMasterUpdateResult is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'マスターデータのバージョンの取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {
              await _checkNeedUpdate();
            },
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dto =
        (getNeedMasterUpdateResult as Success<NeedMasterUpdateDTO>).value;
    if (dto.need) {
      _logger.d('need master update');
    }
    await _ref.read(routerProvider(_key).notifier).pushReplacement(
          nextWidget: BottomTabView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> _sendEvent() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {'screen_name': 'check_master_update_view'},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('CheckMasterUpdateViewModel dispose');
  }
}
