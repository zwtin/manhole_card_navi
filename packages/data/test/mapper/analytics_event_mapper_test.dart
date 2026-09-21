import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:data/src/mapper/analytics_event_mapper.dart';
import 'package:domain/domain.dart';

void main() {
  group('toModel', () {
    test('アプリを開いたイベントは app_open', () {
      final model = AnalyticsEventMapper.toModel(const AnalyticsEvent.appOpen());

      expect(model.name, 'app_open');
      expect(model.parameters, isEmpty);
    });

    test('画面の表示は、画面の名前と補足を screen_pv で送る形にする', () {
      final model = AnalyticsEventMapper.toModel(
        const AnalyticsEvent.screenView(
          screenName: 'detail_view',
          parameters: {'card_id': '27-226-B001'},
        ),
      );

      expect(model.name, 'screen_pv');
      expect(model.parameters, {
        'screen_name': 'detail_view',
        'card_id': '27-226-B001',
      });
    });

    test('画像の取得の失敗は image_load_failed で送る形にする', () {
      final model = AnalyticsEventMapper.toModel(
        const AnalyticsEvent.imageLoadFailed(
          host: 'r2.example.com',
          errorType: 'dns',
          statusCode: 0,
        ),
      );

      expect(model.name, 'image_load_failed');
      expect(model.parameters, {
        'error_type': 'dns',
        'status_code': 0,
        'host': 'r2.example.com',
      });
    });
  });

  group('toImageLoadFailed', () {
    test('配信元のホストと、応答があればその状態を入れる', () {
      final event = AnalyticsEventMapper.toImageLoadFailed(
        url: 'https://r2.example.com/A.jpg',
        error: HttpExceptionWithStatus(503, 'だめ'),
      ) as ImageLoadFailed;

      expect(event.host, 'r2.example.com');
      expect(event.statusCode, 503);
      expect(event.errorType, 'status');
    });

    test('遮断の方式ごとに、失敗の種類を分ける', () {
      final errors = <Object, String>{
        const HandshakeException('WRONG_VERSION_NUMBER'):
            'handshake_intercepted',
        const HandshakeException('CERTIFICATE_VERIFY_FAILED'): 'handshake',
        const SocketException('Failed host lookup'): 'dns',
        TimeoutException('だめ'): 'timeout',
        const SocketException('Connection timed out'): 'timeout',
        const SocketException('Connection reset by peer'): 'reset',
        const SocketException('Connection refused'): 'refused',
        const SocketException('だめ'): 'socket',
        StateError('だめ'): 'other',
      };

      for (final entry in errors.entries) {
        final event = AnalyticsEventMapper.toImageLoadFailed(
          url: 'https://r2/A.jpg',
          error: entry.key,
        ) as ImageLoadFailed;

        expect(event.errorType, entry.value, reason: '${entry.key}');
      }
    });
  });
}
