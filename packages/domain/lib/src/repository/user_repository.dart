import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final userRepositoryProvider = Provider<UserRepository>(
  (ref) =>
      throw UnimplementedError('userRepositoryProvider must be overridden'),
);

/// アプリの利用者。
abstract class UserRepository {
  /// 利用者を識別できる状態にする。まだ登録していなければ匿名で登録する（初回だけ
  /// 通信が要る）。以降に送るイベントや障害の記録には、この利用者の ID が付く。
  Future<Result<void>> ensureSignedIn();
}
