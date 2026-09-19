import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/master_version.dart';

final masterVersionRepositoryProvider =
    Provider<MasterVersionRepository>(
  (ref) => throw UnimplementedError(
    'masterVersionRepositoryProvider must be overridden',
  ),
);

abstract class MasterVersionRepository {
  /// 使うべきバージョン。
  Future<Result<MasterVersion>> getInquiredVersion();

  /// 端末に取り込み済みのバージョン。まだ取り込んでいなければ null。
  Future<Result<MasterVersion?>> getCurrentVersion();

  Future<Result<void>> setCurrentVersion({required MasterVersion version});
}
