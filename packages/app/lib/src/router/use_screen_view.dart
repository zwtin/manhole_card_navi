import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'current_route.dart';

/// この画面が最前面になるたびに [onVisible] を呼ぶ（PV の送信に使う）。
///
/// 最前面になる契機は、表示されたとき・上に積んだ画面から戻ったとき・タブを
/// 切り替えて戻ってきたときの 3 つ。タブを先読みして裏で build されただけの画面や、
/// アラートを閉じたときには呼ばない。
void useScreenView(WidgetRef ref, VoidCallback onVisible) {
  final pageKey = GoRouterState.of(useContext()).pageKey;
  final latestOnVisible = useRef(onVisible)..value = onVisible;

  useEffect(
    () {
      final subscription = ref.listenManual<ValueKey<String>?>(
        currentRouteProvider.select((route) => route?.pageKey),
        (previous, next) {
          if (next != pageKey || previous == pageKey) {
            return;
          }
          // 描画を終えてから呼ぶ。初回は build 中に呼ばれるうえ、別のカードの
          // モーダルへ go したときは Page が使い回され、画面が新しい引数で build
          // し直されるまで onVisible が前のカードの ViewModel を指しているため。
          WidgetsBinding.instance
            ..addPostFrameCallback((_) => latestOnVisible.value())
            ..ensureVisualUpdate();
        },
        fireImmediately: true,
      );
      return subscription.close;
    },
    [pageKey],
  );
}
