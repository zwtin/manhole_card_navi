import 'package:flutter/material.dart';

import '../gen/colors.gen.dart';
import 'app_colors.dart';

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

/// アプリのテーマ。色は Material 3 の役割（[ColorScheme]）に載せ、役割のない色
/// だけを [AppColors] に置く。
///
/// 面の重なりは `surface`（画面の地）と `surfaceContainerLowest`（カード・リスト
/// の面）で表す。Material 3 はこの 2 つを、明るいテーマでは面のほうを明るく、
/// 暗いテーマでは面のほうを暗くする向きで定義している。
abstract final class AppTheme {
  static ThemeData light() {
    return _build(
      brightness: Brightness.light,
      primary: ColorName.lightPrimary,
      screenBackground: ColorName.lightScreenBackground,
      contentsBackground: ColorName.lightContentsBackground,
      positiveText: ColorName.lightPositiveText,
      icon: ColorName.lightIcon,
      border: ColorName.lightBorder,
      chipBorder: ColorName.lightChipBorder,
      segmentTrack: ColorName.lightSegmentTrack,
      badgeText: ColorName.lightBadgeText,
      badgeBackground: ColorName.lightBadgeBackground,
      colors: AppColors.light,
    );
  }

  static ThemeData dark() {
    return _build(
      brightness: Brightness.dark,
      primary: ColorName.darkPrimary,
      screenBackground: ColorName.darkScreenBackground,
      contentsBackground: ColorName.darkContentsBackground,
      positiveText: ColorName.darkPositiveText,
      icon: ColorName.darkIcon,
      border: ColorName.darkBorder,
      chipBorder: ColorName.darkChipBorder,
      segmentTrack: ColorName.darkSegmentTrack,
      badgeText: ColorName.darkBadgeText,
      badgeBackground: ColorName.darkBadgeBackground,
      colors: AppColors.dark,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color screenBackground,
    required Color contentsBackground,
    required Color positiveText,
    required Color icon,
    required Color border,
    required Color chipBorder,
    required Color segmentTrack,
    required Color badgeText,
    required Color badgeBackground,
    required AppColors colors,
  }) {
    // 決めていない役割（tertiary など）は、ブランド色から調和した値を作らせる。
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: contentsBackground,
      surface: screenBackground,
      surfaceContainerLowest: contentsBackground,
      surfaceContainerHigh: segmentTrack,
      onSurface: positiveText,
      onSurfaceVariant: icon,
      outline: chipBorder,
      outlineVariant: border,
      secondaryContainer: badgeBackground,
      onSecondaryContainer: badgeText,
    );
    // 文字色は onSurface から導かれるので、textTheme に色を配って回らなくてよい。
    final base = ThemeData(colorScheme: scheme, extensions: [colors]);

    return base.copyWith(
      // ThemeData は暗いテーマの primaryColor を colorScheme.surface にするので、
      // ブランド色を使いたいところは明示する。
      primaryColor: primary,
      iconTheme: IconThemeData(color: icon),
      dividerColor: border,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: contentsBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: icon),
      ),
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
      expansionTileTheme: base.expansionTileTheme.copyWith(
        backgroundColor: contentsBackground,
        iconColor: icon,
        collapsedIconColor: icon,
        shape: const Border(),
        collapsedShape: const Border(),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return icon;
          }
          return null;
        }),
        side: BorderSide(color: icon),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: contentsBackground,
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
