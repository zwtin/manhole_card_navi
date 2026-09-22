import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'app_text.dart';

/// アプリ共通のアラートを表示する。OK が押されたら true、キャンセルなら false。
///
/// [context] には root Navigator の context を渡す。[cancelButtonTitle] が null なら
/// OK ボタンだけを表示する。戻る操作やアラートの外側のタップでは閉じない。
Future<bool> showAppAlert(
  BuildContext context, {
  required String title,
  required String message,
  required String okButtonTitle,
  String? cancelButtonTitle,
}) async {
  final theme = Theme.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  final buttons = <DialogButton>[
    if (cancelButtonTitle != null)
      DialogButton(
        onPressed: () => navigator.pop(false),
        color: Colors.transparent,
        highlightColor: theme.primaryColor.withValues(alpha: 0.3),
        splashColor: theme.primaryColor.withValues(alpha: 0.3),
        border: Border.fromBorderSide(
          BorderSide(color: theme.primaryColor, width: 2),
        ),
        child: AppText.titleMedium(
          cancelButtonTitle,
          color: theme.primaryColor,
        ),
      ),
    DialogButton(
      onPressed: () => navigator.pop(true),
      color: theme.primaryColor,
      highlightColor: theme.colorScheme.surface.withValues(alpha: 0.3),
      splashColor: theme.colorScheme.surface.withValues(alpha: 0.3),
      child: AppText.titleMedium(
        okButtonTitle,
        color: theme.colorScheme.surface,
      ),
    ),
  ];

  final result =
      await Alert(
        context: context,
        title: title,
        desc: message,
        style: AlertStyle(
          backgroundColor: theme.colorScheme.surface,
          alertBorder: RoundedRectangleBorder(
            side: BorderSide(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(16),
          ),
          animationType: AnimationType.grow,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          overlayColor: Colors.black54,
          alertElevation: 0,
          // ThemeData は型スケールを必ず埋めるので、null にはならない。
          titleStyle: theme.textTheme.titleLarge!,
          descStyle: theme.textTheme.titleMedium!,
        ),
        buttons: buttons,
        onWillPopActive: true,
      ).show();
  return result ?? false;
}
