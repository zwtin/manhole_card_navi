import '/domain/entity/current_master_version.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/result.dart';

abstract class MasterVersionRepository {
  Future<Result<InquiredMasterVersion>> getInquiredVersion();
  Future<Result<CurrentMasterVersion>> getCurrentVersion();
  Future<Result<void>> setCurrentVersion({
    required CurrentMasterVersion currentMasterVersion,
  });
}
