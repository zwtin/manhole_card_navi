import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/src/exception/domain_exception_converter.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final stackTrace = StackTrace.current;

  FirebaseException firestoreError(String code) {
    return FirebaseException(plugin: 'cloud_firestore', code: code);
  }

  group('fromFirestore', () {
    test('unavailable は通信できない失敗にし、元の例外を残す', () {
      final error = firestoreError('unavailable');

      final exception = DomainExceptionConverter.fromFirestore(
        error,
        stackTrace,
      );

      expect(exception, isA<OfflineException>());
      expect(exception.cause, same(error));
      expect(exception.stackTrace, same(stackTrace));
    });

    test('deadline-exceeded とタイムアウトは、応答が遅すぎる失敗にする', () {
      expect(
        DomainExceptionConverter.fromFirestore(
          firestoreError('deadline-exceeded'),
          stackTrace,
        ),
        isA<TimedOutException>(),
      );
      expect(
        DomainExceptionConverter.fromFirestore(
          TimeoutException('timeout'),
          stackTrace,
        ),
        isA<TimedOutException>(),
      );
    });

    test('それ以外は不明な失敗にする', () {
      expect(
        DomainExceptionConverter.fromFirestore(
          firestoreError('permission-denied'),
          stackTrace,
        ),
        isA<UnknownException>(),
      );
    });
  });

  test('端末の DB などの失敗は、保存できない失敗にする', () {
    expect(
      DomainExceptionConverter.fromLocalStorage(Exception('io'), stackTrace),
      isA<PersistenceException>(),
    );
  });
}
