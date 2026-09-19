import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../datasource/failure_recorder.dart';
import '../datasource/master_data_local_data_source.dart';
import '../mapper/domain_exception_mapper.dart';
import '../mapper/firestore_master_mapper.dart';

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
  Future<Result<List<ManholeCard>>> fetch({
    required MasterVersion version,
  }) {
    // サーバーではカード・都道府県・弾を別のコレクションに持っている。カードは
    // 都道府県・弾の ID しか持たないため、3 つを取ってここで名前を引き当てる。
    final master = _firestore.collection('master').doc(version.value);
    return _failureRecorder.guard(
      () async {
        final snapshots = await Future.wait([
          master.collection('cards').get(),
          master.collection('prefectures').get(),
          master.collection('volumes').get(),
        ]);
        final prefectures = <String, ManholeCardPrefecture>{};
        for (final doc in snapshots[1].docs) {
          final prefecture = FirestoreMasterMapper.toPrefecture(
            doc.data(),
            path: doc.reference.path,
          );
          prefectures[prefecture.id] = prefecture;
        }
        final volumes = <String, ManholeCardVolume>{};
        for (final doc in snapshots[2].docs) {
          final volume = FirestoreMasterMapper.toVolume(
            doc.data(),
            path: doc.reference.path,
          );
          volumes[volume.id] = volume;
        }
        final cards = snapshots[0]
            .docs
            .map(
              (doc) => FirestoreMasterMapper.toCard(
                doc.data(),
                path: doc.reference.path,
                prefectures: prefectures,
                volumes: volumes,
              ),
            )
            .toList();
        if (cards.isEmpty) {
          // 取り込むと一覧もマップも空になるので、壊れたデータとして扱う。
          throw CorruptedDataException(
            detail: '${master.path}/cards にカードがありません',
          );
        }
        return cards;
      },
      convert: DomainExceptionMapper.fromFirestore,
    );
  }

  @override
  Future<Result<void>> replace({required List<ManholeCard> cards}) {
    return _failureRecorder.guard(
      () => _masterData.writeAll(cards),
      convert: DomainExceptionMapper.fromLocalStorage,
    );
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
