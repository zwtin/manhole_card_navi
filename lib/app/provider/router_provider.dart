import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_data/router_view_data.dart';

final routerProvider = StateNotifierProvider.family
    .autoDispose<RouterNotifier, RouterViewData?, Key?>(
  (ref, key) {
    return RouterNotifier();
  },
);

class RouterNotifier extends StateNotifier<RouterViewData?> {
  RouterNotifier() : super(null);

  Future<void> push({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.push,
      nextWidget: nextWidget,
    );
  }

  Future<void> pushReplacement({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.pushReplacement,
      nextWidget: nextWidget,
    );
  }

  Future<void> present({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.present,
      nextWidget: nextWidget,
    );
  }

  Future<void> pop() async {
    state = const RouterViewData(
      type: TransitionType.pop,
    );
  }

  Future<void> popToRoot() async {
    state = const RouterViewData(
      type: TransitionType.popToRoot,
    );
  }

  void dismiss() {
    state = null;
  }
}
