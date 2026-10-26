import 'package:flutter/material.dart';

import 'package:app/src/widget/app_text.dart';

/// [AppBar] の見出し。画面ごとに大きさや太さを決めない。
///
/// テーマの `appBarTheme.titleTextStyle` には入れられない。`ThemeData` を組む
/// 時点では `textTheme` に大きさが入っておらず（言語に応じた字形と合わせるのは
/// 画面を描くとき）、そこで焼き込むと大きさのない style になってしまう。
class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.data, {super.key});

  /// 手を入れられない画面（Flutter の `LicensePage` など）の見出しを、この
  /// 見た目にそろえるための style。`Theme` で包むときに使う。
  static TextStyle? styleOf(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
  }

  final String data;

  @override
  Widget build(BuildContext context) {
    return AppText.titleLarge(data, fontWeight: FontWeight.bold);
  }
}
