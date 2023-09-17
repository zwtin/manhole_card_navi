import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final homeViewModelProvider = ChangeNotifierProvider.autoDispose<HomeViewModel>(
  (ref) {
    return HomeViewModel(
      ref,
    );
  },
);

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    this._ref,
  );

  final Ref _ref;
  final _logger = Logger();

  Future<void> onLoad() async {
    _logger.d('HomeViewModel');
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('HomeViewModel dispose');
  }
}
