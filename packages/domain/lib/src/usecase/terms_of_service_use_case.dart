import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/terms_of_service.dart';
import 'package:domain/src/entity/terms_of_service_version.dart';
import 'package:domain/src/repository/terms_of_service_repository.dart';

final termsOfServiceUseCaseProvider =
    Provider<TermsOfServiceUseCase>(
  (ref) => TermsOfServiceUseCase(
    ref.watch(termsOfServiceRepositoryProvider),
  ),
);

class TermsOfServiceUseCase {
  TermsOfServiceUseCase(
    this._termsOfServiceRepository,
  );

  final TermsOfServiceRepository _termsOfServiceRepository;

  Future<Result<TermsOfService>> get() {
    return _termsOfServiceRepository.get();
  }

  Future<Result<bool>> getNeedAgree() async {
    switch (await _termsOfServiceRepository.getAgreedVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final agreedVersion):
        return Result.success(agreedVersion == null);
    }
  }

  Future<Result<bool>> getNeedUpdate() async {
    final TermsOfServiceVersion? agreedVersion;
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
        return Result.success(agreedVersion != inquiredVersion);
    }
  }

  Future<Result<void>> agree() async {
    switch (await _termsOfServiceRepository.getInquiredVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final inquiredVersion):
        return _termsOfServiceRepository.setAgreedVersion(
          version: inquiredVersion,
        );
    }
  }
}
