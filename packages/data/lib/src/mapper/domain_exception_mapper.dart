import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import 'package:domain/domain.dart';

abstract final class DomainExceptionMapper {
  /// 判定は上から順に当たるので、狭い型を先に置く（`HttpExceptionWithStatus` と
  /// `FileSystemException` は `IOException` の一種）。
  static DomainException from(Object error) {
    return switch (error) {
      DomainException() => error,
      CheckedFromJsonException() => CorruptedDataException(
          detail: '${error.className} の ${error.key} が読めません（${error.message}）',
        ),
      FormatException() => CorruptedDataException(detail: error.message),
      TimeoutException() => const TimedOutException(),
      FirebaseException() => _fromFirebase(error),
      HttpExceptionWithStatus() => error.statusCode == HttpStatus.notFound
          ? NotFoundException(detail: '${error.uri} がありません')
          : UnknownException(detail: '${error.uri} が ${error.statusCode}'),
      http.ClientException() => const OfflineException(),
      FileSystemException() => PersistenceException(detail: error.message),
      // 接続できない・名前が引けない・経路上のフィルタに割り込まれる など。利用者
      // から見ればどれも通信できない。
      IOException() => const OfflineException(),
      _ => UnknownException(detail: '${error.runtimeType}'),
    };
  }

  static DomainException _fromFirebase(FirebaseException error) {
    final detail = '${error.plugin}/${error.code}';
    // Remote Config が取れない原因はほぼ通信。
    if (error.plugin == 'firebase_remote_config') {
      return OfflineException(detail: detail);
    }
    return switch (error.code) {
      // サーバーの一時的な障害でもこのコードになるが、スマホではほとんどが電波。
      'unavailable' || 'network-request-failed' => OfflineException(
          detail: detail,
        ),
      'deadline-exceeded' => TimedOutException(detail: detail),
      _ => UnknownException(detail: detail),
    };
  }
}
