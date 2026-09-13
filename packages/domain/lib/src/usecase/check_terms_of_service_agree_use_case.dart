import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../dto/need_terms_of_service_agree_dto.dart';
import '../entity/agreed_terms_of_service_version.dart';
import '../entity/custom_exception.dart';
import '../entity/result.dart';
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
    final result = await _termsOfServiceRepository.getAgreedVersion();
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

    final agreedVersion =
        (result as Success<AgreedTermsOfServiceVersion>).value;

    return Result.success(
      NeedTermsOfServiceAgreeDTO(
        value: agreedVersion.value.isEmpty,
      ),
    );
  }

  void dispose() {
    _logger.d('CheckTermsOfServiceAgreeUseCase dispose');
  }
}
