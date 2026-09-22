import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/datasource/auth_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this._auth,
    this._analytics,
    this._crashlytics,
  );

  final AuthDataSource _auth;
  final AnalyticsDataSource _analytics;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<void>> signIn() async {
    try {
      // 匿名の利用者は端末に残るので、2 回目以降はオフラインでも済む。
      final userId = _auth.currentUserId ?? await _auth.signInAnonymously();
      if (userId == null) {
        throw const UnknownException(detail: '匿名ログインしたのに利用者がいません');
      }
      await _setUserId(userId);
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  /// ID を付けられなくてもアプリは使えるので、失敗は記録するだけで止めない。
  Future<void> _setUserId(String userId) async {
    try {
      await _analytics.setUserId(userId);
      await _crashlytics.setUserId(userId);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
    }
  }
}
