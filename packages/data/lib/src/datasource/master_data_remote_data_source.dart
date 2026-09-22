import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:data/src/model/firestore_master_models.dart';

/// サーバー（Firestore）が配信するマスターデータ。
class MasterDataRemoteDataSource {
  MasterDataRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

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
