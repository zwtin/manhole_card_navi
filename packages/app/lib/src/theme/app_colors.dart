import 'package:flutter/material.dart';

import '../gen/colors.gen.dart';

/// Material 3 の色の役割（[ColorScheme]）に当てはまらない色だけを置く。
/// 役割があるもの（面・文字・枠線・強調）は [ColorScheme] から引く。
///
/// `Theme.of(context).extension<AppColors>()!` か、[AppColorsOf.appColors] で引く。
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.link,
    required this.cardLine,
    required this.cardShadow,
  });

  static const light = AppColors(
    link: ColorName.lightLink,
    cardLine: null,
    cardShadow: ColorName.lightCardShadow,
  );

  static const dark = AppColors(
    link: ColorName.darkLink,
    cardLine: ColorName.darkCardLine,
    cardShadow: null,
  );

  /// 押せる文字。Material 3 に対応する役割がない。
  final Color link;

  /// カードの枠線。影を落とすテーマ（明るいほう）では引かないので null。
  final Color? cardLine;

  /// カードの影。枠線を引くテーマ（暗いほう）では落とさないので null。
  final Color? cardShadow;

  @override
  AppColors copyWith({Color? link, Color? cardLine, Color? cardShadow}) {
    return AppColors(
      link: link ?? this.link,
      cardLine: cardLine ?? this.cardLine,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) {
      return this;
    }
    return AppColors(
      link: Color.lerp(link, other.link, t)!,
      cardLine: Color.lerp(cardLine, other.cardLine, t),
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t),
    );
  }
}

extension AppColorsOf on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
