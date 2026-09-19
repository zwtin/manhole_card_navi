import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'image_fallback.dart';
import 'image_load_monitor.dart';

/// カード画像用の [CacheManager]。
///
/// 既定の [DefaultCacheManager] の代わりにこれを使う。主系（Cloudflare R2）で
/// 取得できなかった画像を Firebase Hosting から取り直す [_FallbackFileService] を
/// 差し込むためで、カード画像の取得（`CardRepositoryImpl.fetchImage`）はすべてこの 1 か所を
/// 通る。
///
/// キャッシュキーは [DefaultCacheManager] と同じ `libCachedImageData` にしてある。
/// 変えると既存端末のキャッシュが丸ごと無効になり、全員が画像を取り直すことに
/// なるため。**この定数は変更しないこと。**
///
/// 縮小した画像の保存（`getImageFile` の `maxWidth`）に [ImageCacheManager] を
/// mixin している。縮小画像のキー（`resized_w{幅}_{URL}`）もこのライブラリが作るので、
/// 以前の cached_network_image が保存したものをそのまま使える。
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

/// 主系で取れなければ代替配信元から取り直す [FileService]。
///
/// 代替配信元の URL はカードごとのデータ（master の `image_sub_url`）で、URL から
/// は導出できない。[ImageFallback] の仕組みで HTTP ヘッダに載せて運んでくる。
///
/// 失敗は [ImageLoadMonitor] に記録する。代替でも取れなかった場合は主系の
/// エラー／レスポンスをそのまま返し、キャッシュ層の通常のエラー処理に委ねる。
class _FallbackFileService extends FileService {
  _FallbackFileService() : _httpClient = _createClient();

  final http.Client _httpClient;

  /// レスポンスヘッダが返ってくるまでの待ち時間。
  ///
  /// dart:io の既定では OS のタイムアウト（Darwin で約75秒）まで待つため、
  /// 遮断されている端末ではフォールバックに移るまで1枚あたり75秒かかってしまう。
  /// 実用的な時間で見切りを付けて代替へ回す。
  static const Duration _responseTimeout = Duration(seconds: 12);

  static http.Client _createClient() {
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      // 1ホストへ同時に張る接続数の上限。既定は無制限で、モバイル回線に対して
      // 過剰な数の TLS ハンドシェイクを同時に投げると SYN が落ちて
      // ETIMEDOUT の原因になる。キャッシュ層の同時取得数（既定10）に合わせる。
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
      // 代替も失敗した場合は主系のエラーを記録する（原因の切り分けは主系側で行う）。
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
    // 代替配信元 URL の受け渡しに使っているヘッダは内部用なので送信しない。
    final sendHeaders = ImageFallback.withoutSubUrl(headers);
    if (sendHeaders != null) {
      request.headers.addAll(sendHeaders);
    }
    final response = await _httpClient.send(request).timeout(_responseTimeout);
    return HttpGetResponse(response);
  }
}
