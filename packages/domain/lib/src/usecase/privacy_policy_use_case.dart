import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/privacy_policy.dart';
import 'package:domain/src/repository/privacy_policy_repository.dart';

final privacyPolicyUseCaseProvider = Provider<PrivacyPolicyUseCase>(
  (ref) {
    final privacyPolicyUseCase = PrivacyPolicyUseCase(
      ref.watch(privacyPolicyRepositoryProvider),
    );
    ref.onDispose(privacyPolicyUseCase.dispose);
    return privacyPolicyUseCase;
  },
);

class PrivacyPolicyUseCase {
  PrivacyPolicyUseCase(
    this._privacyPolicyRepository,
  );

  final PrivacyPolicyRepository _privacyPolicyRepository;

  final _logger = Logger();

  Future<Result<PrivacyPolicy>> get() {
    return _privacyPolicyRepository.get();
  }

  void dispose() {
    _logger.d('PrivacyPolicyUseCase dispose');
  }
}
