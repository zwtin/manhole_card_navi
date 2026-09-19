import 'dart:io';
import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../image/card_image_cache_manager.dart';
import '../image/image_fallback.dart';

/// ほかの Repository と違い、失敗を FailureRecorder で記録しない。画像の失敗は
/// ImageLoadMonitor（Analytics）と、表示側の FlutterError（Crashlytics の非重大）で
/// 記録している。遮断されている端末では画像の失敗が大量に出るので、ここでも記録すると
/// 二重になるうえ、ほかの失敗の記録が埋もれる。
class CardImageRepositoryImpl implements CardImageRepository {
  /// 保存せずに取るときの、本文を受け取り終えるまでの上限。応答が返り始めてから
  /// 止まった接続で、いつまでも待たないようにする。
  static const _bodyTimeout = Duration(seconds: 12);

  final _logger = Logger();

  @override
  Future<Result<Uint8List>> fetch({
    required String url,
    required String subUrl,
    int? maxWidth,
  }) async {
    if (url.isEmpty) {
      return const Result.failure(
        NotFoundException(detail: 'カード画像の URL がありません'),
      );
    }
    try {
      // 端末に保存済みなら、期限が切れていても先にそれが流れてくる（取り直しは
      // その後ろで行われ、失敗しても保存済みの画像は出せる）。最初の 1 件だけ使う。
      final response = await CardImageCacheManager()
          .getImageFile(
            url,
            headers: ImageFallback.headers(subUrl),
            maxWidth: maxWidth,
          )
          .firstWhere((response) => response is FileInfo);
      final file = (response as FileInfo).file;
      return Result.success(await file.readAsBytes());
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromHttp(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<Uint8List>> fetchWithoutStoring({
    required String url,
    required String subUrl,
  }) async {
    if (url.isEmpty) {
      return const Result.failure(
        NotFoundException(detail: 'カード画像の URL がありません'),
      );
    }
    try {
      final cacheManager = CardImageCacheManager();
      final cached = await cacheManager.getFileFromCache(url);
      if (cached != null) {
        return Result.success(await cached.file.readAsBytes());
      }
      // 画像キャッシュの保存数には上限（既定の 200 件）があり、古いものから消える。
      // ここで保存すると一覧の画像が先に消えて取り直しが増えるので、キャッシュ層を
      // 通さずに取る。代替の配信元への切り替えと失敗の計測は FileService の中で行う。
      final response = await cacheManager.config.fileService.get(
        url,
        headers: ImageFallback.headers(subUrl),
      );
      if (response.statusCode != HttpStatus.ok) {
        throw HttpExceptionWithStatus(
          response.statusCode,
          'Invalid statusCode: ${response.statusCode}',
          uri: Uri.tryParse(url),
        );
      }
      final bytes = await response.content
          .fold<BytesBuilder>(
            BytesBuilder(copy: false),
            (builder, chunk) => builder..add(chunk),
          )
          .timeout(_bodyTimeout);
      return Result.success(bytes.takeBytes());
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromHttp(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('CardImageRepositoryImpl dispose');
  }
}
