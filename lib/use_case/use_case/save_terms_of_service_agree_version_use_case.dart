import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/domain/entity/agreed_terms_of_service_version.dart';
import 'package:manhole_card_navi/domain/entity/inquired_terms_of_service_version.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/domain/repository/terms_of_service_repository.dart';
import '/infra/repository_impl/terms_of_service_repository_impl.dart';

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
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '利用規約のバージョンの取得に失敗しました',
        ),
      );
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
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '利用規約の同意バージョンの保存に失敗しました',
        ),
      );
    }

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('SaveTermsOfServiceAgreeVersionUseCase dispose');
  }
}
