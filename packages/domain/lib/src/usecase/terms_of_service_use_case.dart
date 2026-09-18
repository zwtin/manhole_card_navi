import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/terms_of_service.dart';
import '../entity/terms_of_service_version.dart';
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

/// 利用規約の表示と、同意の確認・記録。
class TermsOfServiceUseCase {
  TermsOfServiceUseCase(
    this._termsOfServiceRepository,
  );

  final TermsOfServiceRepository _termsOfServiceRepository;

  final _logger = Logger();

  Future<Result<TermsOfService>> get() {
    return _termsOfServiceRepository.get();
  }

  /// 利用規約への同意が必要か（まだ一度も同意していないか）。
  Future<Result<bool>> getNeedAgree() async {
    switch (await _termsOfServiceRepository.getAgreedVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(value: final agreedVersion):
        return Result.success(agreedVersion == null);
    }
  }

  /// 利用規約が更新されていて、再同意が必要か。
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

  /// 今の要求バージョンに同意したことを記録する。
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

  void dispose() {
    _logger.d('TermsOfServiceUseCase dispose');
  }
}
