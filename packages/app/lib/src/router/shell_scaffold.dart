import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../view_model/shell_view_model.dart';

/// 下タブ（マップ・リスト・設定）のシェル。
///
/// - GoRouter の StatefulNavigationShell を包み、ConvexAppBar で装飾する
/// - 表示中のタブを再タップしたら、そのタブを先頭まで戻す
/// - カードを取得済みにしたら、クラッカーのアニメーションを重ねて流す
class ShellScaffold extends HookConsumerWidget {
  const ShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(shellViewModelProvider);
    final tabController = useTabController(
      initialLength: 3,
      initialIndex: navigationShell.currentIndex,
    );
    // カード詳細の「マップで見る」などでタブが切り替わったときに下タブの表示を合わせる。
    tabController.index = navigationShell.currentIndex;
    final animationController = useAnimationController();

    useEffect(
      () {
        void onStatusChanged(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animationController.reset();
          }
        }

        animationController.addStatusListener(onStatusChanged);
        return () => animationController.removeStatusListener(onStatusChanged);
      },
      [animationController],
    );

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await ref.read(shellViewModelProvider.notifier).onLoad();
        });
        return null;
      },
      const [],
    );

    ref.listen(
      shellViewModelProvider.select((state) => state.partyCount),
      (previous, next) {
        if (previous == null ||
            next <= previous ||
            animationController.isAnimating) {
          return;
        }
        animationController.forward(from: 0);
      },
    );

    return PopScope(
      // タブのルートで戻る操作をしたときの挙動をここで決める。タブ内に積んだ画面が
      // あれば GoRouter が先にそちらを閉じるので、ここに来るのはタブのルートだけ。
      // マップタブならアプリを閉じ、それ以外のタブならマップタブへ切り替える。
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (navigationShell.currentIndex == 0) {
          SystemNavigator.pop();
        } else {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
          color: Theme.of(context).iconTheme.color,
          backgroundColor: Theme.of(context).colorScheme.surface,
          activeColor: Theme.of(context).primaryColor,
          controller: tabController,
          initialActiveIndex: navigationShell.currentIndex,
          onTap: (index) {
            // 表示中のタブを再タップした場合はそのタブを先頭まで戻す。
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          items: const [
            TabItem<IconData>(
              icon: Icons.map_outlined,
              title: 'マップ',
            ),
            TabItem<IconData>(
              icon: Icons.list_alt,
              title: 'リスト',
            ),
            TabItem<IconData>(
              icon: Icons.settings,
              title: '設定',
            ),
          ],
        ),
        body: Stack(
          children: [
            navigationShell,
            LayoutBuilder(
              builder: (context, constraints) {
                final bodyHeight = constraints.maxHeight -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top;
                return Stack(
                  children: [
                    Positioned(
                      right: -(bodyHeight - MediaQuery.of(context).size.width) /
                          2.0,
                      bottom: 0.0,
                      child: IgnorePointer(
                        child: Lottie.asset(
                          'assets/lotties/party.json',
                          package: 'app',
                          controller: animationController,
                          onLoaded: (composition) {
                            animationController.duration =
                                composition.duration ~/ 4 * 3;
                          },
                          height: bodyHeight,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
