import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/repository/user_repository.dart';

final userUseCaseProvider = Provider<UserUseCase>(
  (ref) => UserUseCase(
    ref.watch(userRepositoryProvider),
  ),
);

class UserUseCase {
  UserUseCase(
    this._userRepository,
  );

  final UserRepository _userRepository;

  Future<Result<void>> signIn() {
    return _userRepository.signIn();
  }
}
