import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// カード画像の取得に失敗したことを Analytics に送る。
///
/// 1 件ずつ送る。どの配信元（[url] のホスト）で、どう失敗したかが分かればよく、
/// 利用者ごとの件数は Analytics 側で数える。
class ImageLoadMonitor {
  ImageLoadMonitor(this._analytics);

  final FirebaseAnalytics _analytics;

  void recordFailure({required String url, required Object error}) {
    unawaited(
      _analytics
          .logEvent(
            name: 'image_load_failed',
            parameters: <String, Object>{
              'error_type': _classify(error),
              'status_code':
                  error is HttpExceptionWithStatus ? error.statusCode : 0,
              'host': Uri.tryParse(url)?.host ?? '',
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
