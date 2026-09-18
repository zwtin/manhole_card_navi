import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/privacy_policy.dart';
import '../repository/privacy_policy_repository.dart';

final privacyPolicyUseCaseProvider = Provider.autoDispose<PrivacyPolicyUseCase>(
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
