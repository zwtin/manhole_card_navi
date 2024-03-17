import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '/app/provider/party_animation_provider.dart';
import '/app/view/manhole_card_list_view.dart';
import '/app/view/manhole_card_map_view.dart';
import '/app/view/setting_view.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class BottomTabView extends CommonWidget {
  BottomTabView({
    super.key,
  });
  final tab0Key = UniqueKey();
  final tab1Key = UniqueKey();
  final tab2Key = UniqueKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bottomTabViewModelProvider(key));
    final controller = useTabController(initialLength: 3)
      ..index = viewModel.selectedIndex;
    final animationController = useAnimationController()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ref.read(partyAnimationProvider.notifier).finish();
        }
      });
    final tab0 = ManholeCardMapView(
      key: tab0Key,
    );

    final tab1 = ManholeCardListView(
      key: tab1Key,
    );

    final tab2 = SettingView(
      key: tab2Key,
    );

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(bottomTabViewModelProvider(key)).onLoad();
          },
        );
        return null;
      },
      const [],
    );

    ref.listen(
      partyAnimationProvider,
      (previous, next) async {
        if (previous != null && next == null) {
          animationController.reset();
          return;
        }

        if (previous == null && next != null) {
          animationController.forward();
          return;
        }
      },
    );

    return AlertWidget(
      child: PVSendWidget(
        key: key,
        child: RouterWidget(
          key: key,
          parent: this,
          child: WillPopScope(
            onWillPop: () async {
              ref.read(bottomTabViewModelProvider(key)).pop();
              return false;
            },
            child: Scaffold(
              bottomNavigationBar: ConvexAppBar(
                color: Theme.of(context).iconTheme.color,
                backgroundColor: Theme.of(context).colorScheme.surface,
                activeColor: Theme.of(context).primaryColor,
                controller: controller,
                initialActiveIndex: viewModel.selectedIndex,
                onTap: (index) {
                  ref.read(bottomTabViewModelProvider(key)).onTap(index);
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
                  IndexedStack(
                    index: viewModel.selectedIndex,
                    children: <Widget>[
                      Navigator(
                        onGenerateRoute: (settings) {
                          return PageRouteBuilder<Widget>(
                            pageBuilder: (
                              context,
                              animation1,
                              animation2,
                            ) {
                              return tab0;
                            },
                          );
                        },
                      ),
                      Navigator(
                        onGenerateRoute: (settings) {
                          return PageRouteBuilder<Widget>(
                            pageBuilder: (
                              context,
                              animation1,
                              animation2,
                            ) {
                              return tab1;
                            },
                          );
                        },
                      ),
                      Navigator(
                        onGenerateRoute: (settings) {
                          return PageRouteBuilder<Widget>(
                            pageBuilder: (
                              context,
                              animation1,
                              animation2,
                            ) {
                              return tab2;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bodyHeight = constraints.maxHeight -
                          kToolbarHeight -
                          MediaQuery.of(context).padding.top;
                      return Stack(
                        children: [
                          Positioned(
                            right: -(bodyHeight -
                                    MediaQuery.of(context).size.width) /
                                2.0,
                            bottom: 0.0,
                            child: IgnorePointer(
                              child: Lottie.asset(
                                'assets/lotties/party.json',
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
          ),
        ),
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(bottomTabViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(bottomTabViewModelProvider(key)).onCameBack();
  }
}
