import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/master_version.dart';

final masterDataRepositoryProvider =
    Provider<MasterDataRepository>(
  (ref) => throw UnimplementedError(
    'masterDataRepositoryProvider must be overridden',
  ),
);

abstract class MasterDataRepository {
  /// 端末のマスターデータを、サーバーの [version] のものと入れ替える。途中で失敗
  /// したら何も変えない。
  Future<Result<void>> replace({required MasterVersion version});

  /// 端末に取り込まれているか。
  Future<Result<bool>> exists();
}
