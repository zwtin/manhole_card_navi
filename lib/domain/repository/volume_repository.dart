import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_volume.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/domain/entity/result.dart';

abstract class VolumeRepository {
  Future<Result<ManholeCardVolumes>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardVolumes manholeCardVolumes,
  });
  Future<Result<ManholeCardVolume>> get({
    required String id,
  });
}
