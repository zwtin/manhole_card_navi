import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:data/src/model/firestore_master_models.dart';

class MasterDataRemoteDataSource {
  MasterDataRemoteDataSource(this._firestore);

  /// 待っている間は起動が進まない。取れなくても前回の差分で続けられるので、長く
  /// 待たない。
  static const _cardUpdatesTimeout = Duration(seconds: 5);

  final FirebaseFirestore _firestore;

  /// [version] の master から変わったカード。ドキュメントがなければ空。
  Future<List<FirestoreCardUpdateModel>> readCardUpdates(String version) async {
    final snapshot = await _firestore
        .collection('master')
        .doc(version)
        .collection('card_updates')
        .doc('current')
        .get()
        .timeout(_cardUpdatesTimeout);
    final data = snapshot.data();
    if (data == null) {
      return const [];
    }
    return FirestoreCardUpdatesModel.fromDocument(data).cards;
  }

  Future<FirestoreMasterModel> read(String version) async {
    final master = _firestore.collection('master').doc(version);
    final snapshots = await Future.wait([
      master.collection('cards').get(),
      master.collection('prefectures').get(),
      master.collection('volumes').get(),
    ]);
    return FirestoreMasterModel(
      cards: [
        for (final doc in snapshots[0].docs)
          FirestoreCardModel.fromDocument(doc.data()),
      ],
      prefectures: [
        for (final doc in snapshots[1].docs)
          FirestorePrefectureModel.fromDocument(doc.data()),
      ],
      volumes: [
        for (final doc in snapshots[2].docs)
          FirestoreVolumeModel.fromDocument(doc.data()),
      ],
    );
  }
}
