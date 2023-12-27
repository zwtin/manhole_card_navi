import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '/app/provider/alert_provider.dart';
import '/app/widget/custom_text.dart';

class AlertWidget extends HookConsumerWidget {
  const AlertWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      alertProvider,
      (previous, next) async {
        if (previous != null && next == null) {
          Navigator.of(context).pop();
          return;
        }

        if (previous == null && next != null) {
          final buttons = <DialogButton>[];

          final cancelButtonViewData = next.cancelButtonViewData;
          if (cancelButtonViewData != null) {
            buttons.add(
              DialogButton(
                onPressed: () async {
                  ref.read(alertProvider.notifier).dismiss();
                  await cancelButtonViewData.action();
                },
                color: Colors.transparent,
                highlightColor: Theme.of(context).primaryColor.withOpacity(0.3),
                splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: TitleMediumText(
                  cancelButtonViewData.title,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }

          final okButtonViewData = next.okButtonViewData;
          if (okButtonViewData != null) {
            buttons.add(
              DialogButton(
                onPressed: () async {
                  ref.read(alertProvider.notifier).dismiss();
                  await okButtonViewData.action();
                },
                color: Theme.of(context).primaryColor,
                highlightColor:
                    Theme.of(context).colorScheme.surface.withOpacity(0.3),
                splashColor:
                    Theme.of(context).colorScheme.surface.withOpacity(0.3),
                child: TitleMediumText(
                  okButtonViewData.title,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            );
          }

          await Alert(
            context: context,
            title: next.title,
            desc: next.message,
            style: AlertStyle(
              backgroundColor: Theme.of(context).colorScheme.surface,
              alertBorder: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              animationType: AnimationType.grow,
              isCloseButton: false,
              isOverlayTapDismiss: false,
              overlayColor: Colors.black54,
              alertElevation: 0,
              titleStyle: Theme.of(context).textTheme.titleLarge ??
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
              descStyle: Theme.of(context).textTheme.titleMedium ??
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
            ),
            buttons: buttons,
            onWillPopActive: true,
          ).show();
        }
      },
    );
    return child;
  }
}
