import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

/// マスターデータが持つ HTML（配布場所・在庫状況）をそのまま表示する。
///
/// gk-p.jp の表記を保持しているため、施設名・住所・電話番号・リンクが 1 つの
/// HTML に混在している。リンクはアプリ内ブラウザで開く。
class HtmlContent extends StatelessWidget {
  const HtmlContent(
    this.data, {
    super.key,
  });

  final String data;

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
          fontSize: textStyle?.fontSize != null
              ? FontSize(textStyle!.fontSize!)
              : null,
        ),
        'a': Style(
          color: Colors.blue,
        ),
      },
      onLinkTap: (url, attributes, element) async {
        if (url == null) {
          return;
        }
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
        }
      },
    );
  }
}
