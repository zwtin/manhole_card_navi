import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/bottom_tab_view.dart';
import '/app/view/custom_introduction_view.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/is_first_open_dto.dart';
import '/use_case/dto/need_master_update_dto.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/check_master_update_use_case.dart';
import '/use_case/use_case/is_first_open_use_case.dart';

final checkMasterUpdateViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<CheckMasterUpdateViewModel, Key?>(
  (ref, key) {
    return CheckMasterUpdateViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(checkMasterUpdateUseCaseProvider),
      ref.watch(isFirstOpenUseCaseProvider),
    );
  },
);

class CheckMasterUpdateViewModel extends ChangeNotifier {
  CheckMasterUpdateViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._checkMasterUpdateUseCase,
    this._isFirstOpenUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final CheckMasterUpdateUseCase _checkMasterUpdateUseCase;
  final IsFirstOpenUseCase _isFirstOpenUseCase;

  bool isLoading = false;

  Future<void> onLoad() async {
    _logger.d('CheckMasterUpdateViewModel');
    await _sendPVEvent();
    await _checkNeedUpdate();
    await _checkFirstOpen();
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
    final needMasterUpdateDTO =
        (getNeedMasterUpdateResult as Success<NeedMasterUpdateDTO>).value;
    if (needMasterUpdateDTO.value) {
      isLoading = true;
      notifyListeners();
      final updateMasterResult = await _checkMasterUpdateUseCase.updateMaster();
      isLoading = false;
      notifyListeners();
      if (updateMasterResult is Failure) {
        _ref.read(alertProvider.notifier).show(
              title: 'エラー',
              message: 'マスターデータの更新に失敗しました',
              okButtonTitle: 'OK',
              okButtonAction: () async {
                await _checkNeedUpdate();
              },
              cancelButtonTitle: null,
              cancelButtonAction: null,
            );
        return;
      }
    }
  }

  Future<void> _sendPVEvent() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {'screen_name': 'check_master_update_view'},
    );
  }

  Future<void> _checkFirstOpen() async {
    final isFirstOpenResult = await _isFirstOpenUseCase.get();
    if (isFirstOpenResult is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: '起動フラグの確認に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dto = (isFirstOpenResult as Success<IsFirstOpenDTO>).value;
    if (dto.value) {
      await _transitionToCustomIntroductionView();
    } else {
      await _transitionToBottomTabView();
    }
  }

  Future<void> _transitionToCustomIntroductionView() async {
    await _ref.read(routerProvider(_key).notifier).pushReplacement(
          nextWidget: CustomIntroductionView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> _transitionToBottomTabView() async {
    await _ref.read(routerProvider(_key).notifier).pushReplacement(
          nextWidget: BottomTabView(
            key: UniqueKey(),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('CheckMasterUpdateViewModel dispose');
  }
}
