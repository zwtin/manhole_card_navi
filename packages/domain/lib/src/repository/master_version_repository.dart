import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/current_master_version.dart';
import '../entity/inquired_master_version.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final masterVersionRepositoryProvider =
    Provider.autoDispose<MasterVersionRepository>(
      (ref) =>
          throw UnimplementedError(
            'masterVersionRepositoryProvider must be overridden',
          ),
    );

abstract class MasterVersionRepository {
  Future<Result<InquiredMasterVersion>> getInquiredVersion();
  Future<Result<CurrentMasterVersion>> getCurrentVersion();
  Future<Result<void>> setCurrentVersion({
    required CurrentMasterVersion currentMasterVersion,
  });
}
