import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/router_provider.dart';
import '/app/view_data/router_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/widget/alert_widget.dart';

class BottomTabView extends HookConsumerWidget {
  const BottomTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bottomTabViewModelProvider);
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

    ref.listen(
      routerProvider,
      (previous, next) async {
        switch (next?.type) {
          case TransitionType.push:
            if (next?.bottomTabIndex == null) {
              await Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (newContext) {
                    return next?.nextWidget ?? Container();
                  },
                ),
              );
            }
            break;
          case TransitionType.present:
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<Widget>(
                builder: (newContext) {
                  return next?.nextWidget ?? Container();
                },
                fullscreenDialog: true,
              ),
            );
            break;
          case TransitionType.pop:
            Navigator.of(context).pop();
            break;
          case TransitionType.popToRoot:
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          default:
            break;
        }
      },
    );

    return AlertWidget(
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.black87,
          activeColor: const Color(0xFFFFCC00),
          controller: controller,
          initialActiveIndex: viewModel.selectedIndex,
          onTap: (index) {
            ref.read(bottomTabViewModelProvider).onTap(index);
          },
          items: const [
            TabItem<IconData>(
              icon: Icons.home,
              title: 'ホーム',
            ),
            TabItem<IconData>(
              icon: Icons.person,
              title: 'マイページ',
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
                    return Container();
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
                    return Container();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
