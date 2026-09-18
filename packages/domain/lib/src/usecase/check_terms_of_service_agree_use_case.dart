import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/terms_of_service_repository.dart';

final checkTermsOfServiceAgreeUseCaseProvider =
    Provider.autoDispose<CheckTermsOfServiceAgreeUseCase>(
  (ref) {
    final checkTermsOfServiceAgreeUseCase = CheckTermsOfServiceAgreeUseCase(
      ref.watch(termsOfServiceRepositoryProvider),
    );
    ref.onDispose(checkTermsOfServiceAgreeUseCase.dispose);
    return checkTermsOfServiceAgreeUseCase;
  },
);

class CheckTermsOfServiceAgreeUseCase {
  CheckTermsOfServiceAgreeUseCase(
    this._termsOfServiceRepository,
  );

  final TermsOfServiceRepository _termsOfServiceRepository;

  final _logger = Logger();

  /// 利用規約への同意が必要か（まだ一度も同意していないか）。
  Future<Result<bool>> getNeedAgree() async {
    switch (await _termsOfServiceRepository.getAgreedVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final agreedVersion):
        return Result.success(agreedVersion == null);
    }
  }

  void dispose() {
    _logger.d('CheckTermsOfServiceAgreeUseCase dispose');
  }
}
