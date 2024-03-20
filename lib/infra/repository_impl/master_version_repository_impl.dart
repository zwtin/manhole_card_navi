import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/result.dart';
import '/domain/repository/master_version_repository.dart';
import '/temporary_provider.dart';

final masterVersionRepositoryProvider =
    Provider.autoDispose<MasterVersionRepository>(
  (ref) {
    final masterVersionRepository = MasterVersionRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(masterVersionRepository.dispose);
    return masterVersionRepository;
  },
);

class MasterVersionRepositoryImpl implements MasterVersionRepository {
  MasterVersionRepositoryImpl(
    this._instance,
  );

  final _logger = Logger();
  final _remoteConfig = FirebaseRemoteConfig.instance;
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<InquiredMasterVersion>> getInquiredVersion() async {
    try {
      final inquiredMasterVersion =
          _remoteConfig.getString('inquired_master_version');
      return Result.success(
        InquiredMasterVersion(
          value: inquiredMasterVersion,
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
          text: '要求マスターデータバージョンの取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<CurrentMasterVersion>> getCurrentVersion() async {
    try {
      final currentMasterVersion = _instance
          .getString(
            'current_master_version',
            defaultValue: '',
          )
          .getValue();
      return Result.success(
        CurrentMasterVersion(
          value: currentMasterVersion,
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
          text: '取得済みマスターデータバージョンの取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<void>> setCurrentVersion({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    try {
      final result = await _instance.setString(
        'current_master_version',
        currentMasterVersion.value,
      );
      if (result) {
        return const Result.success(null);
      } else {
        throw const CustomException(
          title: 'エラー',
          text: 'データの更新に失敗しました。',
        );
      }
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '取得済みマスターデータバージョンの保存に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('MasterVersionRepositoryImpl dispose');
  }
}
