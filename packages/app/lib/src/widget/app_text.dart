import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// アプリで使う文字。見た目はここに並べたものだけで、画面側で [TextStyle] を
/// 作らない（lint で禁止している）。使っていない見た目も、そろえるために残す。
class AppText extends StatelessWidget {
  const AppText.displayLarge(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.displayLarge;

  const AppText.displayMedium(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.displayMedium;

  const AppText.displaySmall(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.displaySmall;

  const AppText.headlineLarge(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.headlineLarge;

  const AppText.headlineMedium(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.headlineMedium;

  const AppText.headlineSmall(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.headlineSmall;

  const AppText.titleLarge(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.titleLarge;

  const AppText.titleMedium(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.titleMedium;

  const AppText.titleSmall(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.titleSmall;

  const AppText.bodyLarge(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.bodyLarge;

  const AppText.bodyMedium(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.bodyMedium;

  const AppText.bodySmall(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.bodySmall;

  const AppText.labelLarge(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.labelLarge;

  const AppText.labelMedium(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.labelMedium;

  const AppText.labelSmall(
    this.data, {
    this.color,
    this.fontWeight,
    this.overflow,
    super.key,
  }) : _variant = _Variant.labelSmall;

  /// 押せる文字。色は [AppColors.link] で、下線を引く。
  const AppText.titleLargeLink(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  })  : _variant = _Variant.titleLargeLink,
        color = null;

  const AppText.titleMediumLink(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  })  : _variant = _Variant.titleMediumLink,
        color = null;

  const AppText.titleSmallLink(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  })  : _variant = _Variant.titleSmallLink,
        color = null;

  const AppText.bodyLargeLink(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  })  : _variant = _Variant.bodyLargeLink,
        color = null;

  const AppText.bodyMediumLink(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  })  : _variant = _Variant.bodyMediumLink,
        color = null;

  const AppText.bodySmallLink(
    this.data, {
    this.fontWeight,
    this.overflow,
    super.key,
  })  : _variant = _Variant.bodySmallLink,
        color = null;

  final String data;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final _Variant _variant;

  @override
  Widget build(BuildContext context) {
    final linkColor = _variant.isLink ? context.appColors.link : null;
    return Text(
      data,
      style: _variant.baseStyle(Theme.of(context).textTheme)?.copyWith(
            color: linkColor ?? color,
            fontWeight: fontWeight,
            overflow: overflow,
            decoration: linkColor == null ? null : TextDecoration.underline,
            decorationColor: linkColor,
          ),
    );
  }
}

enum _Variant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  titleLargeLink,
  titleMediumLink,
  titleSmallLink,
  bodyLargeLink,
  bodyMediumLink,
  bodySmallLink;

  bool get isLink => name.endsWith('Link');

  TextStyle? baseStyle(TextTheme theme) {
    return switch (this) {
      displayLarge => theme.displayLarge,
      displayMedium => theme.displayMedium,
      displaySmall => theme.displaySmall,
      headlineLarge => theme.headlineLarge,
      headlineMedium => theme.headlineMedium,
      headlineSmall => theme.headlineSmall,
      titleLarge || titleLargeLink => theme.titleLarge,
      titleMedium || titleMediumLink => theme.titleMedium,
      titleSmall || titleSmallLink => theme.titleSmall,
      bodyLarge || bodyLargeLink => theme.bodyLarge,
      bodyMedium || bodyMediumLink => theme.bodyMedium,
      bodySmall || bodySmallLink => theme.bodySmall,
      labelLarge => theme.labelLarge,
      labelMedium => theme.labelMedium,
      labelSmall => theme.labelSmall,
    };
  }
}
