/// カード画像の代替配信元（フォールバック先）URL を、画像取得の実処理まで運ぶ。
///
/// 主系は Cloudflare R2 だが、新規取得ドメインのため一部のネットワーク
/// （キャリアのフィルタリング、学校・企業のネットワーク、DNS フィルタ）で
/// 遮断されることがある。遮断された端末ではカード画像が一切表示されないため、
/// master の `image_sub_url` に入っている別ドメインの URL から取り直す。
///
/// 代替 URL は **カードごとのデータ**（Firestore の `image_sub_url`）なので、
/// URL 文字列から機械的に導出することはできない。一方で画像の取得は
/// [CachedNetworkImage] / [CachedNetworkImageProvider] / `precacheImage` の
/// いずれも `FileService` に集約されており、そこへ URL 以外の情報を渡す経路は
/// HTTP ヘッダしかない。そこで代替 URL を [headerKey] のヘッダに載せて運ぶ。
///
/// **このヘッダはネットワークには出ない。** `FileService` 側で
/// [withoutSubUrl] を使って実際のリクエストから取り除く。
///
/// キャッシュのキーは主系の URL のままなので、代替から取得しても以降は
/// 透過的に扱われる（flutter_cache_manager はヘッダをキーに含めない）。
class ImageFallback {
  ImageFallback._();

  /// 代替配信元 URL を載せるヘッダ名。実際のリクエストには含めない。
  static const String headerKey = 'x-image-sub-url';

  /// 画像ウィジェットに渡す `httpHeaders` を作る。代替が無ければ null。
  static Map<String, String>? headers(String imageSubUrl) {
    if (imageSubUrl.isEmpty) {
      return null;
    }
    return <String, String>{headerKey: imageSubUrl};
  }

  /// ヘッダから代替配信元 URL を取り出す。無ければ null。
  static String? subUrlFrom(Map<String, String>? headers) {
    final subUrl = headers?[headerKey];
    if (subUrl == null || subUrl.isEmpty) {
      return null;
    }
    return subUrl;
  }

  /// 実際のリクエストに使うヘッダ（[headerKey] を除いたもの）。
  ///
  /// 渡された Map は変更しない（呼び出し元が使い回している可能性があるため）。
  static Map<String, String>? withoutSubUrl(Map<String, String>? headers) {
    if (headers == null || !headers.containsKey(headerKey)) {
      return headers;
    }
    final rest = Map<String, String>.of(headers)..remove(headerKey);
    return rest.isEmpty ? null : rest;
  }
}
