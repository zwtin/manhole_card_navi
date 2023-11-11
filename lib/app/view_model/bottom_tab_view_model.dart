import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<BottomTabViewModel, Key?>(
  (ref, key) {
    return BottomTabViewModel(
      key,
      ref,
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  int selectedIndex = 0;

  Future<void> onLoad() async {
    _logger.d('BottomTabViewModel');
    _ref.read(tabKeyStorageProvider).setBottomTabKey(_key);
  }

  void onTap(int index) {
    if (selectedIndex == index) {
      final tabKey = _ref.read(tabKeyStorageProvider).getTabKey(selectedIndex);
      _ref.read(routerProvider(tabKey).notifier).popToRoot();
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
