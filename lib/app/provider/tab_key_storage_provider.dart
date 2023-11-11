import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tabKeyStorageProvider = Provider<TabKeyStorage>(
  (ref) {
    return TabKeyStorage();
  },
);

class TabKeyStorage {
  Key? _bottomTabKey;
  final Map<int, Key?> _tabKey = <int, Key?>{};

  void setBottomTabKey(Key? key) {
    _bottomTabKey = key;
  }

  void setTabKey(int tabIndex, Key? key) {
    _tabKey[tabIndex] = key;
  }

  Key? getBottomTabKey() {
    return _bottomTabKey;
  }

  Key? getTabKey(int tabIndex) {
    return _tabKey[tabIndex];
  }
}
