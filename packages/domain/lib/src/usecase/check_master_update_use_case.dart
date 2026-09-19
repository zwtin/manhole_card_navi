import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/master_version.dart';
import '../repository/master_data_repository.dart';
import '../repository/master_version_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
final checkMasterUpdateUseCaseProvider =
    Provider<CheckMasterUpdateUseCase>(
  (ref) {
    final checkMasterUpdateUseCase = CheckMasterUpdateUseCase(
      ref.watch(masterDataRepositoryProvider),
      ref.watch(masterVersionRepositoryProvider),
    );
    ref.onDispose(checkMasterUpdateUseCase.dispose);
    return checkMasterUpdateUseCase;
  },
);

class CheckMasterUpdateUseCase {
  CheckMasterUpdateUseCase(
    this._masterDataRepository,
    this._masterVersionRepository,
  );

  final MasterDataRepository _masterDataRepository;
  final MasterVersionRepository _masterVersionRepository;

  final _logger = Logger();

  /// マスターデータを取り込み直す必要があるか。
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

    // バージョンが一致していても、端末にマスターデータが無ければ取り直す。
    //
    // 端末のマスターデータは、保存の形を変えたときや壊れていたときに消えることが
    // あるが、取り込み済みのバージョンの記録は残る。バージョン比較だけだと
    // 「マスターデータは無いのに更新不要」と判定され、カードが 1 件も表示されない
    // まま復旧しなくなる。
    switch (await _masterDataRepository.exists()) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        return Result.success(!value);
    }
  }

  /// サーバーが指定するバージョンのマスターデータを取得し、端末のものと入れ替える。
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

    // 入れ替えが済んでから記録する。先に記録すると、入れ替えに失敗したときに
    // 古いデータのまま「取り込み済み」になってしまう。
    return _masterVersionRepository.setCurrentVersion(version: inquiredVersion);
  }

  void dispose() {
    _logger.d('CheckMasterUpdateUseCase dispose');
  }
}
