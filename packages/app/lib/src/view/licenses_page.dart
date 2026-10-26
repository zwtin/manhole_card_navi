import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/gen/assets.gen.dart';
import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/view_data/licenses_view_data.dart';
import 'package:app/src/view_model/licenses_view_model.dart';
import 'package:app/src/widget/app_bar_title.dart';

/// Flutter 標準の [LicensePage] を、アプリの見た目で包む。
class LicensesPage extends HookConsumerWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
        ref.watch(licensesViewModelProvider).valueOrNull ??
        const LicensesViewData();
    final viewModel = ref.read(licensesViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Theme(
      // Flutter の LicensePage は行の色を listTileTheme から取る。アプリの
      // 既定（カードの面）ではなく画面の地に合わせたいので、ここだけ差し替える。
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(
          context,
        ).appBarTheme.copyWith(titleTextStyle: AppBarTitle.styleOf(context)),
        listTileTheme: Theme.of(context).listTileTheme.copyWith(
          tileColor: Theme.of(context).colorScheme.surface,
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
