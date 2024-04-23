import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/privacy_policy.dart';
import '/domain/entity/result.dart';
import '/domain/repository/privacy_policy_repository.dart';
import '/infra/repository_impl/privacy_policy_repository_impl.dart';
import '/use_case/dto/privacy_policy_dto.dart';

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
    final result = await _privacyPolicyRepository.get();
    if (result is Failure) {
      final exception = (result as Failure).exception;
      if (exception is CustomException) {
        return Result.failure(exception);
      } else {
        return const Result.failure(
          CustomException(
            title: 'エラー',
            text: '不明なエラーが発生しました。',
          ),
        );
      }
    }
    final privacyPolicy = (result as Success<PrivacyPolicy>).value;
    return Result.success(
      PrivacyPolicyDTO(
        value: privacyPolicy.value,
      ),
    );
  }

  void dispose() {
    _logger.d('PrivacyPolicyUseCase dispose');
  }
}
