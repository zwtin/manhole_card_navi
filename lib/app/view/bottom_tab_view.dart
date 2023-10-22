import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manhole_card_navi/app/view/setting_view.dart';

import '/app/view/manhole_card_list_view.dart';
import '/app/view/manhole_card_map_view.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class BottomTabView extends HookConsumerWidget {
  BottomTabView({
    super.key,
  });

  final tab0 = ManholeCardMapView(
    key: UniqueKey(),
  );

  final tab1 = ManholeCardListView(
    key: UniqueKey(),
  );

  final tab2 = SettingView(
    key: UniqueKey(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bottomTabViewModelProvider(key));
    final controller = useTabController(initialLength: 3)
      ..index = viewModel.selectedIndex;

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

    return AlertWidget(
      child: RouterWidget(
        key: key,
        child: Scaffold(
          bottomNavigationBar: ConvexAppBar(
            backgroundColor: ColorName.background,
            activeColor: ColorName.main,
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
          body: IndexedStack(
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
        ),
      ),
    );
  }
}
