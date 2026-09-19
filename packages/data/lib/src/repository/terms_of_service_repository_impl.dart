import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../datasource/failure_recorder.dart';
import '../datasource/remote_config_data_source.dart';
import '../mapper/domain_exception_mapper.dart';

class TermsOfServiceRepositoryImpl implements TermsOfServiceRepository {
  TermsOfServiceRepositoryImpl(
    this._preferences,
    this._remoteConfig,
    this._failureRecorder,
  );

  /// 利用規約の HTML を配信する Remote Config のキー。
  static const _termsOfServiceKey = 'terms_of_service';

  /// 同意が必要な利用規約のバージョンを配信する Remote Config のキー。
  static const _inquiredVersionKey = 'inquired_terms_of_service_version';

  /// 同意済みのバージョンを保存する SharedPreferences のキー。
  static const _agreedVersionKey = 'agreed_terms_of_service_version';

  final _logger = Logger();
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
        // まだ一度も同意していなければ、保存されていない（空文字が返る）。
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

  void dispose() {
    _logger.d('TermsOfServiceRepositoryImpl dispose');
  }
}
