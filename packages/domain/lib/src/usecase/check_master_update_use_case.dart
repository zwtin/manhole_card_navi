import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/master_version.dart';
import 'package:domain/src/repository/master_data_repository.dart';
import 'package:domain/src/repository/master_version_repository.dart';

final checkMasterUpdateUseCaseProvider =
    Provider<CheckMasterUpdateUseCase>(
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

    final MasterVersion? currentVersion;
    switch (await _masterVersionRepository.getCurrentVersion()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        currentVersion = value;
    }

    if (currentVersion != inquiredVersion) {
      return const Result.success(true);
    }

    // 端末のマスターデータは壊れていたときなどに消えるが、取り込み済みのバージョン
    // の記録は残る。バージョンだけで判定すると、カードが 1 件もないまま取り直さない。
    switch (await _masterDataRepository.exists()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        return Result.success(!value);
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

    if (await _masterDataRepository.replace(version: inquiredVersion)
        case Failure(:final exception)) {
      return Result.failure(exception);
    }

    // 先に記録すると、入れ替えに失敗したときに古いデータのまま取り込み済みになる。
    return _masterVersionRepository.setCurrentVersion(version: inquiredVersion);
  }
}
