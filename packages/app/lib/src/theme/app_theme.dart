import 'package:flutter/material.dart';

import '../gen/colors.gen.dart';

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
/// 本アプリはタブごとに Navigator を持ち、画像詳細 (ImageDetailPage) だけを
/// root Navigator へ積んでいる。この状態でエッジスワイプすると、タブ内 Navigator の
/// 最上位であるカード詳細 (DetailPage) が「自分が最前面」と判断してジェスチャーを
/// 処理してしまい、最前面の画像詳細ではなく背面のカード詳細が閉じる。画像詳細は
/// 独自の transitionsBuilder を持つため予測型バックの observer を登録せず、
/// ジェスチャーに反応できないことも要因。
final _pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    // iOS などは Flutter の既定のままにして、Android だけ差し替える。
    ...const PageTransitionsTheme().builders,
    TargetPlatform.android: const ZoomPageTransitionsBuilder(),
  },
);

/// アプリのテーマ。[base] には MaterialApp の外側の `Theme.of(context)` を渡す。
abstract final class AppTheme {
  static ThemeData light(ThemeData base) {
    return _build(
      base,
      primary: ColorName.lightPrimary,
      screenBackground: ColorName.lightScreenBackground,
      contentsBackground: ColorName.lightContentsBackground,
      positiveText: ColorName.lightPositiveText,
      icon: ColorName.lightIcon,
      border: ColorName.lightBorder,
    );
  }

  static ThemeData dark(ThemeData base) {
    return _build(
      base,
      primary: ColorName.darkPrimary,
      screenBackground: ColorName.darkScreenBackground,
      contentsBackground: ColorName.darkContentsBackground,
      positiveText: ColorName.darkPositiveText,
      icon: ColorName.darkIcon,
      border: ColorName.darkBorder,
    );
  }

  static ThemeData _build(
    ThemeData base, {
    required Color primary,
    required Color screenBackground,
    required Color contentsBackground,
    required Color positiveText,
    required Color icon,
    required Color border,
  }) {
    final textTheme = base.textTheme;
    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        color: contentsBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: icon),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: positiveText,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(color: positiveText),
        displayMedium: textTheme.displayMedium?.copyWith(color: positiveText),
        displaySmall: textTheme.displaySmall?.copyWith(color: positiveText),
        headlineLarge: textTheme.headlineLarge?.copyWith(color: positiveText),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: positiveText,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(color: positiveText),
        titleLarge: textTheme.titleLarge?.copyWith(color: positiveText),
        titleMedium: textTheme.titleMedium?.copyWith(color: positiveText),
        titleSmall: textTheme.titleSmall?.copyWith(color: positiveText),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: positiveText),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: positiveText),
        bodySmall: textTheme.bodySmall?.copyWith(color: positiveText),
        labelLarge: textTheme.labelLarge?.copyWith(color: positiveText),
        labelMedium: textTheme.labelMedium?.copyWith(color: positiveText),
        labelSmall: textTheme.labelSmall?.copyWith(color: positiveText),
      ),
      primaryColor: primary,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        background: screenBackground,
        surface: contentsBackground,
      ),
      iconTheme: IconThemeData(color: icon),
      cardColor: screenBackground,
      listTileTheme: base.listTileTheme.copyWith(
        tileColor: contentsBackground,
        textColor: positiveText,
      ),
      dividerTheme: DividerThemeData(
        color: border,
        space: 0.0,
        indent: 0.0,
        thickness: 0.5,
      ),
      dividerColor: border,
      expansionTileTheme: base.expansionTileTheme.copyWith(
        backgroundColor: contentsBackground,
        iconColor: icon,
        collapsedIconColor: icon,
        shape: const Border(),
        collapsedShape: const Border(),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return icon;
          }
          return null;
        }),
        side: BorderSide(color: icon),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: textTheme.titleLarge?.copyWith(color: contentsBackground),
          backgroundColor: primary,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 2),
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
          foregroundColor: icon,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: screenBackground,
        showDragHandle: true,
        dragHandleColor: icon,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
      pageTransitionsTheme: _pageTransitionsTheme,
    );
  }
}
