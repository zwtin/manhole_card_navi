import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '../dao/realm_configuration.dart';
import '../dao/realm_volume_dao.dart';
import '../mapper/realm_volume_mapper.dart';
import '../mapper/realm_volumes_mapper.dart';

class VolumeRepositoryImpl implements VolumeRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ManholeCardVolumes>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  }) async {
    try {
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
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteMaster() async {
    try {
      var realm = RealmConfiguration.open();

      realm.write(() {
        realm.deleteAll<RealmVolumeDAO>();
      });
      realm.close();

      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの削除に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<void>> saveMaster({
    required ManholeCardVolumes manholeCardVolumes,
  }) async {
    try {
      var realm = RealmConfiguration.open();

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
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'マスターデータの保存に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<ManholeCardVolume>> get({
    required String id,
  }) async {
    try {
      var realm = RealmConfiguration.open();

      final daoOrNull = realm
          .all<RealmVolumeDAO>()
          .query(
            "id == '$id'",
          )
          .firstOrNull;
      if (daoOrNull == null) {
        throw const CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした。',
        );
      }
      final volume = RealmVolumeMapper.convertToEntity(dao: daoOrNull);
      realm.close();
      return Result.success(volume);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '弾数データの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('VolumeRepositoryImpl dispose');
  }
}
