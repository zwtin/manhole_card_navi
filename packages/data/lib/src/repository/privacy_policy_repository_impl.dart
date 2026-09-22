import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  PrivacyPolicyRepositoryImpl(
    this._remoteConfig,
    this._crashlytics,
  );

  static const _key = 'privacy_policy';

  final RemoteConfigDataSource _remoteConfig;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<PrivacyPolicy>> get() async {
    try {
      return Result.success(
        PrivacyPolicy(value: await _remoteConfig.readString(_key)),
      );
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
