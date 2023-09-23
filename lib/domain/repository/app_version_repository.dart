import '/domain/entity/current_app_version.dart';
import '/domain/entity/result.dart';

abstract class AppVersionRepository {
  Future<Result<CurrentAppVersion>> getCurrentAppVersion();
}
