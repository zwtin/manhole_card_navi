import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/privacy_policy.dart';

final privacyPolicyRepositoryProvider =
    Provider<PrivacyPolicyRepository>(
      (ref) =>
          throw UnimplementedError(
            'privacyPolicyRepositoryProvider must be overridden',
          ),
    );

abstract class PrivacyPolicyRepository {
  Future<Result<PrivacyPolicy>> get();
}
