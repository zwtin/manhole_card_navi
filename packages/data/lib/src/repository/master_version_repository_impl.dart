import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/remote_config_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(this._remoteConfig, this._crashlytics);

  static const _inquiredVersionKey = 'inquired_master_version';

  final RemoteConfigDataSource _remoteConfig;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<MasterVersion>> getInquiredVersion() async {
    try {
      return Result.success(
        MasterVersion(
          value: await _remoteConfig.readString(_inquiredVersionKey),
        ),
      );
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
