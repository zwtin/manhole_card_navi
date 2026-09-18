import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';

/// 外部の仕組みの失敗を、domain の失敗の種類（[DomainException]）に変換する。
///
/// どの失敗をどの種類にするかは data の知識なので、ここに集める。
abstract final class DomainExceptionConverter {
  /// Firestore の読み書きの失敗。
  static DomainException fromFirestore(Object error, StackTrace stackTrace) {
    if (error is FirebaseException) {
      switch (error.code) {
        // サーバー側の一時的な障害でもこのコードになるが、スマホでは電波の問題が
        // ほとんどなので、通信できない失敗として扱う。
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

  /// Remote Config の取得の失敗。取得できない原因はほぼ通信なので、通信できない
  /// 失敗として扱う。
  static DomainException fromRemoteConfig(Object error, StackTrace stackTrace) {
    if (error is FirebaseException) {
      return OfflineException(cause: error, stackTrace: stackTrace);
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  /// 端末の DB（Realm）や SharedPreferences の読み書きの失敗。
  static DomainException fromLocalStorage(Object error, StackTrace stackTrace) {
    return PersistenceException(cause: error, stackTrace: stackTrace);
  }
}
