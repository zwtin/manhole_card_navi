import 'package:riverpod/riverpod.dart';

import '../entity/master_version.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final masterVersionRepositoryProvider =
    Provider.autoDispose<MasterVersionRepository>(
  (ref) => throw UnimplementedError(
    'masterVersionRepositoryProvider must be overridden',
  ),
);

abstract class MasterVersionRepository {
  /// 使うべきマスターデータのバージョン（サーバーが指定するもの）。
  Future<Result<MasterVersion>> getInquiredVersion();

  /// 端末に取り込み済みのバージョン。まだ一度も取り込んでいなければ null。
  Future<Result<MasterVersion?>> getCurrentVersion();

  Future<Result<void>> setCurrentVersion({required MasterVersion version});
}
