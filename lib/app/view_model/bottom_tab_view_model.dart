import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/router_provider.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.autoDispose<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel(
      ref,
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this._ref,
  );

  final Ref _ref;
  final _logger = Logger();

  int selectedIndex = 0;

  Future<void> onLoad() async {
    _logger.d('BottomTabViewModel');
  }

  void onTap(int index) {
    if (selectedIndex == index) {
      _ref.read(routerProvider.notifier).popToRoot();
    } else {
      selectedIndex = index;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BottomTabViewModel dispose');
  }
}
