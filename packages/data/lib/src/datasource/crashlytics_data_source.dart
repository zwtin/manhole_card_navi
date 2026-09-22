import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsDataSource {
  CrashlyticsDataSource(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  void recordNonFatal(Object error, StackTrace stackTrace) {
    _guard(_crashlytics.recordError(error, stackTrace, fatal: false));
  }

  /// [reason] は、どこで起きたかの補足。
  void recordFatal(Object error, StackTrace stackTrace, {String? reason}) {
    _guard(
      _crashlytics.recordError(error, stackTrace, reason: reason, fatal: true),
    );
  }

  /// スタックトレースの組み立てが違うので、口を分ける。
  void recordFlutter(FlutterErrorDetails details) {
    _guard(_crashlytics.recordFlutterFatalError(details));
  }

  Future<void> setUserId(String id) => _crashlytics.setUserIdentifier(id);

  /// 記録の失敗は記録できないので、ここだけは Error も含めて捨てる。投げ直すと
  /// Zone から同じ記録を呼び直して堂々巡りになる。
  void _guard(Future<void> recording) {
    unawaited(recording.onError((_, __) {}));
  }
}
