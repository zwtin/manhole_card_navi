import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:data/src/datasource/card_image_cache_manager.dart';
import 'package:data/src/datasource/fallback_file_service.dart';
import 'package:data/src/datasource/image_fallback.dart';
import 'package:data/src/datasource/image_load_monitor.dart';

/// カード画像の取得。
class CardImageDataSource {
  CardImageDataSource(this._cacheManager);

  /// 端末に保存して使い回す形で作る。キャッシュはアプリ全体で 1 つなので、これも
  /// 1 つだけ作る。
  factory CardImageDataSource.withDeviceCache(FirebaseAnalytics analytics) {
    return CardImageDataSource(
      CardImageCacheManager(
        FallbackFileService(monitor: ImageLoadMonitor(analytics)),
      ),
    );
  }

  final ImageCacheManager _cacheManager;

  /// [url] の画像のデータ。[subUrl] は、[url] から取れなかったときに使う代わりの
  /// 配信元。[maxWidth] を渡すと、その幅に縮小したものを返す。
  Future<Uint8List> fetch({
    required String url,
    required String subUrl,
    int? maxWidth,
  }) async {
    // 保存済みなら期限切れでも先に流れてくる（取り直しはその後ろで行われる）ので、
    // 最初の 1 件だけ使う。取り直せなくても保存済みの画像は出せる。
    final response = await _cacheManager
        .getImageFile(
          url,
          headers: ImageFallback.headers(subUrl),
          maxWidth: maxWidth,
        )
        .firstWhere((response) => response is FileInfo);
    return (response as FileInfo).file.readAsBytes();
  }
}
