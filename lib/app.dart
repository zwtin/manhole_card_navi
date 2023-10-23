import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view/check_app_update_view.dart';
import '/app_view_model.dart';
import '/gen/colors.gen.dart';

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

    final originalTheme = Theme.of(context);

    return MaterialApp(
      theme: originalTheme.copyWith(
        appBarTheme: originalTheme.appBarTheme.copyWith(
          color: ColorName.main,
          elevation: 0,
          shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
        ),
        textTheme: originalTheme.textTheme.copyWith(
          displayLarge: originalTheme.textTheme.displayLarge?.copyWith(
            color: Colors.white,
          ),
          displayMedium: originalTheme.textTheme.displayMedium?.copyWith(
            color: Colors.white,
          ),
          displaySmall: originalTheme.textTheme.displaySmall?.copyWith(
            color: Colors.white,
          ),
          headlineLarge: originalTheme.textTheme.headlineLarge?.copyWith(
            color: Colors.white,
          ),
          headlineMedium: originalTheme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
          ),
          headlineSmall: originalTheme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
          ),
          titleLarge: originalTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
          titleMedium: originalTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
          titleSmall: originalTheme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
          ),
          bodyLarge: originalTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
          bodyMedium: originalTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
          bodySmall: originalTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
          labelLarge: originalTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
          ),
          labelMedium: originalTheme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
          ),
          labelSmall: originalTheme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
          ),
        ),
        cardColor: ColorName.main,
      ),
      home: CheckAppUpdateView(
        key: UniqueKey(),
      ),
    );
  }
}
