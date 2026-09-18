import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/privacy_policy_dto.dart';
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

  Future<Result<PrivacyPolicyDTO>> get() async {
    switch (await _privacyPolicyRepository.get()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        return Result.success(PrivacyPolicyDTO(value: value.value));
    }
  }

  void dispose() {
    _logger.d('PrivacyPolicyUseCase dispose');
  }
}
