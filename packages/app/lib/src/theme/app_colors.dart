import 'package:flutter/material.dart';

import '../gen/colors.gen.dart';

/// [ThemeData] が持たない色。`Theme.of(context).extension<AppColors>()!` で引く。
///
/// 画面の中で色を作らず、必ずここに名前を付けてから使う。
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.link,
    required this.segmentTrack,
    required this.chipBorder,
    required this.cardLine,
    required this.badgeText,
    required this.badgeBackground,
    required this.cardShadow,
    required this.screenBackground,
  });

  static const light = AppColors(
    link: ColorName.lightLink,
    segmentTrack: ColorName.lightSegmentTrack,
    chipBorder: ColorName.lightChipBorder,
    cardLine: null,
    badgeText: ColorName.lightBadgeText,
    badgeBackground: ColorName.lightBadgeBackground,
    cardShadow: ColorName.lightCardShadow,
    screenBackground: ColorName.lightScreenBackground,
  );

  static const dark = AppColors(
    link: ColorName.darkLink,
    segmentTrack: ColorName.darkSegmentTrack,
    chipBorder: ColorName.darkChipBorder,
    cardLine: ColorName.darkCardLine,
    badgeText: ColorName.darkBadgeText,
    badgeBackground: ColorName.darkBadgeBackground,
    cardShadow: null,
    screenBackground: ColorName.darkScreenBackground,
  );

  /// 押せる文字。
  final Color link;

  /// セグメントコントロールの溝。
  final Color segmentTrack;

  /// 選んでいないチップの枠線。
  final Color chipBorder;

  /// カードの枠線。明るいテーマでは引かないので null。
  final Color? cardLine;

  final Color badgeText;
  final Color badgeBackground;

  /// カードの影。枠線を引くテーマ（暗いほう）では落とさないので null。
  final Color? cardShadow;

  /// 画面そのものの背景。中身（カード・リスト）の背景より 1 段暗い。
  /// Material の `ColorScheme.background` は廃止されたので、こちらで持つ。
  final Color screenBackground;

  @override
  AppColors copyWith({
    Color? link,
    Color? segmentTrack,
    Color? chipBorder,
    Color? cardLine,
    Color? badgeText,
    Color? badgeBackground,
    Color? cardShadow,
    Color? screenBackground,
  }) {
    return AppColors(
      link: link ?? this.link,
      segmentTrack: segmentTrack ?? this.segmentTrack,
      chipBorder: chipBorder ?? this.chipBorder,
      cardLine: cardLine ?? this.cardLine,
      badgeText: badgeText ?? this.badgeText,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      cardShadow: cardShadow ?? this.cardShadow,
      screenBackground: screenBackground ?? this.screenBackground,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) {
      return this;
    }
    return AppColors(
      link: Color.lerp(link, other.link, t)!,
      segmentTrack: Color.lerp(segmentTrack, other.segmentTrack, t)!,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t)!,
      cardLine: Color.lerp(cardLine, other.cardLine, t),
      badgeText: Color.lerp(badgeText, other.badgeText, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t),
      screenBackground:
          Color.lerp(screenBackground, other.screenBackground, t)!,
    );
  }
}

extension AppColorsOf on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
