import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'package:data/src/model/malformed_data_exception.dart';
import 'package:domain/domain.dart';

abstract final class DomainExceptionMapper {
  static DomainException fromFirestore(Object error, StackTrace stackTrace) {
    if (_known(error, stackTrace) case final known?) {
      return known;
    }
    if (error is FirebaseException) {
      switch (error.code) {
        // サーバーの一時的な障害でもこのコードになるが、スマホではほとんどが電波。
        case 'unavailable':
          return OfflineException(cause: error, stackTrace: stackTrace);
        case 'deadline-exceeded':
          return TimedOutException(cause: error, stackTrace: stackTrace);
      }
    }
    if (error is TimeoutException) {
      return TimedOutException(cause: error, stackTrace: stackTrace);
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  static DomainException fromAuth(Object error, StackTrace stackTrace) {
    if (_known(error, stackTrace) case final known?) {
      return known;
    }
    if (error is FirebaseAuthException &&
        error.code == 'network-request-failed') {
      return OfflineException(cause: error, stackTrace: stackTrace);
    }
    if (error is TimeoutException) {
      return TimedOutException(cause: error, stackTrace: stackTrace);
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  static DomainException fromHttp(Object error, StackTrace stackTrace) {
    if (_known(error, stackTrace) case final known?) {
      return known;
    }
    if (error is TimeoutException) {
      return TimedOutException(cause: error, stackTrace: stackTrace);
    }
    if (error is HttpExceptionWithStatus) {
      return error.statusCode == HttpStatus.notFound
          ? NotFoundException(cause: error, stackTrace: stackTrace)
          : UnknownException(cause: error, stackTrace: stackTrace);
    }
    // 接続できない・名前が引けない・経路上のフィルタに割り込まれる など。利用者から
    // 見ればどれも通信できない。
    if (error is IOException || error is http.ClientException) {
      return OfflineException(cause: error, stackTrace: stackTrace);
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  /// 取れない原因はほぼ通信なので、通信できない失敗にする。
  static DomainException fromRemoteConfig(Object error, StackTrace stackTrace) {
    if (_known(error, stackTrace) case final known?) {
      return known;
    }
    if (error is FirebaseException) {
      return OfflineException(cause: error, stackTrace: stackTrace);
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  /// 端末の機能（通知・バッジ・位置情報・Analytics など）の失敗は、種類で対応を
  /// 変えないので、まとめて不明な失敗にする。
  static DomainException fromPlatform(Object error, StackTrace stackTrace) {
    if (_known(error, stackTrace) case final known?) {
      return known;
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  static DomainException fromLocalStorage(Object error, StackTrace stackTrace) {
    if (_known(error, stackTrace) case final known?) {
      return known;
    }
    return PersistenceException(cause: error, stackTrace: stackTrace);
  }

  static DomainException? _known(Object error, StackTrace stackTrace) {
    if (error is DomainException) {
      return error;
    }
    if (error is MalformedDataException) {
      return CorruptedDataException(
        detail: error.message,
        cause: error.cause,
        stackTrace: error.stackTrace ?? stackTrace,
      );
    }
    return null;
  }
}
