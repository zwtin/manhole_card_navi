/// 代わりの配信元の URL（カードごとのデータで、主系の URL からは作れない）を、
/// HTTP ヘッダに載せて flutter_cache_manager の `FileService` まで運ぶ。
/// `FileService` に URL 以外を渡す道がヘッダしかないため。送る前に取り除くので、
/// ネットワークには出ない。
///
/// キャッシュのキーは主系の URL のまま（ヘッダはキーに含まれない）なので、代わりの
/// 配信元から取った画像も主系の URL で引ける。
class ImageFallback {
  ImageFallback._();

  static const String headerKey = 'x-image-sub-url';

  static Map<String, String>? headers(String imageSubUrl) {
    if (imageSubUrl.isEmpty) {
      return null;
    }
    return <String, String>{headerKey: imageSubUrl};
  }

  static String? subUrlFrom(Map<String, String>? headers) {
    final subUrl = headers?[headerKey];
    if (subUrl == null || subUrl.isEmpty) {
      return null;
    }
    return subUrl;
  }

  /// 渡された Map は、呼び出し元が使い回しているかもしれないので変えない。
  static Map<String, String>? withoutSubUrl(Map<String, String>? headers) {
    if (headers == null || !headers.containsKey(headerKey)) {
      return headers;
    }
    final rest = Map<String, String>.of(headers)..remove(headerKey);
    return rest.isEmpty ? null : rest;
  }
}
