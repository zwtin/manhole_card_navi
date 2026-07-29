import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view/check_app_update_view.dart';
import '/app_view_model.dart';
import '/gen/colors.gen.dart';

/// ページ遷移アニメーション。Android は Flutter 3.43 までの既定である
/// [ZoomPageTransitionsBuilder] に固定する。
///
/// Flutter 3.44 から Android の既定が [PredictiveBackPageTransitionsBuilder] に
/// 変わったが、本アプリの Navigator 構成とは噛み合わない。予測型バックは Route ごとに
/// WidgetsBindingObserver を登録してジェスチャーを受け取る実装で、その有効条件が
/// `route.isCurrent && route.popGestureEnabled` になっている。ここでの isCurrent は
/// 「その Route が属する Navigator の中で最上位か」であり、アプリ全体で最前面かでは
/// ない。
///
/// 本アプリはタブごとに Navigator を持ち、画像詳細 (ImageDetailView) だけを
/// FadeInRoute で root Navigator へ push している。この状態でエッジスワイプすると、
/// タブ内 Navigator の最上位であるカード詳細 (DetailView) が「自分が最前面」と判断して
/// ジェスチャーを処理してしまい、最前面の画像詳細ではなく背面のカード詳細が閉じる。
/// FadeInRoute は独自の transitionsBuilder を持つため予測型バックの observer を
/// 登録せず、ジェスチャーに反応できないことも要因。
final _pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    // iOS などは Flutter の既定のままにして、Android だけ差し替える。
    ...const PageTransitionsTheme().builders,
    TargetPlatform.android: const ZoomPageTransitionsBuilder(),
  },
);

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
            await ref.read(appViewModelProvider(key)).onLoad();
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
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: ColorName.lightContentsBackground,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: ColorName.lightIcon,
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorName.lightPositiveText,
                    fontWeight: FontWeight.bold,
                  ),
            ),
        textTheme: Theme.of(context).textTheme.copyWith(
              displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              displayMedium:
                  Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: ColorName.lightPositiveText,
                      ),
              displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              headlineLarge:
                  Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: ColorName.lightPositiveText,
                      ),
              headlineMedium:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: ColorName.lightPositiveText,
                      ),
              headlineSmall:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ColorName.lightPositiveText,
                      ),
              titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              labelMedium: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
              labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ColorName.lightPositiveText,
                  ),
            ),
        primaryColor: ColorName.lightPrimary,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: ColorName.lightPrimary,
              background: ColorName.lightScreenBackground,
              surface: ColorName.lightContentsBackground,
            ),
        iconTheme: const IconThemeData(
          color: ColorName.lightIcon,
        ),
        cardColor: ColorName.lightScreenBackground,
        listTileTheme: Theme.of(context).listTileTheme.copyWith(
              tileColor: ColorName.lightContentsBackground,
              textColor: ColorName.lightPositiveText,
            ),
        dividerTheme: const DividerThemeData(
          color: ColorName.lightBorder,
          space: 0.0,
          indent: 0.0,
          thickness: 0.5,
        ),
        dividerColor: ColorName.lightBorder,
        expansionTileTheme: Theme.of(context).expansionTileTheme.copyWith(
              backgroundColor: ColorName.lightContentsBackground,
              iconColor: ColorName.lightIcon,
              collapsedIconColor: ColorName.lightIcon,
              shape: const Border(),
              collapsedShape: const Border(),
            ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return ColorName.lightIcon;
            }
            return null;
          }),
          side: const BorderSide(
            color: ColorName.lightIcon,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: ColorName.lightContentsBackground,
                ),
            backgroundColor: ColorName.lightPrimary,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorName.lightPrimary,
            side: const BorderSide(
              color: ColorName.lightPrimary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: ColorName.lightIcon,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: ColorName.lightScreenBackground,
          showDragHandle: true,
          dragHandleColor: ColorName.lightIcon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: ColorName.lightPrimary,
        ),
        pageTransitionsTheme: _pageTransitionsTheme,
      ),
      darkTheme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: ColorName.darkContentsBackground,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: ColorName.darkIcon,
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorName.darkPositiveText,
                    fontWeight: FontWeight.bold,
                  ),
            ),
        textTheme: Theme.of(context).textTheme.copyWith(
              displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              displayMedium:
                  Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: ColorName.darkPositiveText,
                      ),
              displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              headlineLarge:
                  Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: ColorName.darkPositiveText,
                      ),
              headlineMedium:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: ColorName.darkPositiveText,
                      ),
              headlineSmall:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ColorName.darkPositiveText,
                      ),
              titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              labelMedium: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
              labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ColorName.darkPositiveText,
                  ),
            ),
        primaryColor: ColorName.darkPrimary,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: ColorName.darkPrimary,
              background: ColorName.darkScreenBackground,
              surface: ColorName.darkContentsBackground,
            ),
        iconTheme: const IconThemeData(
          color: ColorName.darkIcon,
        ),
        cardColor: ColorName.darkScreenBackground,
        listTileTheme: Theme.of(context).listTileTheme.copyWith(
              tileColor: ColorName.darkContentsBackground,
              textColor: ColorName.darkPositiveText,
            ),
        dividerTheme: const DividerThemeData(
          color: ColorName.darkBorder,
          space: 0.0,
          indent: 0.0,
          thickness: 0.5,
        ),
        dividerColor: ColorName.darkBorder,
        expansionTileTheme: Theme.of(context).expansionTileTheme.copyWith(
              backgroundColor: ColorName.darkContentsBackground,
              iconColor: ColorName.darkIcon,
              collapsedIconColor: ColorName.darkIcon,
              shape: const Border(),
              collapsedShape: const Border(),
            ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return ColorName.darkIcon;
            }
            return null;
          }),
          side: const BorderSide(
            color: ColorName.darkIcon,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: ColorName.darkContentsBackground,
                ),
            backgroundColor: ColorName.darkPrimary,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorName.darkPrimary,
            side: const BorderSide(
              color: ColorName.darkPrimary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: ColorName.darkIcon,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: ColorName.darkScreenBackground,
          showDragHandle: true,
          dragHandleColor: ColorName.darkIcon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: ColorName.darkPrimary,
        ),
        pageTransitionsTheme: _pageTransitionsTheme,
      ),
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (
            context,
            animation1,
            animation2,
          ) {
            return CheckAppUpdateView(
              key: UniqueKey(),
            );
          },
        );
      },
    );
  }
}
