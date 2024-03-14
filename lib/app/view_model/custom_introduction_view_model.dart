import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/router_provider.dart';
import '/app/view/check_terms_of_service_agree_view.dart';
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
    sendPV();
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
