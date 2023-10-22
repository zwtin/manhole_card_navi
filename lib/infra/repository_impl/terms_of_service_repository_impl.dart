import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/result.dart';
import '/domain/entity/terms_of_service.dart';
import '/domain/repository/terms_of_service_repository.dart';

final termsOfServiceRepositoryProvider =
    Provider.autoDispose<TermsOfServiceRepository>(
  (ref) {
    final termsOfServiceRepository = TermsOfServiceRepositoryImpl();
    ref.onDispose(termsOfServiceRepository.dispose);
    return termsOfServiceRepository;
  },
);

class TermsOfServiceRepositoryImpl implements TermsOfServiceRepository {
  final _logger = Logger();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<Result<TermsOfService>> get() async {
    final termsOfService = _remoteConfig.getString('terms_of_service');
    return Result.success(
      TermsOfService(
        value: termsOfService,
      ),
    );
  }

  void dispose() {
    _logger.d('TermsOfServiceRepositoryImpl dispose');
  }
}
