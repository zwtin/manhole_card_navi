import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class TermsOfServiceRepositoryImpl implements TermsOfServiceRepository {
  TermsOfServiceRepositoryImpl(
    this._preferences,
    this._remoteConfig,
    this._failureRecorder,
  );

  static const _termsOfServiceKey = 'terms_of_service';
  static const _inquiredVersionKey = 'inquired_terms_of_service_version';
  static const _agreedVersionKey = 'agreed_terms_of_service_version';

  final StreamingSharedPreferences _preferences;
  final RemoteConfigDataSource _remoteConfig;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<TermsOfService>> get() {
    return _failureRecorder.guard(
      () async => TermsOfService(
        value: await _remoteConfig.readString(_termsOfServiceKey),
      ),
      convert: DomainExceptionMapper.fromRemoteConfig,
    );
  }

  @override
  Future<Result<TermsOfServiceVersion>> getInquiredVersion() {
    return _failureRecorder.guard(
      () async => TermsOfServiceVersion(
        value: await _remoteConfig.readString(_inquiredVersionKey),
      ),
      convert: DomainExceptionMapper.fromRemoteConfig,
    );
  }

  @override
  Future<Result<TermsOfServiceVersion?>> getAgreedVersion() {
    return _failureRecorder.guard(
      () async {
        final value = _preferences
            .getString(_agreedVersionKey, defaultValue: '')
            .getValue();
        return value.isEmpty ? null : TermsOfServiceVersion(value: value);
      },
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  @override
  Future<Result<void>> setAgreedVersion({
    required TermsOfServiceVersion version,
  }) {
    return _failureRecorder.guard(
      () async {
        if (!await _preferences.setString(_agreedVersionKey, version.value)) {
          throw const PersistenceException(
            detail: '同意した利用規約のバージョンを保存できませんでした',
          );
        }
      },
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }
}
