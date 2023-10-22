import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/provider/router_provider.dart';
import 'package:manhole_card_navi/app/view/terms_of_service_view.dart';

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

  Future<void> onTapTermsOfService() async {
    await _transitionToTermsOfServiceView();
  }

  Future<void> _transitionToTermsOfServiceView() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: TermsOfServiceView(
            key: UniqueKey(),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('SettingViewModel dispose');
  }
}
