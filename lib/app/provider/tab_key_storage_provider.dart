import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tabKeyStorageProvider = Provider<TabKeyStorage>(
  (ref) {
    return TabKeyStorage();
  },
);

class TabKeyStorage {
  Key? _bottomTabKey;
  Key? _mapKey;
  final Map<int, Key?> _tabKey = <int, Key?>{};

  void setBottomTabKey(Key? key) {
    _bottomTabKey = key;
  }

  void setMapKey(Key? key) {
    _mapKey = key;
  }

  void setTabKey(int tabIndex, Key? key) {
    _tabKey[tabIndex] = key;
  }

  Key? getBottomTabKey() {
    return _bottomTabKey;
  }

  Key? getMapKey() {
    return _mapKey;
  }

  Key? getTabKey(int tabIndex) {
    return _tabKey[tabIndex];
  }
}
