
import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl(
    this._remoteConfig,
    this._failureRecorder,
  );

  static const _key = 'privacy_policy';

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
}
