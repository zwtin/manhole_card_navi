import '/domain/entity/app_info.dart';
import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/result.dart';

abstract class AppInfoRepository {
  Future<Result<InquiredAppVersion>> getInquiredAppVersion();
  Future<Result<AppInfo>> getAppInfo();
}
