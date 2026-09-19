import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/terms_of_service.dart';
import 'package:domain/src/entity/terms_of_service_version.dart';

final termsOfServiceRepositoryProvider =
    Provider<TermsOfServiceRepository>(
  (ref) => throw UnimplementedError(
    'termsOfServiceRepositoryProvider must be overridden',
  ),
);

abstract class TermsOfServiceRepository {
  Future<Result<TermsOfService>> get();

  /// 同意してもらう必要のあるバージョン。
  Future<Result<TermsOfServiceVersion>> getInquiredVersion();

  /// まだ同意していなければ null。
  Future<Result<TermsOfServiceVersion?>> getAgreedVersion();

  Future<Result<void>> setAgreedVersion({
    required TermsOfServiceVersion version,
  });
}
