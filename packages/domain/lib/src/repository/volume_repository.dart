import 'package:riverpod/riverpod.dart';

import '../entity/inquired_master_version.dart';
import '../entity/manhole_card_volume.dart';
import '../entity/manhole_card_volumes.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final volumeRepositoryProvider = Provider.autoDispose<VolumeRepository>(
  (ref) =>
      throw UnimplementedError('volumeRepositoryProvider must be overridden'),
);

abstract class VolumeRepository {
  Future<Result<ManholeCardVolumes>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardVolumes manholeCardVolumes,
  });
  Future<Result<ManholeCardVolume>> get({required String id});
}
