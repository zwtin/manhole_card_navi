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
          errorRuntimeType: 'SocketException',
          osError: 'nodename nor servname provided',
          statusCode: 0,
        ),
      );

      expect(model.name, 'image_load_failed');
      expect(model.parameters, {
        'runtime_type': 'SocketException',
        'os_error': 'nodename nor servname provided',
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
      expect(event.errorRuntimeType, 'HttpExceptionWithStatus');
      expect(event.osError, isEmpty);
    });

    test('失敗の種類は例外の型名で送る', () {
      final types = <Object, String>{
        const HandshakeException('だめ'): 'HandshakeException',
        const SocketException('だめ'): 'SocketException',
        TimeoutException('だめ'): 'TimeoutException',
        StateError('だめ'): 'StateError',
      };

      for (final entry in types.entries) {
        final event = AnalyticsEventMapper.toImageLoadFailed(
          url: 'https://r2/A.jpg',
          error: entry.key,
        ) as ImageLoadFailed;

        expect(event.errorRuntimeType, entry.value, reason: '${entry.key}');
      }
    });

    test('遮断の方式は、OS が返したエラーで見分ける', () {
      final osErrors = <Object, String>{
        // 443 への応答が TLS ですらない＝経路上の装置が平文を返している。
        const HandshakeException(
          'Handshake error in client',
          OSError('WRONG_VERSION_NUMBER(tls_record.cc:242)'),
        ): 'WRONG_VERSION_NUMBER(tls_record.cc:242)',
        const SocketException(
          'Failed host lookup',
          osError: OSError('nodename nor servname provided'),
        ): 'nodename nor servname provided',
      };

      for (final entry in osErrors.entries) {
        final event = AnalyticsEventMapper.toImageLoadFailed(
          url: 'https://r2/A.jpg',
          error: entry.key,
        ) as ImageLoadFailed;

        expect(event.osError, entry.value, reason: '${entry.key}');
      }
    });

    test('OS のエラーがなければ空。長すぎるものは Analytics の上限で切る', () {
      final none = AnalyticsEventMapper.toImageLoadFailed(
        url: 'https://r2/A.jpg',
        error: TimeoutException('だめ'),
      ) as ImageLoadFailed;
      expect(none.osError, isEmpty);

      final long = AnalyticsEventMapper.toImageLoadFailed(
        url: 'https://r2/A.jpg',
        error: SocketException('だめ', osError: OSError('x' * 200)),
      ) as ImageLoadFailed;
      expect(long.osError.length, 100);
    });
  });
}
