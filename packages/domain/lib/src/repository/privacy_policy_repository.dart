import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/privacy_policy.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
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
