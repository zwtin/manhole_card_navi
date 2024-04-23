import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/router_provider.dart';
import '/app/view_data/router_view_data.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/fade_in_route.dart';

class RouterWidget<T extends CommonWidget> extends HookConsumerWidget {
  const RouterWidget({
    super.key,
    required this.child,
    required this.parent,
    this.pop,
  });

  final Widget child;
  final T parent;
  final void Function()? pop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      routerProvider(key),
      (
        previous,
        next,
      ) async {
        switch (next.type) {
          case TransitionType.push:
            final nextWidget = next.nextWidget;
            if (nextWidget == null) {
              break;
            }
            if (!context.mounted) break;
            final result = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (context) {
                  return nextWidget;
                },
              ),
            );
            if (!context.mounted) break;
            if (result != null && !result) break;
            final currentWidget = context.findAncestorWidgetOfExactType<T>();
            await currentWidget?.onCameBack(ref);
            break;
          case TransitionType.pushReplacement:
            final nextWidget = next.nextWidget;
            if (nextWidget == null) {
              break;
            }
            if (!context.mounted) break;
            final result = await Navigator.of(context).pushReplacement(
              PageRouteBuilder(
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
              result: false,
            );
            break;
          case TransitionType.present:
            final nextWidget = next.nextWidget;
            if (nextWidget == null) {
              break;
            }
            if (!context.mounted) break;
            final result = await Navigator.of(
              context,
              rootNavigator: true,
            ).push(
              MaterialPageRoute(
                builder: (context) {
                  return nextWidget;
                },
                fullscreenDialog: true,
              ),
            );
            if (!context.mounted) break;
            final currentWidget = context.findAncestorWidgetOfExactType<T>();
            await currentWidget?.onCameBack(ref);
            break;
          case TransitionType.modal:
            final nextWidget = next.nextWidget;
            if (nextWidget == null) {
              break;
            }
            if (!context.mounted) break;
            final result = await Navigator.of(context).push(
              ModalBottomSheetRoute(
                builder: (context) {
                  return nextWidget;
                },
                isScrollControlled: true,
              ),
            );
            if (!context.mounted) break;
            final currentWidget = context.findAncestorWidgetOfExactType<T>();
            await currentWidget?.onCameBack(ref);
            break;
          case TransitionType.image:
            final nextWidget = next.nextWidget;
            if (nextWidget == null) {
              break;
            }
            if (!context.mounted) break;
            final result = await Navigator.of(
              context,
              rootNavigator: true,
            ).push(
              FadeInRoute(
                widget: nextWidget,
                onTransitionCompleted: null,
                onTransitionDismissed: null,
              ),
            );
            if (!context.mounted) break;
            final currentWidget = context.findAncestorWidgetOfExactType<T>();
            await currentWidget?.onCameBack(ref);
            break;
          case TransitionType.pop:
            if (!context.mounted) break;
            if (pop != null) {
              pop!();
            } else {
              Navigator.of(context).pop();
            }
            break;
          case TransitionType.popToRoot:
            if (!context.mounted) break;
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
