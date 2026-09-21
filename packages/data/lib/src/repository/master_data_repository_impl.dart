import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/mapper/firestore_master_mapper.dart';
import 'package:data/src/model/firestore_master_models.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:domain/domain.dart';

class MasterDataRepositoryImpl implements MasterDataRepository {
  MasterDataRepositoryImpl(
    this._firestore,
    this._masterData,
    this._crashlytics,
  );

  final FirebaseFirestore _firestore;
  final MasterDataLocalDataSource _masterData;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<void>> replace({required MasterVersion version}) async {
    try {
      await _masterData.writeAll(await _fetch(version));
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<bool>> exists() async {
    try {
      return Result.success(await _masterData.exists());
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  Future<List<LocalCardModel>> _fetch(MasterVersion version) async {
    final master = _firestore.collection('master').doc(version.value);
    final snapshots = await Future.wait([
      master.collection('cards').get(),
      master.collection('prefectures').get(),
      master.collection('volumes').get(),
    ]);
    final prefectures = <String, String>{};
    for (final doc in snapshots[1].docs) {
      final prefecture = FirestorePrefectureModel.fromDocument(doc.data());
      prefectures[prefecture.id] = prefecture.name;
    }
    final volumes = <String, String>{};
    for (final doc in snapshots[2].docs) {
      final volume = FirestoreVolumeModel.fromDocument(doc.data());
      volumes[volume.id] = volume.name;
    }
    final cards = [
      for (final doc in snapshots[0].docs)
        FirestoreMasterMapper.toLocalCard(
          FirestoreCardModel.fromDocument(doc.data()),
          prefectures: prefectures,
          volumes: volumes,
        ),
    ];
    if (cards.isEmpty) {
      // 取り込むと一覧もマップも空になる。
      throw CorruptedDataException(
        detail: '${master.path}/cards にカードがありません',
      );
    }
    return cards;
  }
}
