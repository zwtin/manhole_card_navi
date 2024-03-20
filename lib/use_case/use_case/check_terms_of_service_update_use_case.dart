import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/agreed_terms_of_service_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_terms_of_service_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/terms_of_service_repository.dart';
import '/infra/repository_impl/terms_of_service_repository_impl.dart';
import '/use_case/dto/need_terms_of_service_update_dto.dart';

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
    final result = await Future.wait([
      _termsOfServiceRepository.getAgreedVersion(),
      _termsOfServiceRepository.getInquiredVersion(),
    ]);

    if (result.whereType<Failure>().isNotEmpty) {
      final exception =
          (result.firstWhere((element) => element is Failure) as Failure)
              .exception;
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
        (result.elementAt(0) as Success<AgreedTermsOfServiceVersion>).value;
    final inquiredVersion =
        (result.elementAt(1) as Success<InquiredTermsOfServiceVersion>).value;

    return Result.success(
      NeedTermsOfServiceUpdateDTO(
        value: agreedVersion.value != inquiredVersion.value,
      ),
    );
  }

  void dispose() {
    _logger.d('CheckTermsOfServiceUpdateUseCase dispose');
  }
}
