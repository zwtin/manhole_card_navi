import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manhole_card_navi/pages/my_home_page.dart';

import '/app/view/map_view.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/widget/alert_widget.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class BottomTabView extends HookConsumerWidget {
  BottomTabView({
    super.key,
  });

  final tab0 = MapView(
    key: UniqueKey(),
  );

  final tab1 = MyHomePage(
    key: UniqueKey(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bottomTabViewModelProvider(key));
    final controller = useTabController(initialLength: 2)
      ..index = viewModel.selectedIndex;

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await viewModel.onLoad();
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
            ],
          ),
        ),
      ),
    );
  }
}
