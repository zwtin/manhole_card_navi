import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '../dao/realm_configuration.dart';
import '../dao/realm_prefecture_dao.dart';
import '../mapper/realm_prefecture_mapper.dart';
import '../mapper/realm_prefectures_mapper.dart';

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
      var realm = RealmConfiguration.open();

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
      var realm = RealmConfiguration.open();

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
      var realm = RealmConfiguration.open();

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
