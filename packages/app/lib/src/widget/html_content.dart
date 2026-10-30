import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:app/src/theme/app_colors.dart';

/// マスターデータが持つ HTML（配布場所・在庫状況）をそのまま表示する。
///
/// gk-p.jp の表記を保持しているため、施設名・住所・電話番号・リンクが 1 つの
/// HTML に混在している。
class HtmlContent extends StatelessWidget {
  const HtmlContent(this.data, {required this.onTapLink, super.key});

  final String data;

  /// 押されたリンクの URL を受け取る。
  final ValueChanged<String> onTapLink;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    return Html(
      data: data,
      shrinkWrap: true,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: textStyle?.color,
          fontFamily: textStyle?.fontFamily,
          fontSize:
              textStyle?.fontSize != null
                  ? FontSize(textStyle!.fontSize!)
                  : null,
        ),
        'a': Style(color: context.appColors.link),
      },
      onLinkTap: (url, attributes, element) {
        if (url != null) {
          onTapLink(url);
        }
      },
    );
  }
}
