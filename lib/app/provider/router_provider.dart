import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view/image_detail_view.dart';
import '/app/view_data/router_view_data.dart';
import '/app/widget/common_widget.dart';

final routerProvider = StateNotifierProvider.family
    .autoDispose<RouterNotifier, RouterViewData, Key?>(
  (ref, key) {
    return RouterNotifier();
  },
);

class RouterNotifier extends StateNotifier<RouterViewData> {
  RouterNotifier()
      : super(
          const RouterViewData(
            type: TransitionType.init,
          ),
        );

  Future<void> push({
    required CommonWidget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.push,
      nextWidget: nextWidget,
    );
  }

  Future<void> pushReplacement({
    required CommonWidget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.pushReplacement,
      nextWidget: nextWidget,
    );
  }

  Future<void> present({
    required CommonWidget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.present,
      nextWidget: nextWidget,
    );
  }

  Future<void> presentModal({
    required CommonWidget nextWidget,
  }) async {
    state = RouterViewData(
      type: TransitionType.modal,
      nextWidget: nextWidget,
    );
  }

  Future<void> presentImage({
    required String cardId,
    required String imageUrl,
    required String imageTag,
  }) async {
    state = RouterViewData(
      type: TransitionType.image,
      nextWidget: ImageDetailView(
        cardId: cardId,
        imageUrl: imageUrl,
        imageTag: imageTag,
      ),
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
}
