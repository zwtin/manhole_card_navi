import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '/app/view_model/check_terms_of_service_update_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_check_box.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';
import '/gen/assets.gen.dart';

class CheckTermsOfServiceUpdateView extends CommonWidget {
  const CheckTermsOfServiceUpdateView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.watch(checkTermsOfServiceUpdateViewModelProvider(key));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref
                .read(checkTermsOfServiceUpdateViewModelProvider(key))
                .onLoad();
          },
        );
        return null;
      },
      const [],
    );

    return AlertWidget(
      child: PVSenderWidget(
        key: key,
        parent: this,
        child: RouterWidget(
          key: key,
          parent: this,
          child: LoadingOverlay(
            isLoading: viewModel.isLoading,
            color: Theme.of(context).colorScheme.background,
            child: viewModel.inquireUpdate
                ? Scaffold(
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
                                  '利用規約とプライバシーポリシーが更新されました。\nアプリを使うためには、再度利用規約とプライバシーポリシーに同意する必要があります。',
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                Assets.images.terms
                                    .image(width: 300, height: 300),
                                const Spacer(
                                  flex: 2,
                                ),
                                Row(
                                  children: [
                                    CustomCheckBox(
                                      value: viewModel.isAgreed,
                                      onChanged: (value) async {
                                        await ref
                                            .read(
                                                checkTermsOfServiceUpdateViewModelProvider(
                                                    key))
                                            .onTapCheckBox();
                                      },
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(
                                                        checkTermsOfServiceUpdateViewModelProvider(
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
                                                        checkTermsOfServiceUpdateViewModelProvider(
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
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await ref
                                          .read(
                                              checkTermsOfServiceUpdateViewModelProvider(
                                                  key))
                                          .onTapAgreeButton();
                                    },
                                    child: TitleMediumText(
                                      'はじめる',
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Scaffold(
                    body: Container(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(checkTermsOfServiceUpdateViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref
        .read(checkTermsOfServiceUpdateViewModelProvider(key))
        .onCameBack();
  }
}
