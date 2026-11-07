import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/master_version.dart';
import 'package:domain/src/repository/master_data_repository.dart';
import 'package:domain/src/repository/master_version_repository.dart';

final checkMasterUpdateUseCaseProvider = Provider<CheckMasterUpdateUseCase>(
  (ref) => CheckMasterUpdateUseCase(
    ref.watch(masterDataRepositoryProvider),
    ref.watch(masterVersionRepositoryProvider),
  ),
);

class CheckMasterUpdateUseCase {
  CheckMasterUpdateUseCase(
    this._masterDataRepository,
    this._masterVersionRepository,
  );

  final MasterDataRepository _masterDataRepository;
  final MasterVersionRepository _masterVersionRepository;

  Future<Result<bool>> getNeedUpdate() async {
    final MasterVersion inquiredVersion;
    switch (await _masterVersionRepository.getInquiredVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        inquiredVersion = value;
    }

    switch (await _masterDataRepository.getCurrentVersion()) {
      // 端末のマスターデータが読めなければ、ないのと同じなので取り直す。読めない
      // ファイルは消してあり、記録も Repository が済ませている。
      case Failure():
        return const Result.success(true);
      case Success(:final value):
        return Result.success(value != inquiredVersion);
    }
  }

  Future<Result<void>> updateMaster() async {
    final MasterVersion inquiredVersion;
    switch (await _masterVersionRepository.getInquiredVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        inquiredVersion = value;
    }

    return _masterDataRepository.replace(version: inquiredVersion);
  }
}
