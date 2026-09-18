import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/need_terms_of_service_update_dto.dart';
import '../entity/agreed_terms_of_service_version.dart';
import '../repository/terms_of_service_repository.dart';

final checkTermsOfServiceUpdateUseCaseProvider =
    Provider.autoDispose<CheckTermsOfServiceUpdateUseCase>(
  (ref) {
    final checkTermsOfServiceUpdateUseCase = CheckTermsOfServiceUpdateUseCase(
      ref.watch(termsOfServiceRepositoryProvider),
    );
    ref.onDispose(checkTermsOfServiceUpdateUseCase.dispose);
    return checkTermsOfServiceUpdateUseCase;
  },
);

class CheckTermsOfServiceUpdateUseCase {
  CheckTermsOfServiceUpdateUseCase(
    this._termsOfServiceRepository,
  );

  final TermsOfServiceRepository _termsOfServiceRepository;

  final _logger = Logger();

  Future<Result<NeedTermsOfServiceUpdateDTO>> getNeedUpdate() async {
    final AgreedTermsOfServiceVersion agreedVersion;
    switch (await _termsOfServiceRepository.getAgreedVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        agreedVersion = value;
    }

    switch (await _termsOfServiceRepository.getInquiredVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final inquiredVersion):
        return Result.success(
          NeedTermsOfServiceUpdateDTO(
            value: agreedVersion.value != inquiredVersion.value,
          ),
        );
    }
  }

  void dispose() {
    _logger.d('CheckTermsOfServiceUpdateUseCase dispose');
  }
}
