import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app_use_case.dart';

final appViewModelProvider = Provider.autoDispose<AppViewModel>(
  (ref) {
    return AppViewModel(
      ref,
      ref.watch(appUseCaseProvider),
    );
  },
);

class AppViewModel {
  AppViewModel(
    this._ref,
    this._appUseCase,
  );

  final Ref _ref;
  final _logger = Logger();

  final AppUseCase _appUseCase;

  Future<void> onLoad() async {
    _logger.d('AppViewModel');
  }
}
