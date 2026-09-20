import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:data/src/datasource/image_fallback.dart';
import 'package:data/src/datasource/image_load_monitor.dart';

/// 主系で取れなければ、代わりの配信元（[ImageFallback]）から取り直す。
class FallbackFileService extends FileService {
  FallbackFileService({required ImageLoadMonitor monitor, http.Client? client})
      : _monitor = monitor,
        _httpClient = client ?? createClient();

  final ImageLoadMonitor _monitor;
  final http.Client _httpClient;

  /// dart:io の既定では OS のタイムアウト（Darwin で約 75 秒）まで待ち、遮断されて
  /// いる端末で代わりの配信元に移るのが遅れる。
  static const Duration _responseTimeout = Duration(seconds: 12);

  static http.Client createClient() {
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

    try {
      final fallbackResponse = await _send(
        ImageFallback.subUrlFrom(headers),
        headers,
      );
      if (fallbackResponse.statusCode == 200) {
        _monitor.recordFailure(
          url: url,
          error: primaryError,
          recovered: true,
        );
        return fallbackResponse;
      }
    } on Exception catch (_) {
      // 代わりの配信元の失敗は記録しない。原因を調べるのは主系の失敗。
    }

    _monitor.recordFailure(url: url, error: primaryError, recovered: false);
    if (primaryResponse != null) {
      // ステータス異常はキャッシュ層が HttpExceptionWithStatus を投げる。
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
