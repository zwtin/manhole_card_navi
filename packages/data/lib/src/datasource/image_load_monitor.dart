import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 送るのは 1 セッション [_maxEventsPerSession] 件まで。遮断されている端末では
/// 数百〜数千枚が失敗し、Analytics のイベント数を食い潰すため。各イベントに
/// その時点の累計（`failure_count`）を載せるので、上限の後もセッションの失敗数は
/// 最後のイベントから読める。
class ImageLoadMonitor {
  ImageLoadMonitor(this._analytics);

  static const int _maxEventsPerSession = 20;

  final FirebaseAnalytics _analytics;

  int _sentEventCount = 0;

  /// 代わりの配信元でも取れなかった数。
  int failureCount = 0;

  int fallbackSuccessCount = 0;

  /// 主系で取れなかったときに呼ぶ。
  void recordFailure({
    required String url,
    required Object error,
    required bool recovered,
  }) {
    if (recovered) {
      fallbackSuccessCount++;
    } else {
      failureCount++;
    }

    if (_sentEventCount >= _maxEventsPerSession) {
      return;
    }
    _sentEventCount++;

    unawaited(
      _analytics
          .logEvent(
            name: 'image_load_failed',
            parameters: <String, Object>{
              'error_type': _classify(error),
              'status_code':
                  error is HttpExceptionWithStatus ? error.statusCode : 0,
              'host': Uri.tryParse(url)?.host ?? '',
              'recovered': recovered ? 1 : 0,
              'failure_count': failureCount,
              'fallback_success_count': fallbackSuccessCount,
            },
          )
          // 送れなくても本体の動作は止めない。
          .onError((_, __) {}),
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
