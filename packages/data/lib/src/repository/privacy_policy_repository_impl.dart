import 'package:domain/domain.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';

class PrivacyPolicyRepositoryImpl implements PrivacyPolicyRepository {
  final _logger = Logger();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<Result<PrivacyPolicy>> get() async {
    try {
      final privacyPolicy = _remoteConfig.getString('privacy_policy');
      return Result.success(
        PrivacyPolicy(
          value: privacyPolicy,
        ),
      );
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'プライバシーポリシーの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('PrivacyPolicyRepositoryImpl dispose');
  }
}
