import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_prefectures.dart';
import '/domain/entity/result.dart';
import '/domain/repository/prefecture_repository.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/mapper/realm_prefecture_mapper.dart';
import '/infra/mapper/realm_prefectures_mapper.dart';

final prefectureRepositoryProvider = Provider.autoDispose<PrefectureRepository>(
  (ref) {
    final prefectureRepository = PrefectureRepositoryImpl();
    ref.onDispose(prefectureRepository.dispose);
    return prefectureRepository;
  },
);

class PrefectureRepositoryImpl implements PrefectureRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ManholeCardPrefectures>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('master')
          .doc(inquiredMasterVersion.value)
          .collection('prefectures')
          .get();
      final list = querySnapshot.docs.map(
        (doc) {
          return ManholeCardPrefecture(
            id: doc['id'] as String,
            name: doc['name'] as String,
          );
        },
      ).toList();
      return Result.success(
        ManholeCardPrefectures(
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
      var config = Configuration.local(
        [
          RealmPrefectureDAO.schema,
        ],
        shouldDeleteIfMigrationNeeded: true,
      );
      var realm = Realm(config);

      realm.write(() {
        realm.deleteAll<RealmPrefectureDAO>();
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
    required ManholeCardPrefectures manholeCardPrefectures,
  }) async {
    try {
      var config = Configuration.local([
        RealmPrefectureDAO.schema,
      ]);
      var realm = Realm(config);

      final realmPrefectures = RealmPrefecturesMapper.convertFromEntity(
        entity: manholeCardPrefectures,
      );

      realm.write(() {
        realm.addAll(
          realmPrefectures,
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
  Future<Result<ManholeCardPrefecture>> get({
    required String id,
  }) async {
    try {
      var config = Configuration.local([
        RealmPrefectureDAO.schema,
      ]);
      var realm = Realm(config);

      final daoOrNull = realm
          .all<RealmPrefectureDAO>()
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
      final prefecture = RealmPrefectureMapper.convertToEntity(dao: daoOrNull);
      realm.close();
      return Result.success(prefecture);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '都道府県データの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('PrefectureRepositoryImpl dispose');
  }
}
