import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_cards.dart';
import '/domain/entity/result.dart';

abstract class CardRepository {
  Future<Result<ManholeCards>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCards manholeCards,
  });
}
