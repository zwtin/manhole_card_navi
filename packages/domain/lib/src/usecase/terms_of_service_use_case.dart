import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../dto/terms_of_service_dto.dart';
import '../repository/terms_of_service_repository.dart';

final termsOfServiceUseCaseProvider =
    Provider.autoDispose<TermsOfServiceUseCase>(
  (ref) {
    final termsOfServiceUseCase = TermsOfServiceUseCase(
      ref.watch(termsOfServiceRepositoryProvider),
    );
    ref.onDispose(termsOfServiceUseCase.dispose);
    return termsOfServiceUseCase;
  },
);

class TermsOfServiceUseCase {
  TermsOfServiceUseCase(
    this._termsOfServiceRepository,
  );

  final TermsOfServiceRepository _termsOfServiceRepository;

  final _logger = Logger();

  Future<Result<TermsOfServiceDTO>> get() async {
    switch (await _termsOfServiceRepository.get()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        return Result.success(TermsOfServiceDTO(value: value.value));
    }
  }

  void dispose() {
    _logger.d('TermsOfServiceUseCase dispose');
  }
}
