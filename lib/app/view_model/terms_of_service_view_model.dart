import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/domain/entity/result.dart';
import '/use_case/dto/terms_of_service_dto.dart';
import '/use_case/use_case/analytics_use_case.dart';
import '/use_case/use_case/terms_of_service_use_case.dart';

final termsOfServiceViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<TermsOfServiceViewModel, Key?>(
  (ref, key) {
    return TermsOfServiceViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(termsOfServiceUseCaseProvider),
    );
  },
);

class TermsOfServiceViewModel extends ChangeNotifier {
  TermsOfServiceViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
    this._termsOfServiceUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final TermsOfServiceUseCase _termsOfServiceUseCase;

  bool _isTutorial = false;
  String html = '';

  Future<void> onLoad(
    bool isTutorial,
  ) async {
    _isTutorial = isTutorial;
    await onCameBack();
    await _fetchTermsOfService();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'terms_of_service_view',
      },
    );
  }

  Future<void> onCameBack() async {
    if (_isTutorial) {
      await sendPV();
    } else {
      final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
      final selectedIndex = _ref
          .read(bottomTabViewModelProvider(bottomTabKey).notifier)
          .selectedIndex;
      _ref.read(tabKeyStorageProvider).setTabKey(selectedIndex, _key);
      _ref.read(pvSendProvider.notifier).send();
    }
  }

  Future<void> _fetchTermsOfService() async {
    final result = await _termsOfServiceUseCase.get();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: '利用規約の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
    }
    final termsOfServiceDTO = (result as Success<TermsOfServiceDTO>).value;
    html = termsOfServiceDTO.value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('TermsOfServiceViewModel dispose');
  }
}
