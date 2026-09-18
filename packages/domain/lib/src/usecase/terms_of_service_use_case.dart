import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/terms_of_service.dart';
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

  Future<Result<TermsOfService>> get() {
    return _termsOfServiceRepository.get();
  }

  void dispose() {
    _logger.d('TermsOfServiceUseCase dispose');
  }
}
