import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/agreed_terms_of_service_version.dart';
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

  /// 今の要求バージョンに同意したことを記録する。
  Future<Result<void>> save() async {
    switch (await _termsOfServiceRepository.getInquiredVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final inquiredVersion):
        return _termsOfServiceRepository.setAgreedVersion(
          agreedTermsOfServiceVersion: AgreedTermsOfServiceVersion(
            value: inquiredVersion.value,
          ),
        );
    }
  }

  void dispose() {
    _logger.d('SaveTermsOfServiceAgreeVersionUseCase dispose');
  }
}
