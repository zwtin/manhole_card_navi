import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../entity/agreed_terms_of_service_version.dart';
import '../entity/custom_exception.dart';
import '../entity/inquired_terms_of_service_version.dart';
import '../entity/result.dart';
import '../repository/terms_of_service_repository.dart';

final saveTermsOfServiceAgreeVersionUseCaseProvider =
    Provider.autoDispose<SaveTermsOfServiceAgreeVersionUseCase>(
  (ref) {
    final saveTermsOfServiceAgreeVersionUseCase =
        SaveTermsOfServiceAgreeVersionUseCase(
      ref.watch(termsOfServiceRepositoryProvider),
    );
    ref.onDispose(saveTermsOfServiceAgreeVersionUseCase.dispose);
    return saveTermsOfServiceAgreeVersionUseCase;
  },
);

class SaveTermsOfServiceAgreeVersionUseCase {
  SaveTermsOfServiceAgreeVersionUseCase(
    this._termsOfServiceRepository,
  );

  final TermsOfServiceRepository _termsOfServiceRepository;

  final _logger = Logger();

  Future<Result<void>> save() async {
    final getInquiredVersionResult =
        await _termsOfServiceRepository.getInquiredVersion();
    if (getInquiredVersionResult is Failure) {
      final exception = (getInquiredVersionResult as Failure).exception;
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

    final inquiredVersion =
        (getInquiredVersionResult as Success<InquiredTermsOfServiceVersion>)
            .value;
    final agreedVersion =
        AgreedTermsOfServiceVersion(value: inquiredVersion.value);

    final setAgreedVersionResult =
        await _termsOfServiceRepository.setAgreedVersion(
      agreedTermsOfServiceVersion: agreedVersion,
    );
    if (setAgreedVersionResult is Failure) {
      final exception = setAgreedVersionResult.exception;
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

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('SaveTermsOfServiceAgreeVersionUseCase dispose');
  }
}
