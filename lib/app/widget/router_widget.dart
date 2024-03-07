import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/router_provider.dart';
import '/app/view_data/router_view_data.dart';
import '/app/widget/custom_route.dart';
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
      ) {
        switch (next?.type) {
          case TransitionType.push:
            final nextWidget = next?.nextWidget;
            if (nextWidget == null) {
              break;
            }
            Navigator.of(context).push(
              CustomMaterialPageRoute(
                result: nextWidget,
                builder: (context) {
                  return nextWidget;
                },
              ),
            );
            break;
          case TransitionType.pushReplacement:
            final nextWidget = next?.nextWidget;
            if (nextWidget == null) {
              break;
            }
            Navigator.of(context).pushReplacement(
              CustomPageRouteBuilder(
                result: nextWidget,
                pageBuilder: (
                  newContext,
                  animation1,
                  animation2,
                ) {
                  return nextWidget;
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case TransitionType.present:
            final nextWidget = next?.nextWidget;
            if (nextWidget == null) {
              break;
            }
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(
              CustomMaterialPageRoute(
                result: nextWidget,
                builder: (context) {
                  return nextWidget;
                },
                fullscreenDialog: true,
              ),
            );
            break;
          case TransitionType.image:
            final nextWidget = next?.nextWidget;
            if (nextWidget == null) {
              break;
            }
            Navigator.of(context, rootNavigator: true).push(
              FadeInRoute(
                widget: nextWidget,
                onTransitionCompleted: null,
                onTransitionDismissed: null,
              ),
            );
            break;
          case TransitionType.pop:
            if (pop != null) {
              pop!();
            } else {
              Navigator.of(context).pop();
            }
            break;
          case TransitionType.popToRoot:
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
