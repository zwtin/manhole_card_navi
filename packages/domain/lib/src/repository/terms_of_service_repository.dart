import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/terms_of_service.dart';
import '../entity/terms_of_service_version.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final termsOfServiceRepositoryProvider =
    Provider<TermsOfServiceRepository>(
  (ref) => throw UnimplementedError(
    'termsOfServiceRepositoryProvider must be overridden',
  ),
);

abstract class TermsOfServiceRepository {
  Future<Result<TermsOfService>> get();

  /// 同意してもらう必要のある利用規約のバージョン（サーバーが指定するもの）。
  Future<Result<TermsOfServiceVersion>> getInquiredVersion();

  /// 同意済みのバージョン。まだ一度も同意していなければ null。
  Future<Result<TermsOfServiceVersion?>> getAgreedVersion();

  Future<Result<void>> setAgreedVersion({
    required TermsOfServiceVersion version,
  });
}
