import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '/app/view_model/check_terms_of_service_update_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class CheckTermsOfServiceUpdateView extends HookConsumerWidget {
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
      child: RouterWidget(
        key: key,
        child: LoadingOverlay(
          isLoading: viewModel.isLoading,
          color: Colors.grey,
          child: viewModel.inquireUpdate
              ? Scaffold(
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
                          const BodyMediumRegularText(
                              '利用規約とプライバシーポリシーが更新されました。'),
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
                                      checkTermsOfServiceUpdateViewModelProvider(
                                          key))
                                  .onTapAgreeButton();
                            },
                            child: const BodyMediumRegularText('同意する'),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : Scaffold(
                  body: Container(
                    color: ColorName.main,
                  ),
                ),
        ),
      ),
    );
  }
}
