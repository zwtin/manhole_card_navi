import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view/image_detail_view.dart';
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
    state = null;
  }

  Future<void> pushReplacement({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.pushReplacement,
      nextWidget: nextWidget,
    );
    state = null;
  }

  Future<void> present({
    required Widget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.present,
      nextWidget: nextWidget,
    );
    state = null;
  }

  Future<void> presentImage({
    required Uint8List imageData,
    required String imageTag,
  }) async {
    state = RouterViewData(
      type: TransitionType.image,
      nextWidget: ImageDetailView(
        imageData: imageData,
        imageTag: imageTag,
      ),
    );
    state = null;
  }

  Future<void> pop() async {
    state = const RouterViewData(
      type: TransitionType.pop,
    );
    state = null;
  }

  Future<void> popToRoot() async {
    state = const RouterViewData(
      type: TransitionType.popToRoot,
    );
    state = null;
  }

  void dismiss() {
    state = null;
  }
}
