import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/terms_of_service_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class TermsOfServiceView extends HookConsumerWidget {
  const TermsOfServiceView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(termsOfServiceViewModelProvider(key));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(termsOfServiceViewModelProvider(key)).onLoad();
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
          title: const TitleLargeBoldText(
            '利用規約',
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: ColorName.main,
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
