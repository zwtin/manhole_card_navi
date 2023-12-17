import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/router_provider.dart';
import '/app/view_data/router_view_data.dart';
import '/app/widget/fade_in_route.dart';

class RouterWidget extends HookConsumerWidget {
  const RouterWidget({
    super.key,
    required this.child,
    this.pop,
  });

  final Widget child;
  final void Function()? pop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      routerProvider(key),
      (
        previous,
        next,
      ) async {
        switch (next?.type) {
          case TransitionType.push:
            if (!context.mounted) {
              break;
            }
            await Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                builder: (context) {
                  return next?.nextWidget ?? Container();
                },
              ),
            );
            break;
          case TransitionType.pushReplacement:
            if (!context.mounted) {
              break;
            }
            await Navigator.of(context).pushReplacement(
              PageRouteBuilder<Widget>(
                pageBuilder: (
                  newContext,
                  animation1,
                  animation2,
                ) {
                  return next?.nextWidget ?? Container();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case TransitionType.present:
            if (!context.mounted) {
              break;
            }
            await Navigator.of(
              context,
              rootNavigator: true,
            ).push(
              MaterialPageRoute<Widget>(
                builder: (context) {
                  return next?.nextWidget ?? Container();
                },
                fullscreenDialog: true,
              ),
            );
            break;
          case TransitionType.image:
            if (!context.mounted) {
              break;
            }
            await Navigator.of(context, rootNavigator: true).push(
              FadeInRoute(
                widget: next?.nextWidget ?? Container(),
                onTransitionCompleted: null,
                onTransitionDismissed: null,
              ),
            );
            break;
          case TransitionType.pop:
            if (!context.mounted) {
              break;
            }
            if (pop != null) {
              pop!();
            } else {
              Navigator.of(context).pop();
            }
            break;
          case TransitionType.popToRoot:
            if (!context.mounted) {
              break;
            }
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          default:
            break;
        }
      },
    );
    return child;
  }
}
