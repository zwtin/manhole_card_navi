import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/view_model/privacy_policy_view_model.dart';
import 'package:app/src/widget/app_bar_title.dart';

/// プライバシーポリシー。起動時の同意画面と設定タブの両方から開く。
class PrivacyPolicyPage extends HookConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final html =
        ref.watch(privacyPolicyViewModelProvider).valueOrNull?.html ?? '';
    final viewModel = ref.read(privacyPolicyViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      appBar: AppBar(title: const AppBarTitle('プライバシーポリシー')),
      body: Stack(
        children: [
          Container(color: Theme.of(context).colorScheme.surface),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: MediaQuery.paddingOf(context).left,
              bottom: MediaQuery.paddingOf(context).bottom,
              right: MediaQuery.paddingOf(context).right,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Html(data: html),
            ),
          ),
        ],
      ),
    );
  }
}
