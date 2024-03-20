import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/bottom_tab_view.dart';
import '/app/view/privacy_policy_view.dart';
import '/app/view/terms_of_service_view.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/need_terms_of_service_update_dto.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/check_terms_of_service_update_use_case.dart';
import '/use_case/use_case/save_terms_of_service_agree_version_use_case.dart';

final checkTermsOfServiceUpdateViewModelProvider = ChangeNotifierProvider.family
    .autoDispose<CheckTermsOfServiceUpdateViewModel, Key?>(
  (ref, key) {
    return CheckTermsOfServiceUpdateViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(checkTermsOfServiceUpdateUseCaseProvider),
      ref.watch(saveTermsOfServiceAgreeVersionUseCaseProvider),
    );
  },
);

class CheckTermsOfServiceUpdateViewModel extends ChangeNotifier {
  CheckTermsOfServiceUpdateViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._checkTermsOfServiceUpdateUseCase,
    this._saveTermsOfServiceAgreeVersionUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final CheckTermsOfServiceUpdateUseCase _checkTermsOfServiceUpdateUseCase;
  final SaveTermsOfServiceAgreeVersionUseCase
      _saveTermsOfServiceAgreeVersionUseCase;

  bool isLoading = false;
  bool inquireUpdate = false;
  bool isAgreed = false;

  Future<void> onLoad() async {
    await sendPV();
    final result = await _checkNeedUpdate();
    if (result is Failure) {
      return;
    }
    if ((result as Success<bool>).value) {
      inquireUpdate = true;
      notifyListeners();
    } else {
      await _transitionToBottomTabView();
    }
  }

  Future<void> onTapCheckBox() async {
    isAgreed = !isAgreed;
    notifyListeners();
  }

  Future<void> onTapAgreeButton() async {
    if (!isAgreed) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: '利用規約とプライバシーポリシーに同意してください',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _agreeTermsOfService();
    if (result is Failure) {
      return;
    }
    if ((result as Success<bool>).value) {
      await _transitionToBottomTabView();
    }
  }

  Future<void> onTapTermsOfService() async {
    await _transitionToTermsOfServiceView();
  }

  Future<void> onTapPrivacyPolicy() async {
    await _transitionToPrivacyPolicyView();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'check_terms_of_service_update_view',
      },
    );
  }

  Future<void> onCameBack() async {}

  Future<Result<bool>> _checkNeedUpdate() async {
    isLoading = true;
    notifyListeners();
    final result = await _checkTermsOfServiceUpdateUseCase.getNeedUpdate();
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
    final needTermsOfServiceUpdateDTO =
        (result as Success<NeedTermsOfServiceUpdateDTO>).value;
    return Result.success(needTermsOfServiceUpdateDTO.value);
  }

  Future<Result<bool>> _agreeTermsOfService() async {
    isLoading = true;
    notifyListeners();
    final result = await _saveTermsOfServiceAgreeVersionUseCase.save();
    isLoading = false;
    notifyListeners();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: '同意バージョンの保存に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {
              await _agreeTermsOfService();
            },
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return Result.failure(Exception());
    }
    return const Result.success(true);
  }

  Future<void> _transitionToTermsOfServiceView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: TermsOfServiceView(
            key: UniqueKey(),
            isTutorial: true,
          ),
        );
  }

  Future<void> _transitionToPrivacyPolicyView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: PrivacyPolicyView(
            key: UniqueKey(),
            isTutorial: true,
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
    _logger.d('CheckTermsOfServiceUpdateViewModel dispose');
  }
}
