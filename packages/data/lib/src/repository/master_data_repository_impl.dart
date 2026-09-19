import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import 'package:data/src/datasource/failure_recorder.dart';
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
    this._failureRecorder,
  );

  final _logger = Logger();
  final FirebaseFirestore _firestore;
  final MasterDataLocalDataSource _masterData;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> replace({required MasterVersion version}) async {
    final List<LocalCardModel> cards;
    switch (await _failureRecorder.guard(
      () => _fetch(version),
      convert: DomainExceptionMapper.fromFirestore,
    )) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        cards = value;
    }
    return _failureRecorder.guard(
      () => _masterData.writeAll(cards),
      convert: DomainExceptionMapper.fromLocalStorage,
    );
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
      final prefecture = FirestorePrefectureModel.fromDocument(
        doc.data(),
        path: doc.reference.path,
      );
      prefectures[prefecture.id] = prefecture.name;
    }
    final volumes = <String, String>{};
    for (final doc in snapshots[2].docs) {
      final volume = FirestoreVolumeModel.fromDocument(
        doc.data(),
        path: doc.reference.path,
      );
      volumes[volume.id] = volume.name;
    }
    final cards = [
      for (final doc in snapshots[0].docs)
        FirestoreMasterMapper.toLocalCard(
          FirestoreCardModel.fromDocument(doc.data(), path: doc.reference.path),
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

  @override
  Future<Result<bool>> exists() {
    return _failureRecorder.guard(
      _masterData.exists,
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  void dispose() {
    _logger.d('MasterDataRepositoryImpl dispose');
  }
}
