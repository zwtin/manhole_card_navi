import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/app_info.dart';
import '../entity/app_version.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final appInfoRepositoryProvider = Provider.autoDispose<AppInfoRepository>(
  (ref) =>
      throw UnimplementedError('appInfoRepositoryProvider must be overridden'),
);

abstract class AppInfoRepository {
  Future<Result<AppInfo>> getAppInfo();

  /// 動かすのに必要な最低限のアプリのバージョン（サーバーが指定するもの）。
  Future<Result<AppVersion>> getInquiredVersion();
}
