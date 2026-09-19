import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../datasource/failure_recorder.dart';
import '../datasource/remote_config_data_source.dart';
import '../mapper/domain_exception_mapper.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl(
    this._remoteConfig,
    this._failureRecorder,
  );

  /// プライバシーポリシーの HTML を配信する Remote Config のキー。
  static const _key = 'privacy_policy';

  final _logger = Logger();
  final RemoteConfigDataSource _remoteConfig;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<PrivacyPolicy>> get() {
    return _failureRecorder.guard(
      () async => PrivacyPolicy(
        value: await _remoteConfig.readString(_key),
      ),
      convert: DomainExceptionMapper.fromRemoteConfig,
    );
  }

  void dispose() {
    _logger.d('PrivacyPolicyRepositoryImpl dispose');
  }
}
