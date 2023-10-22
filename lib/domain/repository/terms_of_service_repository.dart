import '/domain/entity/result.dart';
import '/domain/entity/terms_of_service.dart';

abstract class TermsOfServiceRepository {
  Future<Result<TermsOfService>> get();
}
