import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/view/bottom_tab_view.dart';
import '/domain/entity/result.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/save_terms_of_service_agree_version_use_case.dart';

final checkTermsOfServiceAgreeViewModelProvider = ChangeNotifierProvider.family
    .autoDispose<CheckTermsOfServiceAgreeViewModel, Key?>(
  (ref, key) {
    return CheckTermsOfServiceAgreeViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(saveTermsOfServiceAgreeVersionUseCaseProvider),
    );
  },
);

class CheckTermsOfServiceAgreeViewModel extends ChangeNotifier {
  CheckTermsOfServiceAgreeViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._saveTermsOfServiceAgreeVersionUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final SaveTermsOfServiceAgreeVersionUseCase
      _saveTermsOfServiceAgreeVersionUseCase;

  bool isLoading = false;

  Future<void> onLoad() async {
    _logger.d('CheckTermsOfServiceAgreeViewModel');
    await _sendPVEvent();
  }

  Future<void> onTapAgreeButton() async {
    final result = await _agreeTermsOfService();
    if (result is Failure) {
      return;
    }
    if ((result as Success<bool>).value) {
      await _transitionToBottomTabView();
    }
  }

  Future<void> _sendPVEvent() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {'screen_name': 'check_app_update_view'},
    );
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
    _logger.d('CheckTermsOfServiceAgreeViewModel dispose');
  }
}
