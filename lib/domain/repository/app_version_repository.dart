import '/domain/entity/current_app_version.dart';
import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/result.dart';

abstract class AppVersionRepository {
  Future<Result<InquiredAppVersion>> getInquiredAppVersion();
  Future<Result<CurrentAppVersion>> getCurrentAppVersion();
}
