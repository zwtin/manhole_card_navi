import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app_use_case.dart';
import '/use_case/use_case/analytics_use_case.dart';

final appViewModelProvider = Provider.autoDispose<AppViewModel>(
  (ref) {
    return AppViewModel(
      ref,
      ref.watch(analyticsUseCaseProvider),
      ref.watch(appUseCaseProvider),
    );
  },
);

class AppViewModel extends ChangeNotifier {
  AppViewModel(
    this._ref,
    this._analyticsUseCase,
    this._appUseCase,
  );

  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;
  final AppUseCase _appUseCase;

  Future<void> onLoad() async {
    await _analyticsUseCase.sendOpen();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('AppViewModel dispose');
  }
}
