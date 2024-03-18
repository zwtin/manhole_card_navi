import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/terms_of_service_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class TermsOfServiceView extends CommonWidget {
  const TermsOfServiceView({
    super.key,
    required this.isTutorial,
  });

  final bool isTutorial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(termsOfServiceViewModelProvider(key));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref
                .read(termsOfServiceViewModelProvider(key))
                .onLoad(isTutorial);
          },
        );
        return null;
      },
      const [],
    );

    return PVSenderWidget(
      key: key,
      parent: this,
      child: RouterWidget(
        key: key,
        parent: this,
        child: Scaffold(
          appBar: AppBar(
            title: const TitleLargeText(
              '利用規約',
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
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(termsOfServiceViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(termsOfServiceViewModelProvider(key)).onCameBack();
  }
}
