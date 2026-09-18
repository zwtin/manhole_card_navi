import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/app_info.dart';
import '../entity/inquired_app_version.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final appInfoRepositoryProvider = Provider.autoDispose<AppInfoRepository>(
  (ref) =>
      throw UnimplementedError('appInfoRepositoryProvider must be overridden'),
);

abstract class AppInfoRepository {
  Future<Result<InquiredAppVersion>> getInquiredAppVersion();
  Future<Result<AppInfo>> getAppInfo();
}
