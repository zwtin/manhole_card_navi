import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:manhole_card_navi/app/widget/router_widget.dart';

import '/app/view_model/start_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/gen/colors.gen.dart';

class StartView extends HookConsumerWidget {
  const StartView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(startViewModelProvider(key));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await viewModel.onLoad();
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
            body: Container(
              color: ColorName.main,
            ),
          ),
        ),
      ),
    );
  }
}
