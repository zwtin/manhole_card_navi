import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

void main() {
  test('失敗の種類はそのまま通す', () {
    const exception = NotFoundException(detail: 'ない');

    expect(DomainExceptionMapper.from(exception), same(exception));
  });

  test('形の違いは、どこから読んだものでも壊れたデータにする', () {
    expect(
      DomainExceptionMapper.from(
        CheckedFromJsonException({}, 'name', 'FirestoreCardModel', '型が違います'),
      ),
      isA<CorruptedDataException>(),
    );
    expect(
      DomainExceptionMapper.from(const FormatException('JSON として読めません')),
      isA<CorruptedDataException>(),
    );
  });

  test('タイムアウトは、応答が遅すぎる失敗にする', () {
    expect(
      DomainExceptionMapper.from(TimeoutException('timeout')),
      isA<TimedOutException>(),
    );
  });

  group('Firebase', () {
    test('Firestore の unavailable は通信できない失敗、deadline-exceeded は遅すぎる失敗', () {
      expect(
        DomainExceptionMapper.from(
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        ),
        isA<OfflineException>(),
      );
      expect(
        DomainExceptionMapper.from(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'deadline-exceeded',
          ),
        ),
        isA<TimedOutException>(),
      );
    });

    test('Auth の通信の失敗は、通信できない失敗にする', () {
      expect(
        DomainExceptionMapper.from(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
        isA<OfflineException>(),
      );
    });

    test('Remote Config は、取れない原因がほぼ通信なので通信できない失敗にする', () {
      expect(
        DomainExceptionMapper.from(
          FirebaseException(
            plugin: 'firebase_remote_config',
            code: 'internal',
          ),
        ),
        isA<OfflineException>(),
      );
    });

    test('それ以外のコードは、不明な失敗にする', () {
      final exception = DomainExceptionMapper.from(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
        ),
      );

      expect(exception, isA<UnknownException>());
      expect(exception.detail, 'cloud_firestore/permission-denied');
    });
  });

  group('通信', () {
    test('経路上で割り込まれた・接続できない失敗は、通信できない失敗にする', () {
      for (final error in <Exception>[
        const HandshakeException('WRONG_VERSION_NUMBER(tls_record.cc:127)'),
        const SocketException('Failed host lookup'),
        http.ClientException('Connection closed'),
      ]) {
        expect(
          DomainExceptionMapper.from(error),
          isA<OfflineException>(),
          reason: '$error',
        );
      }
    });

    test('404 はデータがない失敗、それ以外のステータスは不明な失敗にする', () {
      expect(
        DomainExceptionMapper.from(
          const HttpExceptionWithStatus(404, 'Not Found'),
        ),
        isA<NotFoundException>(),
      );
      expect(
        DomainExceptionMapper.from(
          const HttpExceptionWithStatus(503, 'Service Unavailable'),
        ),
        isA<UnknownException>(),
      );
    });
  });

  test('ファイルを読み書きできない失敗は、保存できない失敗にする', () {
    expect(
      DomainExceptionMapper.from(
        const FileSystemException('書き込めません', '/master_data_v1.json'),
      ),
      isA<PersistenceException>(),
    );
  });

  test('知らない例外は、不明な失敗にする', () {
    expect(
      DomainExceptionMapper.from(Exception('なにか')),
      isA<UnknownException>(),
    );
  });
}
