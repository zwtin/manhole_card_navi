import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/router_provider.dart';
import '/app/view/check_terms_of_service_agree_view.dart';

final customIntroductionViewModelProvider = ChangeNotifierProvider.family
    .autoDispose<CustomIntroductionViewModel, Key?>(
  (ref, key) {
    return CustomIntroductionViewModel(
      key,
      ref,
    );
  },
);

class CustomIntroductionViewModel extends ChangeNotifier {
  CustomIntroductionViewModel(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  Future<void> onLoad() async {
    _logger.d('CustomIntroductionViewModel');
  }

  Future<void> onDone() async {
    await _ref.read(routerProvider(_key).notifier).push(
          nextWidget: CheckTermsOfServiceAgreeView(
            key: UniqueKey(),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('CustomIntroductionViewModel dispose');
  }
}
