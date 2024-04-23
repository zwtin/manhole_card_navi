import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/check_terms_of_service_update_view.dart';
import '/app/view/custom_introduction_view.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/need_master_update_dto.dart';
import '/use_case/dto/need_terms_of_service_agree_dto.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/check_master_update_use_case.dart';
import '/use_case/use_case/check_terms_of_service_agree_use_case.dart';

final checkMasterUpdateViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<CheckMasterUpdateViewModel, Key?>(
  (ref, key) {
    return CheckMasterUpdateViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(checkMasterUpdateUseCaseProvider),
      ref.watch(checkTermsOfServiceAgreeUseCaseProvider),
    );
  },
);

class CheckMasterUpdateViewModel extends ChangeNotifier {
  CheckMasterUpdateViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._checkMasterUpdateUseCase,
    this._checkTermsOfServiceAgreeUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final CheckMasterUpdateUseCase _checkMasterUpdateUseCase;
  final CheckTermsOfServiceAgreeUseCase _checkTermsOfServiceAgreeUseCase;

  bool isLoading = false;

  Future<void> onLoad() async {
    await sendPV();
    final masterResult = await _checkNeedUpdate();
    if (masterResult is Failure) {
      return;
    }
    if (!(masterResult as Success<bool>).value) {
      return;
    }
    final termsOfServiceResult = await _checkNeedAgree();
    if (termsOfServiceResult is Failure) {
      return;
    }
    if ((termsOfServiceResult as Success<bool>).value) {
      await _transitionToCustomIntroductionView();
    } else {
      await _transitionToCheckTermsOfSeerviceUpdate();
    }
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'check_master_update_view',
      },
    );
  }

  Future<void> onCameBack() async {}

  Future<Result<bool>> _checkNeedUpdate() async {
    isLoading = true;
    notifyListeners();
    final getNeedMasterUpdateResult =
        await _checkMasterUpdateUseCase.getNeedUpdate();
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
      return Result.failure(Exception());
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
        return Result.failure(Exception());
      }
    }
    return const Result.success(true);
  }

  Future<Result<bool>> _checkNeedAgree() async {
    isLoading = true;
    notifyListeners();
    final getNeedAgreeResult =
        await _checkTermsOfServiceAgreeUseCase.getNeedAgree();
    isLoading = false;
    notifyListeners();
    if (getNeedAgreeResult is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: '利用規約の同意が確認できませんでした',
            okButtonTitle: 'OK',
            okButtonAction: () async {
              await _checkNeedAgree();
            },
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return Result.failure(Exception());
    }
    final needTermsOfServiceAgreeDTO =
        (getNeedAgreeResult as Success<NeedTermsOfServiceAgreeDTO>).value;
    return Result.success(needTermsOfServiceAgreeDTO.value);
  }

  Future<void> _transitionToCustomIntroductionView() async {
    await _ref.read(routerProvider(_key).notifier).pushReplacement(
          nextWidget: CustomIntroductionView(
            key: UniqueKey(),
            isTutorial: true,
          ),
        );
  }

  Future<void> _transitionToCheckTermsOfSeerviceUpdate() async {
    await _ref.read(routerProvider(_key).notifier).pushReplacement(
          nextWidget: CheckTermsOfServiceUpdateView(
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
