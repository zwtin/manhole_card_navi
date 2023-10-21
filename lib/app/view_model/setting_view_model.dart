import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final settingViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<SettingViewModel, Key?>(
  (ref, key) {
    return SettingViewModel(
      key,
      ref,
    );
  },
);

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  Future<void> onLoad() async {
    _logger.d('SettingViewModel');
  }

  Future<void> onTap() async {
    _logger.d('SettingViewModel');
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('SettingViewModel dispose');
  }
}
