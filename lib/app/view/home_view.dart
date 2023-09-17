import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/router_provider.dart';
import '/app/view_data/router_view_data.dart';
import '/app/view_model/home_view_model.dart';
import '/gen/colors.gen.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

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
            if (next?.bottomTabIndex == 0) {
              await Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (newContext) {
                    return next?.nextWidget ?? Container();
                  },
                ),
              );
            }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ホーム',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorName.main,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white24,
            height: 1,
          ),
        ), // 影をなくす
      ),
      body: Container(
        color: ColorName.main,
      ),
    );
  }
}
