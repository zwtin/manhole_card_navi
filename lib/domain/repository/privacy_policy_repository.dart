import '/domain/entity/privacy_policy.dart';
import '/domain/entity/result.dart';

abstract class PrivacyPolicyRepository {
  Future<Result<PrivacyPolicy>> get();
}
