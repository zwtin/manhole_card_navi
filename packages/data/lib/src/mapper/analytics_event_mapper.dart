import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:data/src/model/analytics_event_model.dart';
import 'package:domain/domain.dart';

/// 計測するイベント（エンティティ）と、Analytics に送る形（model）の変換。
abstract final class AnalyticsEventMapper {
  /// Analytics のパラメータの値の上限。
  static const _maxValueLength = 100;

  static AnalyticsEventModel toModel(AnalyticsEvent event) {
    return switch (event) {
      AppOpen() => const AnalyticsEventModel(
          name: 'app_open',
          parameters: {},
        ),
      ScreenView(:final screenName, :final parameters) => AnalyticsEventModel(
          name: 'screen_pv',
          parameters: {'screen_name': screenName, ...parameters},
        ),
      ImageLoadFailed(
        :final host,
        :final errorRuntimeType,
        :final osError,
        :final statusCode,
      ) =>
        AnalyticsEventModel(
          name: 'image_load_failed',
          parameters: {
            'runtime_type': errorRuntimeType,
            'os_error': osError,
            'status_code': statusCode,
            'host': host,
          },
        ),
    };
  }

  /// [url] から画像を取れなかったことを表すイベント。
  ///
  /// 失敗の種類はこちらで名前を付けず、例外の型名と OS が返したエラーをそのまま
  /// 送る。遮断は方式によって別のエラーになる（平文を返して割り込む＝
  /// `WRONG_VERSION_NUMBER`、DNS で潰す＝ `nodename nor servname provided`）ので、
  /// OS のメッセージまで見れば区別できる。
  static AnalyticsEvent toImageLoadFailed({
    required String url,
    required Object error,
  }) {
    return AnalyticsEvent.imageLoadFailed(
      host: Uri.tryParse(url)?.host ?? '',
      errorRuntimeType: '${error.runtimeType}',
      osError: _osError(error),
      statusCode: error is HttpExceptionWithStatus ? error.statusCode : 0,
    );
  }

  static String _osError(Object error) {
    final message = switch (error) {
      HandshakeException(:final osError) ||
      SocketException(:final osError) ||
      FileSystemException(:final osError) =>
        osError?.message ?? '',
      _ => '',
    };
    return message.length <= _maxValueLength
        ? message
        : message.substring(0, _maxValueLength);
  }
}
