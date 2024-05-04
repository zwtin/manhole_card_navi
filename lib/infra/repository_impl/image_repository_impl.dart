import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
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
import '/temporary_provider.dart';

final imageRepositoryProvider = Provider.autoDispose<ImageRepository>(
  (ref) {
    final imageRepository = ImageRepositoryImpl(
      ref.watch(directoryProvider),
    );
    ref.onDispose(imageRepository.dispose);
    return imageRepository;
  },
);

class ImageRepositoryImpl implements ImageRepository {
  ImageRepositoryImpl(
    this._directory,
  );

  final _logger = Logger();
  final Directory _directory;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

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
            name: doc['name'] as String,
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
  Future<Result<ManholeCardImages>> fetchImage({
    required ManholeCardImages manholeCardImages,
  }) async {
    try {
      final map = <String, dynamic>{};
      map['appDirectory'] = _directory;
      map['manholeCardImages'] = manholeCardImages;

      return compute(_saveInLocal, map);
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

  static Future<Result<ManholeCardImages>> _saveInLocal(
    Map<String, dynamic> parameter,
  ) async {
    final appDirectory = parameter['appDirectory'] as Directory;
    final manholeCardImages =
        parameter['manholeCardImages'] as ManholeCardImages;

    final imageDirectory = Directory('${appDirectory.path}/images');
    if (imageDirectory.existsSync()) {
      imageDirectory.deleteSync(recursive: true);
    }
    imageDirectory.createSync(recursive: true);

    final newManholeCardImageList = await Future.wait(
      manholeCardImages.map(
        (manholeCardImage) async {
          final res = await http.get(
            Uri.parse(
              'https://storage.googleapis.com/manhole-card-navi-dev.appspot.com/images/${manholeCardImage.name}',
            ),
          );
          final imagePath = '${imageDirectory.path}/${manholeCardImage.name}';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(res.bodyBytes);
          return manholeCardImage;
        },
      ),
    );
    return Result.success(
      ManholeCardImages(
        list: newManholeCardImageList,
      ),
    );
  }

  void dispose() {
    _logger.d('ImageRepositoryImpl dispose');
  }
}
