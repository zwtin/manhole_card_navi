import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../remote_config/remote_config_reader.dart';
import '../service/failure_recorder.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl(
    this._remoteConfigReader,
    this._failureRecorder,
  );

  /// プライバシーポリシーの HTML を配信する Remote Config のキー。
  static const _key = 'privacy_policy';

  final _logger = Logger();
  final RemoteConfigReader _remoteConfigReader;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<PrivacyPolicy>> get() {
    return _failureRecorder.guard(
      () async => PrivacyPolicy(
        value: await _remoteConfigReader.readString(_key),
      ),
      convert: DomainExceptionConverter.fromRemoteConfig,
    );
  }

  void dispose() {
    _logger.d('PrivacyPolicyRepositoryImpl dispose');
  }
}
