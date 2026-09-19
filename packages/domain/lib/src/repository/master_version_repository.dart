import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/master_version.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final masterVersionRepositoryProvider =
    Provider<MasterVersionRepository>(
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
