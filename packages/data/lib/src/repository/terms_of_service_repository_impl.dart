import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/preferences_data_source.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class TermsOfServiceRepositoryImpl implements TermsOfServiceRepository {
  TermsOfServiceRepositoryImpl(
    this._preferences,
    this._remoteConfig,
    this._crashlytics,
  );

  static const _termsOfServiceKey = 'terms_of_service';
  static const _inquiredVersionKey = 'inquired_terms_of_service_version';
  static const _agreedVersionKey = 'agreed_terms_of_service_version';

  final PreferencesDataSource _preferences;
  final RemoteConfigDataSource _remoteConfig;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<TermsOfService>> get() async {
    try {
      return Result.success(
        TermsOfService(
          value: await _remoteConfig.readString(_termsOfServiceKey),
        ),
      );
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<TermsOfServiceVersion>> getInquiredVersion() async {
    try {
      return Result.success(
        TermsOfServiceVersion(
          value: await _remoteConfig.readString(_inquiredVersionKey),
        ),
      );
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<TermsOfServiceVersion?>> getAgreedVersion() async {
    try {
      final value = _preferences.readString(_agreedVersionKey);
      return Result.success(
        value.isEmpty ? null : TermsOfServiceVersion(value: value),
      );
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<void>> setAgreedVersion({
    required TermsOfServiceVersion version,
  }) async {
    try {
      if (!await _preferences.writeString(_agreedVersionKey, version.value)) {
        throw const PersistenceException(
          detail: '同意した利用規約のバージョンを保存できませんでした',
        );
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
