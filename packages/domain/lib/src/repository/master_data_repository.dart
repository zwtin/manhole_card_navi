import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/master_version.dart';

final masterDataRepositoryProvider = Provider<MasterDataRepository>(
  (ref) =>
      throw UnimplementedError(
        'masterDataRepositoryProvider must be overridden',
      ),
);

abstract class MasterDataRepository {
  /// 端末のマスターデータを、サーバーの [version] のものと入れ替える。前の
  /// マスターデータに対する差分は捨てる。取得に失敗したら何も変えない。
  Future<Result<void>> replace({required MasterVersion version});

  /// カードに重ねる差分を、サーバーの [version] のものと入れ替える。失敗したら
  /// 前の差分のまま。
  Future<Result<void>> replaceCardUpdates({required MasterVersion version});

  /// 端末に取り込まれているか。
  Future<Result<bool>> exists();
}
