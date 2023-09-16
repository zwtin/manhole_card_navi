import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '/app/provider/router_provider.dart';
import '/app/view_data/router_view_data.dart';
import '/app/view_model/start_view_model.dart';
import '/app/widget/alert_widget.dart';

class StartView extends HookConsumerWidget {
  const StartView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(startViewModelProvider);
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

    ref.listen(
      routerProvider,
      (previous, next) async {
        switch (next?.type) {
          case TransitionType.pushReplacement:
            if (!context.mounted) {
              return;
            }
            await Navigator.of(context).pushReplacement(
              PageRouteBuilder<Widget>(
                pageBuilder: (newContext, animation1, animation2) {
                  return next?.nextWidget ?? Container();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case TransitionType.pop:
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).pop();
            break;
          case TransitionType.popToRoot:
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          default:
            break;
        }
      },
    );

    return AlertWidget(
      child: LoadingOverlay(
        isLoading: viewModel.isLoading,
        color: Colors.grey,
        child: Scaffold(
          body: Container(
            color: const Color(0xFFFFCC00),
          ),
        ),
      ),
    );
  }
}
