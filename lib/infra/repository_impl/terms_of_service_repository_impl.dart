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
    try {
      final termsOfService = _remoteConfig.getString('terms_of_service');
      return Result.success(
        TermsOfService(
          value: termsOfService,
        ),
      );
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '利用規約の取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<InquiredTermsOfServiceVersion>> getInquiredVersion() async {
    try {
      final inquiredTermsOfServiceVersion =
          _remoteConfig.getString('inquired_terms_of_service_version');
      return Result.success(
        InquiredTermsOfServiceVersion(
          value: inquiredTermsOfServiceVersion,
        ),
      );
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '要求利用規約バージョンの取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<AgreedTermsOfServiceVersion>> getAgreedVersion() async {
    try {
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
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '同意済み利用規約バージョンの取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<void>> setAgreedVersion({
    required AgreedTermsOfServiceVersion agreedTermsOfServiceVersion,
  }) async {
    try {
      final result = await _instance.setString(
        'agreed_terms_of_service_version',
        agreedTermsOfServiceVersion.value,
      );
      if (result) {
        return const Result.success(null);
      } else {
        throw const CustomException(
          title: 'エラー',
          text: 'データの更新に失敗しました。',
        );
      }
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '同意済み利用規約バージョンの保存に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('TermsOfServiceRepositoryImpl dispose');
  }
}
