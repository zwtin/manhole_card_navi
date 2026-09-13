import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../gen/assets.gen.dart';
import '../router/use_screen_view.dart';
import '../view_data/licenses_view_data.dart';
import '../view_model/licenses_view_model.dart';

/// ライセンス画面。Flutter 標準の [LicensePage] をアプリの配色で包む。
class LicensesPage extends HookConsumerWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(licensesViewModelProvider).valueOrNull ??
        const LicensesViewData();
    final viewModel = ref.read(licensesViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: Theme.of(context).colorScheme.background,
        listTileTheme: Theme.of(context).listTileTheme.copyWith(
              tileColor: Theme.of(context).colorScheme.background,
            ),
      ),
      child: LicensePage(
        applicationName: state.appName,
        applicationVersion: state.appVersion,
        applicationIcon: SizedBox(
          width: 48,
          height: 48,
          child: Assets.images.license.icon.image(),
        ),
      ),
    );
  }
}
