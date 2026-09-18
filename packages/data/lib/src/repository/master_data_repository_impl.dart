import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';
import '../dao/realm_prefecture_dao.dart';
import '../dao/realm_volume_dao.dart';
import '../exception/domain_exception_converter.dart';
import '../mapper/firestore_master_mapper.dart';
import '../mapper/realm_card_mapper.dart';

class MasterDataRepositoryImpl implements MasterDataRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<List<ManholeCard>>> fetch({
    required MasterVersion version,
  }) async {
    // サーバーではカード・都道府県・弾を別のコレクションに持っている。カードは
    // 都道府県・弾の ID しか持たないため、3 つを取ってここで名前を引き当てる。
    final master = _firestore.collection('master').doc(version.value);
    final List<QuerySnapshot<Map<String, dynamic>>> snapshots;
    try {
      snapshots = await Future.wait([
        master.collection('cards').get(),
        master.collection('prefectures').get(),
        master.collection('volumes').get(),
      ]);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromFirestore(error, stackTrace),
      );
    }

    try {
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
        return Result.failure(
          CorruptedDataException(
            detail: '${master.path}/cards にカードがありません',
          ),
        );
      }
      return Result.success(cards);
    } on CorruptedDataException catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> replace({required List<ManholeCard> cards}) async {
    try {
      final realm = RealmConfiguration.open();
      try {
        final daoList = cards
            .map((card) => RealmCardMapper.convertFromEntity(entity: card))
            .toList();
        // 1 回のトランザクションで入れ替え、途中で失敗しても古いデータが残るように
        // する。配布地点はカードに埋め込まれているので、カードと一緒に消える。
        // 都道府県・弾はカードからの参照として一緒に入り、同じ ID は update: true で
        // 1 件にまとまる。
        realm.write(() {
          realm.deleteAll<RealmCardDAO>();
          realm.deleteAll<RealmPrefectureDAO>();
          realm.deleteAll<RealmVolumeDAO>();
          realm.addAll(daoList, update: true);
        });
      } finally {
        realm.close();
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<bool>> exists() async {
    try {
      final realm = RealmConfiguration.open();
      try {
        return Result.success(realm.all<RealmCardDAO>().isNotEmpty);
      } finally {
        realm.close();
      }
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('MasterDataRepositoryImpl dispose');
  }
}
