import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '/app/view_model/check_app_update_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class CheckAppUpdateView extends CommonWidget {
  const CheckAppUpdateView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(checkAppUpdateViewModelProvider(key));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(checkAppUpdateViewModelProvider(key)).onLoad();
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
            child: Scaffold(
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
    await ref.read(checkAppUpdateViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(checkAppUpdateViewModelProvider(key)).onCameBack();
  }
}
