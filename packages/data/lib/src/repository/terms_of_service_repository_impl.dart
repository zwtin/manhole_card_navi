import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';
import '../remote_config/remote_config_reader.dart';

class TermsOfServiceRepositoryImpl implements TermsOfServiceRepository {
  TermsOfServiceRepositoryImpl(
    this._instance,
  );

  /// 利用規約の HTML を配信する Remote Config のキー。
  static const _termsOfServiceKey = 'terms_of_service';

  /// 同意が必要な利用規約のバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_terms_of_service_version';

  /// 同意済みのバージョンを保存する SharedPreferences のキー。
  static const _agreedVersionKey = 'agreed_terms_of_service_version';

  final _logger = Logger();
  final _remoteConfigReader = RemoteConfigReader();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<TermsOfService>> get() async {
    try {
      final value = await _remoteConfigReader.readString(_termsOfServiceKey);
      return Result.success(TermsOfService(value: value));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<InquiredTermsOfServiceVersion>> getInquiredVersion() async {
    try {
      final value = await _remoteConfigReader.readString(_inquiredVersionKey);
      return Result.success(InquiredTermsOfServiceVersion(value: value));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<AgreedTermsOfServiceVersion>> getAgreedVersion() async {
    try {
      final value = _instance
          .getString(_agreedVersionKey, defaultValue: '')
          .getValue();
      return Result.success(AgreedTermsOfServiceVersion(value: value));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> setAgreedVersion({
    required AgreedTermsOfServiceVersion agreedTermsOfServiceVersion,
  }) async {
    try {
      final saved = await _instance.setString(
        _agreedVersionKey,
        agreedTermsOfServiceVersion.value,
      );
      if (!saved) {
        throw const PersistenceException(detail: '同意した利用規約のバージョンを保存できませんでした');
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('TermsOfServiceRepositoryImpl dispose');
  }
}
