import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_volume.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/domain/entity/result.dart';
import '/domain/repository/volume_repository.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/infra/mapper/realm_volume_mapper.dart';
import '/infra/mapper/realm_volumes_mapper.dart';

final volumeRepositoryProvider = Provider.autoDispose<VolumeRepository>(
  (ref) {
    final volumeRepository = VolumeRepositoryImpl();
    ref.onDispose(volumeRepository.dispose);
    return volumeRepository;
  },
);

class VolumeRepositoryImpl implements VolumeRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ManholeCardVolumes>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  }) async {
    final querySnapshot = await _firestore
        .collection('master')
        .doc(inquiredMasterVersion.value)
        .collection('volumes')
        .get();
    final list = querySnapshot.docs.map(
      (doc) {
        return ManholeCardVolume(
          id: doc['id'] as String,
          name: doc['name'] as String,
        );
      },
    ).toList();
    return Result.success(
      ManholeCardVolumes(
        list: list,
      ),
    );
  }

  @override
  Future<Result<void>> deleteMaster() async {
    var config = Configuration.local(
      [
        RealmVolumeDAO.schema,
      ],
      shouldDeleteIfMigrationNeeded: true,
    );
    var realm = Realm(config);

    realm.write(() {
      realm.deleteAll<RealmVolumeDAO>();
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<void>> saveMaster({
    required ManholeCardVolumes manholeCardVolumes,
  }) async {
    var config = Configuration.local([
      RealmVolumeDAO.schema,
    ]);
    var realm = Realm(config);

    final realmVolumes = RealmVolumesMapper.convertFromEntity(
      entity: manholeCardVolumes,
    );

    realm.write(() {
      realm.addAll(
        realmVolumes,
        update: true,
      );
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<ManholeCardVolume>> get({
    required String id,
  }) async {
    var config = Configuration.local([
      RealmVolumeDAO.schema,
    ]);
    var realm = Realm(config);

    final daoOrNull = realm
        .all<RealmVolumeDAO>()
        .query(
          "id == '$id'",
        )
        .firstOrNull;
    if (daoOrNull == null) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした',
        ),
      );
    }
    final volume = RealmVolumeMapper.convertToEntity(dao: daoOrNull);
    realm.close();
    return Result.success(volume);
  }

  void dispose() {
    _logger.d('VolumeRepositoryImpl dispose');
  }
}
