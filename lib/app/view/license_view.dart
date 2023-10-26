import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/license_view_model.dart';
import '/app/widget/router_widget.dart';

class LicenseView extends HookConsumerWidget {
  const LicenseView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(licenseViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(licenseViewModelProvider(key)).onLoad();
          },
        );
        return null;
      },
      const [],
    );

    return RouterWidget(
      key: key,
      child: LicensePage(
        applicationName: viewModel.appName,
        applicationVersion: viewModel.appVersion,
        applicationIcon: const FlutterLogo(),
      ),
    );
  }
}
