import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '/app/provider/alert_provider.dart';
import '/gen/colors.gen.dart';

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
            buttons.add(DialogButton(
              onPressed: () async {
                ref.read(alertProvider.notifier).dismiss();
                await cancelButtonViewData.action();
              },
              color: ColorName.main,
              child: Text(cancelButtonViewData.title),
            ));
          }

          final okButtonViewData = next.okButtonViewData;
          if (okButtonViewData != null) {
            buttons.add(DialogButton(
              onPressed: () async {
                ref.read(alertProvider.notifier).dismiss();
                await okButtonViewData.action();
              },
              color: ColorName.main,
              child: Text(okButtonViewData.title),
            ));
          }

          await Alert(
            context: context,
            title: next.title,
            desc: next.message,
            style: const AlertStyle(
              animationType: AnimationType.grow,
              isCloseButton: false,
              isOverlayTapDismiss: false,
              overlayColor: Colors.black54,
              alertElevation: 0,
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
