import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../dto/terms_of_service_dto.dart';
import '../entity/custom_exception.dart';
import '../entity/result.dart';
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

  Future<Result<TermsOfServiceDTO>> get() async {
    final result = await _termsOfServiceRepository.get();
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
    final termsOfService = (result as Success<TermsOfService>).value;
    return Result.success(
      TermsOfServiceDTO(
        value: termsOfService.value,
      ),
    );
  }

  void dispose() {
    _logger.d('TermsOfServiceUseCase dispose');
  }
}
