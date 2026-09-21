import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:data/src/model/analytics_event_model.dart';
import 'package:domain/domain.dart';

/// 計測するイベント（エンティティ）と、Analytics に送る形（model）の変換。
abstract final class AnalyticsEventMapper {
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
      ImageLoadFailed(:final host, :final errorType, :final statusCode) =>
        AnalyticsEventModel(
          name: 'image_load_failed',
          parameters: {
            'error_type': errorType,
            'status_code': statusCode,
            'host': host,
          },
        ),
    };
  }

  /// [url] から画像を取れなかったことを表すイベント。
  static AnalyticsEvent toImageLoadFailed({
    required String url,
    required Object error,
  }) {
    return AnalyticsEvent.imageLoadFailed(
      host: Uri.tryParse(url)?.host ?? '',
      errorType: _classify(error),
      statusCode: error is HttpExceptionWithStatus ? error.statusCode : 0,
    );
  }

  /// 遮断の方式によってエラーが違う（平文を返して割り込む＝ handshake_intercepted、
  /// DNS で潰す＝ dns、パケットを捨てる＝ timeout）ので、まとめずに分けて数える。
  static String _classify(Object error) {
    if (error is HttpExceptionWithStatus) {
      return 'status';
    }
    if (error is TimeoutException) {
      return 'timeout';
    }

    final text = error.toString();
    if (error is HandshakeException) {
      // 443 への応答が TLS ですらない＝経路上の装置が平文を返している。
      return text.contains('WRONG_VERSION_NUMBER')
          ? 'handshake_intercepted'
          : 'handshake';
    }
    if (error is SocketException) {
      if (text.contains('Failed host lookup')) {
        return 'dns';
      }
      if (text.contains('timed out')) {
        return 'timeout';
      }
      if (text.contains('reset by peer')) {
        return 'reset';
      }
      if (text.contains('refused')) {
        return 'refused';
      }
      return 'socket';
    }
    return 'other';
  }
}
