import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

import '../datasource/failure_recorder.dart';
import '../mapper/domain_exception_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this._auth,
    this._analytics,
    this._crashlytics,
    this._failureRecorder,
  );

  final _logger = Logger();
  final FirebaseAuth _auth;
  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> ensureSignedIn() {
    return _failureRecorder.guard(
      () async {
        // 匿名ユーザーは端末に残るので、2 回目以降はオフラインでもここで済む。
        final user =
            _auth.currentUser ?? (await _auth.signInAnonymously()).user;
        if (user == null) {
          throw const UnknownException(detail: '匿名ログインしたのに利用者がいません');
        }
        await _setUserId(user.uid);
      },
      convert: DomainExceptionMapper.fromAuth,
    );
  }

  /// Analytics のイベントと Crashlytics の記録に、利用者の ID を付ける。付けられ
  /// なくてもアプリは使えるので、失敗は記録するだけで止めない。
  Future<void> _setUserId(String uid) async {
    try {
      await _analytics.setUserId(id: uid);
      await _crashlytics.setUserIdentifier(uid);
    } on Exception catch (error, stackTrace) {
      _failureRecorder.failure<void>(
        DomainExceptionMapper.fromPlatform(error, stackTrace),
        stackTrace,
      );
    }
  }

  void dispose() {
    _logger.d('UserRepositoryImpl dispose');
  }
}
