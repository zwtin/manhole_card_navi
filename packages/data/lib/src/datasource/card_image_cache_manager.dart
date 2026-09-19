import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:data/src/datasource/image_fallback.dart';
import 'package:data/src/datasource/image_load_monitor.dart';

/// [key] は以前使っていた cached_network_image（[DefaultCacheManager]）と同じ。
/// 変えると既存の端末のキャッシュがすべて無効になり、全員が画像を取り直すので
/// 変えない。縮小した画像のキーも [ImageCacheManager] が同じ形で作るので、以前に
/// 保存したものをそのまま使える。
class CardImageCacheManager extends CacheManager with ImageCacheManager {
  factory CardImageCacheManager() => _instance;

  CardImageCacheManager._()
      : super(
          Config(
            key,
            fileService: _FallbackFileService(),
          ),
        );

  static const String key = 'libCachedImageData';

  static final CardImageCacheManager _instance = CardImageCacheManager._();
}

/// 主系で取れなければ、代わりの配信元（[ImageFallback]）から取り直す。
class _FallbackFileService extends FileService {
  _FallbackFileService() : _httpClient = _createClient();

  final http.Client _httpClient;

  /// dart:io の既定では OS のタイムアウト（Darwin で約 75 秒）まで待ち、遮断されて
  /// いる端末で代わりの配信元に移るのが遅れる。
  static const Duration _responseTimeout = Duration(seconds: 12);

  static http.Client _createClient() {
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      // 既定は無制限。モバイル回線で TLS のハンドシェイクを同時に投げすぎると
      // ETIMEDOUT になるので、キャッシュ層の同時取得数（既定 10）に合わせる。
      ..maxConnectionsPerHost = 10;
    return IOClient(httpClient);
  }

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    FileServiceResponse? primaryResponse;
    Object primaryError = const HttpException('unknown');

    try {
      primaryResponse = await _send(url, headers);
      if (primaryResponse.statusCode == 200) {
        return primaryResponse;
      }
      primaryError = HttpExceptionWithStatus(
        primaryResponse.statusCode,
        'Invalid statusCode: ${primaryResponse.statusCode}',
        uri: Uri.tryParse(url),
      );
    } on Exception catch (exception) {
      primaryError = exception;
    }

    final fallbackUrl = ImageFallback.subUrlFrom(headers);
    if (fallbackUrl == null) {
      ImageLoadMonitor.recordFailure(
        url: url,
        error: primaryError,
        recovered: false,
      );
      if (primaryResponse != null) {
        // ステータス異常はキャッシュ層が HttpExceptionWithStatus を投げる。
        return primaryResponse;
      }
      throw primaryError;
    }

    try {
      final fallbackResponse = await _send(fallbackUrl, headers);
      if (fallbackResponse.statusCode == 200) {
        ImageLoadMonitor.recordFailure(
          url: url,
          error: primaryError,
          recovered: true,
        );
        return fallbackResponse;
      }
    } on Exception catch (_) {
      // 代わりの配信元の失敗は記録しない。原因を調べるのは主系の失敗。
    }

    ImageLoadMonitor.recordFailure(
      url: url,
      error: primaryError,
      recovered: false,
    );
    if (primaryResponse != null) {
      return primaryResponse;
    }
    throw primaryError;
  }

  Future<FileServiceResponse> _send(
    String url,
    Map<String, String>? headers,
  ) async {
    final request = http.Request('GET', Uri.parse(url));
    final sendHeaders = ImageFallback.withoutSubUrl(headers);
    if (sendHeaders != null) {
      request.headers.addAll(sendHeaders);
    }
    final response = await _httpClient.send(request).timeout(_responseTimeout);
    return HttpGetResponse(response);
  }
}
