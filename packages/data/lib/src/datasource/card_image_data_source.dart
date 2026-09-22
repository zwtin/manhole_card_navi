import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';

class CardImageDataSource {
  CardImageDataSource(this._cache);

  /// 同じキーのキャッシュを 2 つ作らないよう、アプリ全体で 1 つだけ作る。
  factory CardImageDataSource.withDeviceCache() {
    return CardImageDataSource(
      CacheManager(
        Config(
          // 以前使っていた cached_network_image と同じキー。変えると既存の端末の
          // キャッシュがすべて無効になり、全員が画像を取り直すので変えない。
          _cacheKey,
          // カードは全部で 1300 枚ほど。どの端末でも全部を持てるようにする。
          maxNrOfCacheObjects: 2000,
          fileService: HttpFileService(httpClient: _createClient()),
        ),
      ),
    );
  }

  static const String _cacheKey = 'libCachedImageData';

  /// 取得をあきらめるまでの時間。dart:io の既定では OS のタイムアウト（Darwin で
  /// 約 75 秒）まで待ち、遮断されている端末で次の配信元に移るのが遅れる。
  static const Duration _timeout = Duration(seconds: 12);

  final BaseCacheManager _cache;

  static IOClient _createClient() {
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      // 既定は無制限。モバイル回線で TLS のハンドシェイクを同時に投げすぎると
      // ETIMEDOUT になるので、キャッシュ層の同時取得数（既定 10）に合わせる。
      ..maxConnectionsPerHost = 10;
    return IOClient(httpClient);
  }

  Future<Uint8List?> readCache(String url) async {
    final cached = await _cache.getFileFromCache(url);
    return cached?.file.readAsBytes();
  }

  /// 取った画像は端末に保存する。
  Future<Uint8List> download(String url) async {
    final downloaded = await _cache.downloadFile(url).timeout(_timeout);
    return downloaded.file.readAsBytes();
  }
}
