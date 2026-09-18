import 'package:riverpod/riverpod.dart';

import '../entity/inquired_master_version.dart';
import '../entity/manhole_card.dart';
import '../entity/manhole_cards.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final cardRepositoryProvider = Provider.autoDispose<CardRepository>(
  (ref) =>
      throw UnimplementedError('cardRepositoryProvider must be overridden'),
);

abstract class CardRepository {
  Future<Result<ManholeCards>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();

  /// ローカルに取り込み済みのカードが 1 件でもあるか。
  Future<Result<bool>> hasMaster();
  Future<Result<void>> saveMaster({required ManholeCards manholeCards});
  Future<Result<ManholeCard>> get({required String id});
}
