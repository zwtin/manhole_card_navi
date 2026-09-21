import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/image_load_monitor.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics analytics;
  late ImageLoadMonitor monitor;

  setUp(() {
    analytics = MockFirebaseAnalytics();
    when(
      () => analytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});
    monitor = ImageLoadMonitor(analytics);
  });

  /// 送られたイベントの中身を、送られた順に返す。
  List<Map<String, Object>> sentEvents() {
    return verify(
      () => analytics.logEvent(
        name: 'image_load_failed',
        parameters: captureAny(named: 'parameters'),
      ),
    ).captured.cast<Map<String, Object>>();
  }

  test('どの配信元で、どう失敗したかを送る', () async {
    monitor.recordFailure(
      url: 'https://r2.example.com/A.jpg',
      error: const HandshakeException('WRONG_VERSION_NUMBER(tls_record.cc)'),
    );
    await pumpEventQueue();

    expect(sentEvents().single, {
      'error_type': 'handshake_intercepted',
      'status_code': 0,
      'host': 'r2.example.com',
    });
  });

  test('失敗した数だけ送る', () async {
    for (var count = 0; count < 25; count++) {
      monitor.recordFailure(
        url: 'https://r2.example.com/A.jpg',
        error: const SocketException('だめ'),
      );
    }
    await pumpEventQueue();

    expect(sentEvents().length, 25);
  });

  test('遮断の方式ごとに、失敗の種類を分ける', () async {
    final errors = <Object, String>{
      const HandshakeException('WRONG_VERSION_NUMBER'): 'handshake_intercepted',
      const HandshakeException('CERTIFICATE_VERIFY_FAILED'): 'handshake',
      const SocketException('Failed host lookup'): 'dns',
      TimeoutException('だめ'): 'timeout',
      const SocketException('Connection timed out'): 'timeout',
      const SocketException('Connection reset by peer'): 'reset',
      const SocketException('Connection refused'): 'refused',
      const SocketException('だめ'): 'socket',
      HttpExceptionWithStatus(503, 'だめ'): 'status',
      StateError('だめ'): 'other',
    };
    for (final error in errors.keys) {
      monitor.recordFailure(url: 'https://r2/A.jpg', error: error);
    }
    await pumpEventQueue();

    expect(sentEvents().map((event) => event['error_type']), errors.values);
  });

  test('状態の異常は、その状態も送る', () async {
    monitor.recordFailure(
      url: 'https://r2/A.jpg',
      error: HttpExceptionWithStatus(503, 'だめ'),
    );
    await pumpEventQueue();

    expect(sentEvents().single['status_code'], 503);
  });

  test('送信に失敗しても、呼んだ側には伝わらない', () async {
    when(
      () => analytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => throw StateError('送れない'));

    monitor.recordFailure(
      url: 'https://r2/A.jpg',
      error: const SocketException('だめ'),
    );
    await pumpEventQueue();

    expect(sentEvents(), hasLength(1));
  });
}
