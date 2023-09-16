import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_data/router_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';

final routerProvider =
    StateNotifierProvider.autoDispose<RouterNotifier, RouterViewData?>(
  (ref) {
    return RouterNotifier(ref);
  },
);

class RouterNotifier extends StateNotifier<RouterViewData?> {
  RouterNotifier(this._ref) : super(null);

  final Ref _ref;

  Future<void> push({
    required Widget nextWidget,
  }) async {
    final bottomTabIndex = _ref.read(bottomTabViewModelProvider).selectedIndex;
    state = RouterViewData(
      type: TransitionType.push,
      bottomTabIndex: bottomTabIndex,
      nextWidget: nextWidget,
    );
  }

  Future<void> pushReplacement({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.pushReplacement,
      bottomTabIndex: null,
      nextWidget: nextWidget,
    );
  }

  Future<void> pushRoot({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.push,
      bottomTabIndex: null,
      nextWidget: nextWidget,
    );
  }

  Future<void> present({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.present,
      bottomTabIndex: null,
      nextWidget: nextWidget,
    );
  }

  Future<void> pop() async {
    state = const RouterViewData(
      type: TransitionType.pop,
      bottomTabIndex: null,
    );
  }

  Future<void> popToRoot() async {
    state = const RouterViewData(
      type: TransitionType.popToRoot,
      bottomTabIndex: null,
    );
  }

  void dismiss() {
    state = null;
  }
}
