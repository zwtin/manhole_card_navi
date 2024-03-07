import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/privacy_policy_dto.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/privacy_policy_use_case.dart';

final privacyPolicyViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<PrivacyPolicyViewModel, Key?>(
  (ref, key) {
    return PrivacyPolicyViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(privacyPolicyUseCaseProvider),
    );
  },
);

class PrivacyPolicyViewModel extends ChangeNotifier {
  PrivacyPolicyViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._privacyPolicyUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final PrivacyPolicyUseCase _privacyPolicyUseCase;

  String html = '';

  Future<void> onLoad() async {
    await _fetchPrivacyPolicy();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {'name': 'privacy_policy_view'},
    );
  }

  Future<void> _fetchPrivacyPolicy() async {
    final result = await _privacyPolicyUseCase.get();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'プライバシーポリシーの取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
    }
    final privacyPolicyDTO = (result as Success<PrivacyPolicyDTO>).value;
    html = privacyPolicyDTO.value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('PrivacyPolicyViewModel dispose');
  }
}
