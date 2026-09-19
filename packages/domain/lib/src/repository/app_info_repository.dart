import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/app_info.dart';
import 'package:domain/src/entity/app_version.dart';

final appInfoRepositoryProvider = Provider<AppInfoRepository>(
  (ref) =>
      throw UnimplementedError('appInfoRepositoryProvider must be overridden'),
);

abstract class AppInfoRepository {
  Future<Result<AppInfo>> getAppInfo();

  /// 動かすのに必要な最低限のバージョン。
  Future<Result<AppVersion>> getInquiredVersion();
}
