import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// カード画像を端末に保存しておくキャッシュ。
///
/// 同じキーのキャッシュを 2 つ作らないよう、アプリ全体で 1 つだけ作る。
///
/// [key] は以前使っていた cached_network_image（[DefaultCacheManager]）と同じ。
/// 変えると既存の端末のキャッシュがすべて無効になり、全員が画像を取り直すので
/// 変えない。縮小した画像のキーも [ImageCacheManager] が同じ形で作るので、以前に
/// 保存したものをそのまま使える。
class CardImageCacheManager extends CacheManager with ImageCacheManager {
  CardImageCacheManager(FileService fileService)
      : super(Config(key, fileService: fileService));

  static const String key = 'libCachedImageData';
}
