import '/domain/entity/agreed_terms_of_service_version.dart';
import '/domain/entity/inquired_terms_of_service_version.dart';
import '/domain/entity/result.dart';
import '/domain/entity/terms_of_service.dart';

abstract class TermsOfServiceRepository {
  Future<Result<TermsOfService>> get();
  Future<Result<InquiredTermsOfServiceVersion>> getInquiredVersion();
  Future<Result<AgreedTermsOfServiceVersion>> getAgreedVersion();
  Future<Result<void>> setAgreedVersion({
    required AgreedTermsOfServiceVersion agreedTermsOfServiceVersion,
  });
}
