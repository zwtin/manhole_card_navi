import 'package:flutter/material.dart';

import 'package:app/src/widget/app_text.dart';

/// [AppBar] の見出し。
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
