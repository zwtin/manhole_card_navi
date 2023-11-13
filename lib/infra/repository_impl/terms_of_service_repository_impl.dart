import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/domain/entity/agreed_terms_of_service_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_terms_of_service_version.dart';
import '/domain/entity/result.dart';
import '/domain/entity/terms_of_service.dart';
import '/domain/repository/terms_of_service_repository.dart';
import '/temporary_provider.dart';

final termsOfServiceRepositoryProvider =
    Provider.autoDispose<TermsOfServiceRepository>(
  (ref) {
    final termsOfServiceRepository = TermsOfServiceRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(termsOfServiceRepository.dispose);
    return termsOfServiceRepository;
  },
);

class TermsOfServiceRepositoryImpl implements TermsOfServiceRepository {
  TermsOfServiceRepositoryImpl(
    this._instance,
  );

  final _logger = Logger();
  final _remoteConfig = FirebaseRemoteConfig.instance;
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<TermsOfService>> get() async {
    final termsOfService = _remoteConfig.getString('terms_of_service');
    return Result.success(
      TermsOfService(
        value: termsOfService,
      ),
    );
  }

  @override
  Future<Result<InquiredTermsOfServiceVersion>> getInquiredVersion() async {
    final inquiredTermsOfServiceVersion =
        _remoteConfig.getString('inquired_terms_of_service_version');
    return Result.success(
      InquiredTermsOfServiceVersion(
        value: inquiredTermsOfServiceVersion,
      ),
    );
  }

  @override
  Future<Result<AgreedTermsOfServiceVersion>> getAgreedVersion() async {
    final agreedTermsOfServiceVersion = _instance
        .getString(
          'agreed_terms_of_service_version',
          defaultValue: '',
        )
        .getValue();
    return Result.success(
      AgreedTermsOfServiceVersion(
        value: agreedTermsOfServiceVersion,
      ),
    );
  }

  @override
  Future<Result<void>> setAgreedVersion({
    required AgreedTermsOfServiceVersion agreedTermsOfServiceVersion,
  }) async {
    final result = await _instance.setString(
      'agreed_terms_of_service_version',
      agreedTermsOfServiceVersion.value,
    );
    if (result) {
      return const Result.success(null);
    } else {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'バージョンの保存に失敗しました',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('TermsOfServiceRepositoryImpl dispose');
  }
}
