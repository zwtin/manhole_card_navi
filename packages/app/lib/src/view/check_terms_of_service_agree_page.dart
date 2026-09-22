import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../gen/assets.gen.dart';
import '../router/use_screen_view.dart';
import '../view_model/check_terms_of_service_agree_view_model.dart';
import '../widget/custom_check_box.dart';
import '../widget/app_text.dart';

/// 初回起動時に利用規約とプライバシーポリシーへの同意を求める画面。
class CheckTermsOfServiceAgreePage extends HookConsumerWidget {
  const CheckTermsOfServiceAgreePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkTermsOfServiceAgreeViewModelProvider);
    final viewModel = ref.read(
      checkTermsOfServiceAgreeViewModelProvider.notifier,
    );

    useScreenView(ref, viewModel.sendScreenView);

    return LoadingOverlay(
      isLoading: state.isLoading,
      color: Theme.of(context).colorScheme.surface,
      child: Scaffold(
        appBar: AppBar(
          title: const AppText.titleLarge('同意確認', fontWeight: FontWeight.bold),
        ),
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
                      'アプリを使うためには、利用規約とプライバシーポリシーに同意する必要があります。',
                    ),
                    const Spacer(flex: 1),
                    Assets.images.terms.terms.image(width: 300, height: 300),
                    const Spacer(flex: 2),
                    Row(
                      children: [
                        CustomCheckBox(
                          value: state.isAgreed,
                          onChanged: (value) => viewModel.onTapCheckBox(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: viewModel.onTapTermsOfService,
                                  child: const AppText.titleMediumLink('利用規約'),
                                ),
                                const AppText.titleMedium('と'),
                                TextButton(
                                  onPressed: viewModel.onTapPrivacyPolicy,
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
      ),
    );
  }
}
