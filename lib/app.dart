import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manhole_card_navi/gen/colors.gen.dart';

import '/app/view/check_app_update_view.dart';
import '/app_view_model.dart';

class App extends HookConsumerWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(appViewModelProvider).onLoad();
          },
        );
        return null;
      },
      const [],
    );

    useOnAppLifecycleStateChange(
      (previous, current) async {
        switch (current) {
          case AppLifecycleState.detached:
            break;
          case AppLifecycleState.resumed:
            break;
          case AppLifecycleState.inactive:
            break;
          case AppLifecycleState.hidden:
            break;
          case AppLifecycleState.paused:
            break;
        }
      },
    );

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: ColorName.main,
          elevation: 0,
          shape: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
        ),
        cardColor: ColorName.main,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: CheckAppUpdateView(
        key: UniqueKey(),
      ),
    );
  }
}
