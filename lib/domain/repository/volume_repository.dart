import '/domain/entity/current_master_version.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/domain/entity/result.dart';

abstract class VolumeRepository {
  Future<Result<ManholeCardVolumes>> fetchMaster({
    required CurrentMasterVersion currentMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardVolumes manholeCardVolumes,
  });
}
