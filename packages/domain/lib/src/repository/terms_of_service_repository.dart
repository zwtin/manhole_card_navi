import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/agreed_terms_of_service_version.dart';
import '../entity/inquired_terms_of_service_version.dart';
import '../entity/terms_of_service.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final termsOfServiceRepositoryProvider =
    Provider.autoDispose<TermsOfServiceRepository>(
      (ref) =>
          throw UnimplementedError(
            'termsOfServiceRepositoryProvider must be overridden',
          ),
    );

abstract class TermsOfServiceRepository {
  Future<Result<TermsOfService>> get();
  Future<Result<InquiredTermsOfServiceVersion>> getInquiredVersion();
  Future<Result<AgreedTermsOfServiceVersion>> getAgreedVersion();
  Future<Result<void>> setAgreedVersion({
    required AgreedTermsOfServiceVersion agreedTermsOfServiceVersion,
  });
}
