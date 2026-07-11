/// カード画像の配信 URL を構築する。
///
/// マスターデータ（Firestore）には画像のパスのみを保持する。
/// 例: `master/v0004/images/00-101-A001.jpg`
///
/// 実際の配信は Firebase Hosting（Fastly CDN）から行うため、パスの前に
/// Hosting のベース URL（`https://{projectId}.web.app`）を付与してフルの
/// URL を組み立てる。projectId は dart_define から取得するため、開発／本番で
/// 自動的に配信先が切り替わる。
///
/// マスターバージョンをパスに含める運用（`master/v{version}/...`）により、
/// バージョン更新のたびに URL が変わる。CachedNetworkImage は URL をキーに
/// キャッシュするため、これだけで古い画像のキャッシュを引かずに差し替えできる。
class ImageUrlBuilder {
  ImageUrlBuilder._();

  /// Firebase Hosting のベース URL。
  ///
  /// projectId（例: `manhole-card-navi` / `manhole-card-navi-dev`）から
  /// デフォルトの Hosting ドメイン `https://{projectId}.web.app` を導出する。
  static const String _baseUrl =
      'https://${String.fromEnvironment('android_projectId')}.web.app';

  /// 画像パスからフル URL を構築する。
  ///
  /// [path] はマスターデータに格納された画像パス
  /// （例: `master/v0004/images/00-101-A001.jpg`）。
  /// 空文字の場合はそのまま空文字を返す（画像なしを表す）。
  static String build(String path) {
    if (path.isEmpty) {
      return '';
    }
    return '$_baseUrl/$path';
  }
}
