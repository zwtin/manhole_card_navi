import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_prefectures.dart';
import '/domain/entity/result.dart';

abstract class PrefectureRepository {
  Future<Result<ManholeCardPrefectures>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardPrefectures manholeCardPrefectures,
  });
  Future<Result<ManholeCardPrefecture>> get({
    required String id,
  });
}
