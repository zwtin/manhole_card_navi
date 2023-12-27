import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/privacy_policy_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';

class PrivacyPolicyView extends HookConsumerWidget {
  const PrivacyPolicyView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(privacyPolicyViewModelProvider(key));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(privacyPolicyViewModelProvider(key)).onLoad();
          },
        );
        return null;
      },
      const [],
    );

    return RouterWidget(
      key: key,
      child: Scaffold(
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
                  data: viewModel.html,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
