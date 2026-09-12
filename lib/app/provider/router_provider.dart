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

  /// この state は保持したい「値」ではなく、一度きり実行したい「遷移命令」を表す。
  ///
  /// StateNotifier の既定の判定は !identical(old, current) だが、pop / popToRoot は
  /// nextWidget を持たない const で生成されるため 2 回目以降が同一インスタンスに
  /// 正規化され、通知されずに握り潰される。たとえばカード詳細から戻った直後に
  /// タブのルートで戻る操作をすると、2 回目の pop が無視されてタブ切り替えや
  /// アプリ終了が起きなくなる。同じ命令でも必ず通知する。
  @override
  bool updateShouldNotify(
    RouterViewData old,
    RouterViewData current,
  ) =>
      true;

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
    required String imageSubUrl,
    required bool alreadyGet,
    required String imageTag,
  }) async {
    state = RouterViewData(
      type: TransitionType.image,
      nextWidget: ImageDetailView(
        cardId: cardId,
        imageUrl: imageUrl,
        imageSubUrl: imageSubUrl,
        alreadyGet: alreadyGet,
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
