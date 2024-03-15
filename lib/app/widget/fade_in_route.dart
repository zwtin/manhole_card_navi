import 'package:flutter/material.dart';

class FadeInRoute extends PageRouteBuilder {
  FadeInRoute({
    required this.widget,
    required this.onTransitionCompleted,
    required this.onTransitionDismissed,
  }) : super(
          opaque: false,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            animation.addStatusListener((status) {
              if (status == AnimationStatus.completed &&
                  onTransitionCompleted != null) {
                onTransitionCompleted();
              } else if (status == AnimationStatus.dismissed &&
                  onTransitionDismissed != null) {
                onTransitionDismissed();
              }
            });

            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

  final Widget widget;
  final Function? onTransitionCompleted;
  final Function? onTransitionDismissed;
}
