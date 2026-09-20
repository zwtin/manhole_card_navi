import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Crashlytics への記録。
class CrashlyticsDataSource {
  CrashlyticsDataSource(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  /// 調べるために残す。アプリはそのまま動き続ける。
  void recordNonFatal(Object error, StackTrace stackTrace) {
    _record(error, stackTrace, fatal: false);
  }

  /// クラッシュとして残す。[reason] は、どこで起きたかの補足。
  void recordFatal(Object error, StackTrace stackTrace, {String? reason}) {
    _record(error, stackTrace, fatal: true, reason: reason);
  }

  Future<void> setUserId(String id) => _crashlytics.setUserIdentifier(id);

  void _record(
    Object error,
    StackTrace stackTrace, {
    required bool fatal,
    String? reason,
  }) {
    unawaited(
      _crashlytics
          .recordError(error, stackTrace, reason: reason, fatal: fatal)
          // 記録の失敗で本体の動作を止めない。
          .onError((_, __) {}),
    );
  }
}
