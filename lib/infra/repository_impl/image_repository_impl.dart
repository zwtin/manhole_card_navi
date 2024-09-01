import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_images.dart';
import '/domain/entity/result.dart';
import '/domain/repository/image_repository.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/mapper/realm_image_mapper.dart';
import '/infra/mapper/realm_images_mapper.dart';

final imageRepositoryProvider = Provider.autoDispose<ImageRepository>(
  (ref) {
    final imageRepository = ImageRepositoryImpl();
    ref.onDispose(imageRepository.dispose);
    return imageRepository;
  },
);

class ImageRepositoryImpl implements ImageRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ManholeCardImages>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('master')
          .doc(inquiredMasterVersion.value)
          .collection('images')
          .get();
      final list = querySnapshot.docs.map(
        (doc) {
          return ManholeCardImage(
            id: doc['id'] as String,
            colorOriginal: doc['color_original'] as String,
            colorResized: doc['color_resized'] as String,
            colorFrameGreen: doc['color_frame_green'] as String,
            colorFrameRed: doc['color_frame_red'] as String,
            colorFrameYellow: doc['color_frame_yellow'] as String,
            grayOriginal: doc['gray_original'] as String,
            grayResized: doc['gray_resized'] as String,
            grayFrameGreen: doc['gray_frame_green'] as String,
            grayFrameRed: doc['gray_frame_red'] as String,
            grayFrameYellow: doc['gray_frame_yellow'] as String,
          );
        },
      ).toList();
      return Result.success(
        ManholeCardImages(
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
          RealmImageDAO.schema,
        ],
        shouldDeleteIfMigrationNeeded: true,
      );
      var realm = Realm(config);

      realm.write(() {
        realm.deleteAll<RealmImageDAO>();
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
    required ManholeCardImages manholeCardImages,
  }) async {
    try {
      var config = Configuration.local([
        RealmImageDAO.schema,
      ]);
      var realm = Realm(config);

      final realmImages = RealmImagesMapper.convertFromEntity(
        entity: manholeCardImages,
      );

      realm.write(() {
        realm.addAll(
          realmImages,
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
  Future<Result<ManholeCardImage>> get({
    required String id,
  }) async {
    try {
      var config = Configuration.local([
        RealmImageDAO.schema,
      ]);
      var realm = Realm(config);

      final daoOrNull = realm
          .all<RealmImageDAO>()
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
      final image = RealmImageMapper.convertToEntity(dao: daoOrNull);
      realm.close();
      return Result.success(image);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '画像データの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('ImageRepositoryImpl dispose');
  }
}
