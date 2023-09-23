import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/custom_exception.dart';
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
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<CurrentMasterVersion>> getCurrentMasterVersion() async {
    final currentMasterVersion = _instance
        .getString(
          'current_master_version',
          defaultValue: '',
        )
        .getValue();
    return Result.success(
      CurrentMasterVersion(
        version: currentMasterVersion,
      ),
    );
  }

  @override
  Future<Result<void>> setCurrentMasterVersion({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final result = await _instance.setString(
      'current_master_version',
      currentMasterVersion.version,
    );
    if (result) {
      return const Result.success(null);
    } else {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'バージョンの保存に失敗しました',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('MasterVersionRepositoryImpl dispose');
  }
}
