import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../remote_config/remote_config_reader.dart';
import '../service/failure_recorder.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  /// プライバシーポリシーの HTML を配信する Remote Config のキー。
  static const _key = 'privacy_policy';

  final _logger = Logger();
  final _failureRecorder = FailureRecorder();
  final _remoteConfigReader = RemoteConfigReader();

  @override
  Future<Result<PrivacyPolicy>> get() async {
    try {
      final value = await _remoteConfigReader.readString(_key);
      return Result.success(PrivacyPolicy(value: value));
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromRemoteConfig(error, stackTrace),
        stackTrace,
      );
    }
  }

  void dispose() {
    _logger.d('PrivacyPolicyRepositoryImpl dispose');
  }
}
