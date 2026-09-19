import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final userRepositoryProvider = Provider<UserRepository>(
  (ref) =>
      throw UnimplementedError('userRepositoryProvider must be overridden'),
);

/// アプリの利用者。
abstract class UserRepository {
  /// 利用者としてログインする。以降に送るイベントや障害の記録には、この利用者の
  /// ID が付く。
  ///
  /// ログイン済みならそのまま済む。まだなら匿名で登録するので、初回だけ通信が要る。
  Future<Result<void>> signIn();
}
