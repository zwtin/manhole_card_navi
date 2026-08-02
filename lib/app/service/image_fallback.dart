import 'package:firebase_remote_config/firebase_remote_config.dart';

/// カード画像の取得に失敗したときの代替配信元（フォールバック）を解決する。
///
/// 主系は Cloudflare R2（`https://cdn.manholecardnavi.com/...`）だが、
/// 新規取得ドメインのため一部のネットワーク（キャリアのフィルタリング、学校・企業の
/// ネットワーク、DNS フィルタ）で遮断されることがある。遮断された端末では
/// カード画像が一切表示されないため、代替として Firebase Hosting から取り直す。
///
/// R2 と Hosting はオブジェクトキーの設計が同じ（`master/v{version}/images/{id}.jpg`）
/// なので、URL のホスト部分を差し替えるだけで代替 URL になる。
///
/// ベース URL は Remote Config の [_remoteConfigKey] から読む。**空文字なら
/// フォールバックしない**（既定で無効）。Hosting 側に当該バージョンの画像を
/// 配置してから Remote Config に値を入れること。順序を逆にすると 404 を
/// 取りに行くだけの無駄なリクエストが増える。
///
/// Remote Config に持たせているのは、配信先を変えたくなったときに
/// アプリの更新なしで切り替えられるようにするため。
class ImageFallback {
  ImageFallback._();

  /// フォールバック先のベース URL を格納する Remote Config のキー。
  /// 例: `https://manhole-card-navi.web.app`（末尾スラッシュは付けても付けなくてもよい）
  static const String _remoteConfigKey = 'image_fallback_base_url';

  /// [primaryUrl] に対応するフォールバック URL。無効・解決不能なら null。
  ///
  /// Remote Config はウィジェットツリーの外（[FileService] や Isolate の外側）からも
  /// 参照するため、リポジトリ経由ではなく [FirebaseRemoteConfig.instance] を直接読む。
  /// 値の取得は同期的でコストがないため、呼び出しごとに読んで最新値を反映する。
  static String? urlOf(String primaryUrl) {
    final String baseUrl;
    try {
      baseUrl = FirebaseRemoteConfig.instance.getString(_remoteConfigKey).trim();
    } on Exception {
      return null;
    }
    if (baseUrl.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(primaryUrl);
    if (uri == null || uri.path.isEmpty) {
      return null;
    }

    final normalizedBase =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final fallbackUrl = '$normalizedBase${uri.path}';

    // 主系と同じ URL になるなら取り直す意味がない。
    if (fallbackUrl == primaryUrl) {
      return null;
    }
    return fallbackUrl;
  }
}
