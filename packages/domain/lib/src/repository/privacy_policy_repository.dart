import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/privacy_policy.dart';

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
