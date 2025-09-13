import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/license_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';
import '/gen/assets.gen.dart';

class LicenseView extends CommonWidget {
  const LicenseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(licenseViewModelProvider(key));

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(licenseViewModelProvider(key)).onLoad();
      });
      return null;
    }, const []);

    return PVSenderWidget(
      key: key,
      parent: this,
      child: RouterWidget(
        key: key,
        parent: this,
        child: Theme(
          data: Theme.of(context).copyWith(
            cardColor: Theme.of(context).colorScheme.background,
            listTileTheme: Theme.of(context).listTileTheme.copyWith(
              tileColor: Theme.of(context).colorScheme.background,
            ),
          ),
          child: LicensePage(
            applicationName: viewModel.appName,
            applicationVersion: viewModel.appVersion,
            applicationIcon: SizedBox(
              width: 48,
              height: 48,
              child: Assets.images.license.icon.image(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(licenseViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(licenseViewModelProvider(key)).onCameBack();
  }
}
