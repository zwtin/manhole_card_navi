import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '/app/view_model/check_terms_of_service_agree_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/custom_check_box.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';

class CheckTermsOfServiceAgreeView extends HookConsumerWidget {
  const CheckTermsOfServiceAgreeView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(checkTermsOfServiceAgreeViewModelProvider(key));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref
                .read(checkTermsOfServiceAgreeViewModelProvider(key))
                .onLoad();
          },
        );
        return null;
      },
      const [],
    );

    return AlertWidget(
      child: RouterWidget(
        key: key,
        child: LoadingOverlay(
          isLoading: viewModel.isLoading,
          color: Theme.of(context).colorScheme.background,
          child: Scaffold(
            appBar: AppBar(
              title: const TitleLargeText(
                '同意確認',
                fontWeight: FontWeight.bold,
              ),
            ),
            body: Stack(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.background,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TitleMediumText(
                          'アプリを使うためには、利用規約とプライバシーポリシーに同意する必要があります。',
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            CustomCheckBox(
                              value: viewModel.isAgreed,
                              onChanged: (value) async {
                                await ref
                                    .read(
                                        checkTermsOfServiceAgreeViewModelProvider(
                                            key))
                                    .onTapCheckBox();
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(
                                                checkTermsOfServiceAgreeViewModelProvider(
                                                    key))
                                            .onTapTermsOfService();
                                      },
                                      child: const TitleMediumLinkText(
                                        '利用規約',
                                      ),
                                    ),
                                    const TitleMediumText(
                                      'と',
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(
                                                checkTermsOfServiceAgreeViewModelProvider(
                                                    key))
                                            .onTapPrivacyPolicy();
                                      },
                                      child: const TitleMediumLinkText(
                                        'プライバシーポリシー',
                                      ),
                                    ),
                                  ],
                                ),
                                const TitleMediumText(
                                  'に同意する',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .read(
                                      checkTermsOfServiceAgreeViewModelProvider(
                                          key))
                                  .onTapAgreeButton();
                            },
                            child: TitleMediumText(
                              'はじめる',
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
