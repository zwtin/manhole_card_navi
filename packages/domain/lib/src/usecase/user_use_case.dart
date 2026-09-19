import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/user_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
final userUseCaseProvider = Provider<UserUseCase>(
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

  /// 利用者としてログインする。[UserRepository.signIn] と同じ。
  Future<Result<void>> signIn() {
    return _userRepository.signIn();
  }

  void dispose() {
    _logger.d('UserUseCase dispose');
  }
}
