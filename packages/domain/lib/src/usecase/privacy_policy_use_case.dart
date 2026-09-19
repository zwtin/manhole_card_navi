import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/privacy_policy.dart';
import 'package:domain/src/repository/privacy_policy_repository.dart';

final privacyPolicyUseCaseProvider = Provider<PrivacyPolicyUseCase>(
  (ref) => PrivacyPolicyUseCase(
    ref.watch(privacyPolicyRepositoryProvider),
  ),
);

class PrivacyPolicyUseCase {
  PrivacyPolicyUseCase(
    this._privacyPolicyRepository,
  );

  final PrivacyPolicyRepository _privacyPolicyRepository;

  Future<Result<PrivacyPolicy>> get() {
    return _privacyPolicyRepository.get();
  }
}
