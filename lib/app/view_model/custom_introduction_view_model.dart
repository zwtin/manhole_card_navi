import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/pv_sender_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view/check_terms_of_service_agree_view.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/use_case/use_case/analytics_use_case.dart';

final customIntroductionViewModelProvider = ChangeNotifierProvider.family
    .autoDispose<CustomIntroductionViewModel, Key?>(
  (ref, key) {
    return CustomIntroductionViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
    );
  },
);

class CustomIntroductionViewModel extends ChangeNotifier {
  CustomIntroductionViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;

  bool _isTutorial = false;

  Future<void> onLoad(
    bool isTutorial,
  ) async {
    _isTutorial = isTutorial;
    await onCameBack();
  }

  Future<void> onDone() async {
    if (_isTutorial) {
      await _transitionToCheckTermsOfServiceAgreeView();
    } else {
      await _transitionToPreviousView();
    }
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'custom_introduction_view',
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

  Future<void> _transitionToCheckTermsOfServiceAgreeView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: CheckTermsOfServiceAgreeView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> _transitionToPreviousView() async {
    await _ref.read(routerProvider(_key).notifier).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('CustomIntroductionViewModel dispose');
  }
}
