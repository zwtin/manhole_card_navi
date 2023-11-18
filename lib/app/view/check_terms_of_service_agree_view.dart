import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '/app/view_model/check_terms_of_service_agree_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

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
          color: Colors.grey,
          child: Scaffold(
            appBar: AppBar(
              title: const TitleLargeBoldText(
                '同意確認',
              ),
            ),
            body: Stack(
              children: [
                Container(
                  color: ColorName.main,
                ),
                Column(
                  children: [
                    const BodyMediumRegularText('利用規約とプライバシーポリシーに同意する必要があります。'),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                      ),
                      onPressed: () async {
                        await ref
                            .read(
                                checkTermsOfServiceAgreeViewModelProvider(key))
                            .onTapAgreeButton();
                      },
                      child: const BodyMediumRegularText('同意する'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
