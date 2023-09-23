import '/domain/entity/current_master_version.dart';
import '/domain/entity/manhole_cards.dart';
import '/domain/entity/result.dart';

abstract class CardRepository {
  Future<Result<ManholeCards>> fetchMaster({
    required CurrentMasterVersion currentMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCards manholeCards,
  });
}
