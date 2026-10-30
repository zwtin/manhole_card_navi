import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) =>
      throw UnimplementedError('userRepositoryProvider must be overridden'),
);

abstract class UserRepository {
  /// 以降に送るイベントと障害の記録に、利用者の ID が付く。ログイン済みなら
  /// 通信せずに済む。
  Future<Result<void>> signIn();
}
