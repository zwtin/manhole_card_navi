import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/datasource/master_data_remote_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/mapper/firestore_master_mapper.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:domain/domain.dart';

class MasterDataRepositoryImpl implements MasterDataRepository {
  MasterDataRepositoryImpl(
    this._remote,
    this._local,
    this._crashlytics,
  );

  final MasterDataRemoteDataSource _remote;
  final MasterDataLocalDataSource _local;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<void>> replace({required MasterVersion version}) async {
    try {
      await _local.writeAll(await _fetch(version));
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<bool>> exists() async {
    try {
      return Result.success(await _local.exists());
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  Future<List<LocalCardModel>> _fetch(MasterVersion version) async {
    final master = await _remote.read(version.value);
    final prefectures = {
      for (final prefecture in master.prefectures)
        prefecture.id: prefecture.name,
    };
    final volumes = {
      for (final volume in master.volumes) volume.id: volume.name,
    };
    final cards = [
      for (final card in master.cards)
        FirestoreMasterMapper.toLocalCard(
          card,
          prefectures: prefectures,
          volumes: volumes,
        ),
    ];
    if (cards.isEmpty) {
      // 取り込むと一覧もマップも空になる。
      throw const CorruptedDataException(
        detail: 'サーバーのマスターデータにカードがありません',
      );
    }
    return cards;
  }
}
