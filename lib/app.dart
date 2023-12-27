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

    return MaterialApp(
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: ColorName.contentsBackground,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: ColorName.icon,
              ),
            ),
        textTheme: Theme.of(context).textTheme.copyWith(
              displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: ColorName.positiveText,
                  ),
              displayMedium:
                  Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: ColorName.positiveText,
                      ),
              displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: ColorName.positiveText,
                  ),
              headlineLarge:
                  Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: ColorName.positiveText,
                      ),
              headlineMedium:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: ColorName.positiveText,
                      ),
              headlineSmall:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ColorName.positiveText,
                      ),
              titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorName.positiveText,
                  ),
              titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorName.positiveText,
                  ),
              titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ColorName.positiveText,
                  ),
              bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorName.positiveText,
                  ),
              bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorName.positiveText,
                  ),
              bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorName.positiveText,
                  ),
              labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: ColorName.positiveText,
                  ),
              labelMedium: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: ColorName.positiveText,
                  ),
              labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ColorName.positiveText,
                  ),
            ),
        primaryColor: ColorName.primary,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: ColorName.primary,
              background: ColorName.screenBackground,
              surface: ColorName.contentsBackground,
            ),
        iconTheme: const IconThemeData(
          color: ColorName.icon,
        ),
        cardColor: ColorName.screenBackground,
        listTileTheme: Theme.of(context).listTileTheme.copyWith(
              tileColor: ColorName.contentsBackground,
            ),
        dividerTheme: const DividerThemeData(
          color: ColorName.border,
          space: 0.0,
          indent: 0.0,
          thickness: 0.5,
        ),
        dividerColor: ColorName.border,
        expansionTileTheme: Theme.of(context).expansionTileTheme.copyWith(
              backgroundColor: ColorName.contentsBackground,
              iconColor: ColorName.icon,
              collapsedIconColor: ColorName.icon,
              shape: const Border(),
              collapsedShape: const Border(),
            ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return ColorName.icon;
            }
            return null;
          }),
          side: const BorderSide(
            color: ColorName.icon,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: ColorName.contentsBackground,
                ),
            backgroundColor: ColorName.primary,
            elevation: 0.0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorName.primary,
            side: const BorderSide(
              color: ColorName.primary,
              width: 2,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: ColorName.icon,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: ColorName.screenBackground,
          showDragHandle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: ColorName.primary,
        ),
      ),
      home: CheckAppUpdateView(
        key: UniqueKey(),
      ),
    );
  }
}
