import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/repository/user_repository.dart';

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

  Future<Result<void>> signIn() {
    return _userRepository.signIn();
  }

  void dispose() {
    _logger.d('UserUseCase dispose');
  }
}
