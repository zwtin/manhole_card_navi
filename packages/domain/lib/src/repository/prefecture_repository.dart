import 'package:riverpod/riverpod.dart';

import '../entity/inquired_master_version.dart';
import '../entity/manhole_card_prefecture.dart';
import '../entity/manhole_card_prefectures.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final prefectureRepositoryProvider = Provider.autoDispose<PrefectureRepository>(
  (ref) =>
      throw UnimplementedError(
        'prefectureRepositoryProvider must be overridden',
      ),
);

abstract class PrefectureRepository {
  Future<Result<ManholeCardPrefectures>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardPrefectures manholeCardPrefectures,
  });
  Future<Result<ManholeCardPrefecture>> get({required String id});
}
