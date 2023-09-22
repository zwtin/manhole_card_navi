import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/inquired_app_version.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/remote_config_repository.dart';

final remoteConfigRepositoryProvider =
    Provider.autoDispose<RemoteConfigRepository>(
  (ref) {
    final remoteConfigRepository = RemoteConfigRepositoryImpl();
    ref.onDispose(remoteConfigRepository.dispose);
    return remoteConfigRepository;
  },
);

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  final _logger = Logger();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<Result<InquiredAppVersion>> getInquiredAppVersion() async {
    final inquiredAppVersion = _remoteConfig.getString('inquired_app_version');
    return Result.success(
      InquiredAppVersion(
        version: inquiredAppVersion,
      ),
    );
  }

  @override
  Future<Result<InquiredMasterVersion>> getInquiredMasterVersion() async {
    final inquiredMasterVersion =
        _remoteConfig.getString('inquired_master_version');
    return Result.success(
      InquiredMasterVersion(
        version: inquiredMasterVersion,
      ),
    );
  }

  @override
  Future<Result<String>> getTermsOfService() async {
    final termsOfService = _remoteConfig.getString('terms_of_service');
    return Result.success(termsOfService);
  }

  void dispose() {
    _logger.d('RemoteConfigRepositoryImpl dispose');
  }
}
