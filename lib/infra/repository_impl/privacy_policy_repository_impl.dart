import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/privacy_policy.dart';
import '/domain/entity/result.dart';
import '/domain/repository/privacy_policy_repository.dart';

final privacyPolicyRepositoryProvider =
    Provider.autoDispose<PrivacyPolicyRepository>(
  (ref) {
    final privacyPolicyRepository = PrivacyPolicyRepositoryImpl();
    ref.onDispose(privacyPolicyRepository.dispose);
    return privacyPolicyRepository;
  },
);

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  final _logger = Logger();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<Result<PrivacyPolicy>> get() async {
    final privacyPolicy = _remoteConfig.getString('privacy_policy');
    return Result.success(
      PrivacyPolicy(
        value: privacyPolicy,
      ),
    );
  }

  void dispose() {
    _logger.d('PrivacyPolicyRepositoryImpl dispose');
  }
}
