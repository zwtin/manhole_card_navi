import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/result.dart';

abstract class RemoteConfigRepository {
  Future<Result<InquiredAppVersion>> getInquiredAppVersion();
  Future<Result<InquiredMasterVersion>> getInquiredMasterVersion();
  Future<Result<String>> getTermsOfService();
}
