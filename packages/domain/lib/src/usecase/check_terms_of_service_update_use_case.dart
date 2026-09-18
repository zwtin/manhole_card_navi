import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/terms_of_service_version.dart';
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

  void dispose() {
    _logger.d('CheckTermsOfServiceUpdateUseCase dispose');
  }
}
