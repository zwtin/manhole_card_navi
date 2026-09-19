import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

/// 外部の仕組みの失敗を、domain の失敗の種類（[DomainException]）に変換する。
///
/// どの失敗をどの種類にするかは data の知識なので、ここに集める。すでに
/// [DomainException] になっているもの（実装の中で投げたもの）はそのまま返すので、
/// 実装は `on Exception catch` 1 つでここに渡せばよい。
abstract final class DomainExceptionConverter {
  /// Firestore の読み書きの失敗。
  static DomainException fromFirestore(Object error, StackTrace stackTrace) {
    if (error is DomainException) {
      return error;
    }
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

  /// 画像など、HTTP で配信元から取るときの失敗。
  static DomainException fromHttp(Object error, StackTrace stackTrace) {
    if (error is DomainException) {
      return error;
    }
    if (error is TimeoutException) {
      return TimedOutException(cause: error, stackTrace: stackTrace);
    }
    if (error is HttpExceptionWithStatus) {
      return error.statusCode == HttpStatus.notFound
          ? NotFoundException(cause: error, stackTrace: stackTrace)
          : UnknownException(cause: error, stackTrace: stackTrace);
    }
    // 接続できない・名前が引けない・TLS の途中で割り込まれる（経路上のフィルタ）
    // など。どれも利用者から見れば通信できない失敗。
    if (error is IOException || error is http.ClientException) {
      return OfflineException(cause: error, stackTrace: stackTrace);
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  /// Remote Config の取得の失敗。取得できない原因はほぼ通信なので、通信できない
  /// 失敗として扱う。
  static DomainException fromRemoteConfig(Object error, StackTrace stackTrace) {
    if (error is DomainException) {
      return error;
    }
    if (error is FirebaseException) {
      return OfflineException(cause: error, stackTrace: stackTrace);
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  /// 端末の機能（通知・バッジ・位置情報・Analytics など）の失敗。種類を
  /// 見分けて対応を変える必要がないので、まとめて不明な失敗にする。
  static DomainException fromPlatform(Object error, StackTrace stackTrace) {
    if (error is DomainException) {
      return error;
    }
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  /// 端末の DB（Realm）や SharedPreferences の読み書きの失敗。
  static DomainException fromLocalStorage(Object error, StackTrace stackTrace) {
    if (error is DomainException) {
      return error;
    }
    return PersistenceException(cause: error, stackTrace: stackTrace);
  }
}
