import 'dart:async';
import 'dart:io';

import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/model/malformed_data_exception.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  final stackTrace = StackTrace.current;

  FirebaseException firestoreError(String code) {
    return FirebaseException(plugin: 'cloud_firestore', code: code);
  }

  group('fromFirestore', () {
    test('unavailable は通信できない失敗にし、元の例外を残す', () {
      final error = firestoreError('unavailable');

      final exception = DomainExceptionMapper.fromFirestore(
        error,
        stackTrace,
      );

      expect(exception, isA<OfflineException>());
      expect(exception.cause, same(error));
      expect(exception.stackTrace, same(stackTrace));
    });

    test('deadline-exceeded とタイムアウトは、応答が遅すぎる失敗にする', () {
      expect(
        DomainExceptionMapper.fromFirestore(
          firestoreError('deadline-exceeded'),
          stackTrace,
        ),
        isA<TimedOutException>(),
      );
      expect(
        DomainExceptionMapper.fromFirestore(
          TimeoutException('timeout'),
          stackTrace,
        ),
        isA<TimedOutException>(),
      );
    });

    test('それ以外は不明な失敗にする', () {
      expect(
        DomainExceptionMapper.fromFirestore(
          firestoreError('permission-denied'),
          stackTrace,
        ),
        isA<UnknownException>(),
      );
    });
  });

  test('DataSource・model の形の違いは、どこから読んだものでも壊れたデータにする', () {
    final cause = Exception('decode');
    final causeStackTrace = StackTrace.current;
    final error = MalformedDataException(
      'master/0006/cards/A の name が読めません',
      cause: cause,
      stackTrace: causeStackTrace,
    );

    for (final convert in [
      DomainExceptionMapper.fromFirestore,
      DomainExceptionMapper.fromRemoteConfig,
      DomainExceptionMapper.fromLocalStorage,
      DomainExceptionMapper.fromPlatform,
    ]) {
      final exception = convert(error, stackTrace);

      expect(exception, isA<CorruptedDataException>());
      expect(exception.detail, 'master/0006/cards/A の name が読めません');
      expect(exception.cause, same(cause));
      expect(exception.stackTrace, same(causeStackTrace));
    }
  });

  test('端末の DB などの失敗は、保存できない失敗にする', () {
    expect(
      DomainExceptionMapper.fromLocalStorage(Exception('io'), stackTrace),
      isA<PersistenceException>(),
    );
  });

  group('fromHttp', () {
    test('経路上で割り込まれた・接続できない失敗は、通信できない失敗にする', () {
      for (final error in <Exception>[
        const HandshakeException('WRONG_VERSION_NUMBER(tls_record.cc:127)'),
        const SocketException('Failed host lookup'),
        http.ClientException('Connection closed'),
      ]) {
        final exception = DomainExceptionMapper.fromHttp(error, stackTrace);

        expect(exception, isA<OfflineException>(), reason: '$error');
        expect(exception.cause, same(error));
      }
    });

    test('タイムアウトは、応答が遅すぎる失敗にする', () {
      expect(
        DomainExceptionMapper.fromHttp(TimeoutException(''), stackTrace),
        isA<TimedOutException>(),
      );
    });

    test('404 はデータがない失敗、それ以外のステータスは不明な失敗にする', () {
      expect(
        DomainExceptionMapper.fromHttp(
          const HttpExceptionWithStatus(404, 'Not Found'),
          stackTrace,
        ),
        isA<NotFoundException>(),
      );
      expect(
        DomainExceptionMapper.fromHttp(
          const HttpExceptionWithStatus(503, 'Service Unavailable'),
          stackTrace,
        ),
        isA<UnknownException>(),
      );
    });
  });

  group('fromAuth', () {
    test('通信の失敗は、通信できない失敗にする', () {
      expect(
        DomainExceptionMapper.fromAuth(
          FirebaseAuthException(code: 'network-request-failed'),
          stackTrace,
        ),
        isA<OfflineException>(),
      );
    });

    test('それ以外は、不明な失敗にする', () {
      expect(
        DomainExceptionMapper.fromAuth(
          FirebaseAuthException(code: 'operation-not-allowed'),
          stackTrace,
        ),
        isA<UnknownException>(),
      );
    });
  });
}
