import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/use_screen_view.dart';
import '../view_model/privacy_policy_view_model.dart';
import '../widget/custom_text.dart';

/// プライバシーポリシー。起動時の同意画面と設定タブの両方から開く。
class PrivacyPolicyPage extends HookConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final html = ref.watch(privacyPolicyViewModelProvider).valueOrNull ?? '';
    final viewModel = ref.read(privacyPolicyViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      appBar: AppBar(
        title: const TitleLargeText(
          'プライバシーポリシー',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).padding.left,
              bottom: MediaQuery.of(context).padding.bottom,
              right: MediaQuery.of(context).padding.right,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Html(
                data: html,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
