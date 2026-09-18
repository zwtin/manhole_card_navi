import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../entity/manhole_card.dart';
import '../entity/master_version.dart';
import '../entity/result.dart';
import '../repository/master_data_repository.dart';
import '../repository/master_version_repository.dart';

final checkMasterUpdateUseCaseProvider =
    Provider.autoDispose<CheckMasterUpdateUseCase>(
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
    // Realm のスキーマを変更するとローカル DB は丸ごと作り直されるが
    // （RealmConfiguration の shouldDeleteIfMigrationNeeded）、取り込み済みの
    // バージョンは SharedPreferences 側に残る。バージョン比較だけだと「DB は空なのに
    // 更新不要」と判定され、カードが 1 件も表示されないまま復旧しなくなる。
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

    final List<ManholeCard> cards;
    switch (await _masterDataRepository.fetch(version: inquiredVersion)) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        cards = value;
    }

    if (await _masterDataRepository.replace(cards: cards)
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
