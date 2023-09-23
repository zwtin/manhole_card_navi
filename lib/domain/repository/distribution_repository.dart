import '/domain/entity/current_master_version.dart';
import '/domain/entity/manhole_card_distributions.dart';
import '/domain/entity/result.dart';

abstract class DistributionRepository {
  Future<Result<ManholeCardDistributions>> fetchMaster({
    required CurrentMasterVersion currentMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardDistributions manholeCardDistributions,
  });
}
