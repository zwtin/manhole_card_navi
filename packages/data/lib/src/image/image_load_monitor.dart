import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// カード画像の取得失敗を計測して Analytics に送る。
///
/// 画像の取得はマスターデータの更新とは独立していて（マスター更新は Firestore →
/// Realm の保存までで、画像は表示時に個別に取得する）、失敗しても画面上は
/// 「出ない」だけで、これまでどこにも記録が残らなかった。配信元やネットワークの
/// 問題を数で把握できるようにするために入れている。
///
/// **イベント数の上限について**: 遮断されている端末では1セッションで数百〜数千枚が
/// 失敗しうる。Analytics に全部送るとイベント数を食い潰すため、送信は
/// [_maxEventsPerSession] 件までに絞る。件数そのものは [failureCount] に積み続け、
/// 各イベントに `failure_count`（その時点の累計）を載せるので、上限に達した後でも
/// 「そのセッションで何件失敗したか」は最後のイベントから読み取れる。
class ImageLoadMonitor {
  ImageLoadMonitor._();

  /// 1セッションあたりの Analytics 送信上限。
  static const int _maxEventsPerSession = 20;

  static int _sentEventCount = 0;

  /// このセッションで発生した画像取得の失敗回数（主系・代替を問わず最終的に失敗した数）。
  static int failureCount = 0;

  /// このセッションでフォールバックによって救済できた回数。
  static int fallbackSuccessCount = 0;

  /// 主系の取得に失敗したときに呼ぶ。
  ///
  /// [recovered] が true なら代替配信元から取得できた（＝ユーザーには画像が表示された）。
  static void recordFailure({
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
      FirebaseAnalytics.instance
          .logEvent(
            name: 'image_load_failed',
            parameters: <String, Object>{
              'error_type': classify(error),
              'status_code':
                  error is HttpExceptionWithStatus ? error.statusCode : 0,
              'host': Uri.tryParse(url)?.host ?? '',
              'recovered': recovered ? 1 : 0,
              'failure_count': failureCount,
              'fallback_success_count': fallbackSuccessCount,
            },
          )
          // 計測が本体の動作を止めないよう、送信失敗は無視する。
          .onError((_, __) {}),
    );
  }

  /// 失敗の種類をラベル化する。Analytics 上で内訳を見るために使う。
  ///
  /// 遮断は方式によって別々のエラーになる（平文を返す割り込み＝ handshake_intercepted、
  /// DNS で潰す＝ dns、パケットを捨てる＝ timeout）ので、まとめずに区別して数える。
  static String classify(Object error) {
    if (error is HttpExceptionWithStatus) {
      return 'status';
    }
    if (error is TimeoutException) {
      return 'timeout';
    }

    final text = error.toString();
    if (error is HandshakeException) {
      // 443 への応答が TLS レコードですらない＝経路上の装置が平文を返している。
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
