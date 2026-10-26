import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:app/src/gen/assets.gen.dart';
import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/view_model/check_terms_of_service_update_view_model.dart';
import 'package:app/src/widget/app_bar_title.dart';
import 'package:app/src/widget/app_text.dart';
import 'package:app/src/widget/custom_check_box.dart';

/// 起動時に利用規約の更新を確認し、更新されていれば再同意を求める画面。
class CheckTermsOfServiceUpdatePage extends HookConsumerWidget {
  const CheckTermsOfServiceUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkTermsOfServiceUpdateViewModelProvider);
    final viewModel = ref.read(
      checkTermsOfServiceUpdateViewModelProvider.notifier,
    );

    useScreenView(ref, viewModel.sendScreenView);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await viewModel.onLoad();
      });
      return null;
    }, const []);

    return LoadingOverlay(
      isLoading: state.isLoading,
      color: Theme.of(context).colorScheme.surface,
      child:
          state.inquireUpdate
              ? Scaffold(
                appBar: AppBar(title: const AppBarTitle('同意確認')),
                body: Stack(
                  children: [
                    Container(color: Theme.of(context).colorScheme.surface),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const AppText.titleMedium(
                              '利用規約とプライバシーポリシーが更新されました。\nアプリを使うためには、再度利用規約とプライバシーポリシーに同意する必要があります。',
                            ),
                            const Spacer(flex: 1),
                            Assets.images.terms.terms.image(
                              width: 300,
                              height: 300,
                            ),
                            const Spacer(flex: 2),
                            Row(
                              children: [
                                CustomCheckBox(
                                  value: state.isAgreed,
                                  onChanged:
                                      (value) => viewModel.onTapCheckBox(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed:
                                              viewModel.onTapTermsOfService,
                                          child: const AppText.titleMediumLink(
                                            '利用規約',
                                          ),
                                        ),
                                        const AppText.titleMedium('と'),
                                        TextButton(
                                          onPressed:
                                              viewModel.onTapPrivacyPolicy,
                                          child: const AppText.titleMediumLink(
                                            'プライバシーポリシー',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const AppText.titleMedium('に同意する'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: viewModel.onTapAgreeButton,
                                child: AppText.titleMedium(
                                  'はじめる',
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerLowest,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Scaffold(
                body: Container(color: Theme.of(context).colorScheme.surface),
              ),
    );
  }
}
