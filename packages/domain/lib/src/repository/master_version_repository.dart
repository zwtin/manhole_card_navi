import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/master_version.dart';

final masterVersionRepositoryProvider = Provider<MasterVersionRepository>(
  (ref) =>
      throw UnimplementedError(
        'masterVersionRepositoryProvider must be overridden',
      ),
);

abstract class MasterVersionRepository {
  /// 使うべきバージョン。端末に取り込み済みのバージョンは
  /// `MasterDataRepository.getCurrentVersion`。
  Future<Result<MasterVersion>> getInquiredVersion();
}
