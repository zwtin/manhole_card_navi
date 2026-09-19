import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// アプリのルート Widget。routerProvider の GoRouter を MaterialApp.router に渡す。
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // 戻る操作は常に Flutter 側で処理すると Android へ伝える。
      //
      // 既定の実装は、ツリーを流れてきた NavigationNotification の canHandlePop を
      // そのまま SystemNavigator.setFrameworkHandlesBack へ渡す。本アプリはタブごとに
      // Navigator を持つため、タブ画面の Route (PopScope があるので true) の後に
      // タブ内 Navigator のルート Route (pop 不可なので false) の通知が届き、false で
      // 上書きされてしまう。targetSdk 35 まではこの値が無視されていたが、36 では
      // enableOnBackInvokedCallback が既定で有効になり実際に効くようになったため、
      // OS 側が戻るを処理してアプリがバックグラウンドへ送られる。
      //
      // 実際の戻る挙動は GoRouter とタブ画面 (ShellScaffold) の PopScope が引き受け、
      // タブのルートではタブ切り替えや SystemNavigator.pop() を自前で行うので、常に
      // true でよい。分岐は既定実装 (WidgetsApp._defaultOnNavigationNotification) に
      // 合わせている。
      onNavigationNotification: (notification) {
        switch (WidgetsBinding.instance.lifecycleState) {
          case null:
          case AppLifecycleState.detached:
          case AppLifecycleState.inactive:
            return false;
          case AppLifecycleState.resumed:
          case AppLifecycleState.hidden:
          case AppLifecycleState.paused:
            SystemNavigator.setFrameworkHandlesBack(true);
            return true;
        }
      },
      theme: AppTheme.light(Theme.of(context)),
      darkTheme: AppTheme.dark(Theme.of(context)),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
