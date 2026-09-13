import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/privacy_policy.dart';
import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final privacyPolicyRepositoryProvider =
    Provider.autoDispose<PrivacyPolicyRepository>(
      (ref) =>
          throw UnimplementedError(
            'privacyPolicyRepositoryProvider must be overridden',
          ),
    );

abstract class PrivacyPolicyRepository {
  Future<Result<PrivacyPolicy>> get();
}
