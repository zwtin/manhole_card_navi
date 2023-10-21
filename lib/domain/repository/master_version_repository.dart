import '/domain/entity/current_master_version.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/result.dart';

abstract class MasterVersionRepository {
  Future<Result<InquiredMasterVersion>> getInquiredMasterVersion();
  Future<Result<CurrentMasterVersion>> getCurrentMasterVersion();
  Future<Result<void>> setCurrentMasterVersion({
    required CurrentMasterVersion currentMasterVersion,
  });
}
