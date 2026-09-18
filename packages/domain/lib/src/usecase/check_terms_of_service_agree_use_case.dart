import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/need_terms_of_service_agree_dto.dart';
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

  Future<Result<NeedTermsOfServiceAgreeDTO>> getNeedAgree() async {
    switch (await _termsOfServiceRepository.getAgreedVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final agreedVersion):
        return Result.success(
          NeedTermsOfServiceAgreeDTO(
            value: agreedVersion.value.isEmpty,
          ),
        );
    }
  }

  void dispose() {
    _logger.d('CheckTermsOfServiceAgreeUseCase dispose');
  }
}
