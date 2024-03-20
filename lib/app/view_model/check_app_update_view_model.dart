import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/check_master_update_view.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/need_app_update_dto.dart';
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
    await sendPV();
    final result = await _checkNeedUpdate();
    if (result is Failure) {
      return;
    }
    if ((result as Success<bool>).value) {
      await _transitionToCheckMasterUpdateView();
    }
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'check_app_update_view',
      },
    );
  }

  Future<void> onCameBack() async {}

  Future<Result<bool>> _checkNeedUpdate() async {
    isLoading = true;
    notifyListeners();
    final result = await _checkAppUpdateUseCase.getNeedUpdate();
    isLoading = false;
    notifyListeners();
    if (result is Failure) {
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
      return Result.failure(Exception());
    }
    final needAppUpdateDTO = (result as Success<NeedAppUpdateDTO>).value;
    if (needAppUpdateDTO.value) {
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
      return const Result.success(false);
    }
    return const Result.success(true);
  }

  Future<void> _transitionToCheckMasterUpdateView() async {
    await _ref.read(routerProvider(_key).notifier).pushReplacement(
          nextWidget: CheckMasterUpdateView(
            key: UniqueKey(),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('CheckAppUpdateViewModel dispose');
  }
}
