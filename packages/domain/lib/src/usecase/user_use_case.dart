import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/user_repository.dart';

final userUseCaseProvider = Provider.autoDispose<UserUseCase>(
  (ref) {
    final userUseCase = UserUseCase(
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(userUseCase.dispose);
    return userUseCase;
  },
);

class UserUseCase {
  UserUseCase(
    this._userRepository,
  );

  final UserRepository _userRepository;

  final _logger = Logger();

  /// 利用者を識別できる状態にする。[UserRepository.ensureSignedIn] と同じ。
  Future<Result<void>> ensureSignedIn() {
    return _userRepository.ensureSignedIn();
  }

  void dispose() {
    _logger.d('UserUseCase dispose');
  }
}
