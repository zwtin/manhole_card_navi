import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/domain/entity/custom_exception.dart';
import 'package:manhole_card_navi/infra/mapper/realm_image_mapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_images.dart';
import '/domain/entity/result.dart';
import '/domain/repository/image_repository.dart';
import '/infra/dao/realm_image_dao.dart';
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
  final _storage = FirebaseStorage.instance;

  @override
  Future<Result<ManholeCardImages>> fetchMaster({
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final querySnapshot = await _firestore
        .collection('master')
        .doc(currentMasterVersion.version)
        .collection('images')
        .get();
    final list = querySnapshot.docs.map(
      (doc) {
        return ManholeCardImage(
          id: doc['id'] as String,
          name: doc['name'] as String,
          path: '',
        );
      },
    ).toList();
    return Result.success(
      ManholeCardImages(
        list: list,
      ),
    );
  }

  @override
  Future<Result<ManholeCardImages>> fetchImage({
    required ManholeCardImages manholeCardImages,
  }) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory('${appDirectory.path}/images');
    if (imageDirectory.existsSync()) {
      imageDirectory.deleteSync(recursive: true);
    }
    imageDirectory.createSync(recursive: true);

    final newManholeCardImageList = await Future.wait(
      manholeCardImages.map(
        (manholeCardImage) async {
          final firebaseStoragePath = _storage.ref().child(
                'images/cards/${manholeCardImage.name}',
              );
          final data = await firebaseStoragePath.getData();
          if (data == null) {
            return manholeCardImage;
          }
          final imagePath = '${imageDirectory.path}/${manholeCardImage.name}';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(data);
          return manholeCardImage.copyWith(path: imagePath);
        },
      ),
    );
    return Result.success(
      ManholeCardImages(
        list: newManholeCardImageList,
      ),
    );
  }

  @override
  Future<Result<void>> deleteMaster() async {
    var config = Configuration.local([
      RealmImageDAO.schema,
    ]);
    var realm = Realm(config);

    realm.write(() {
      realm.deleteAll<RealmImageDAO>();
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<void>> saveMaster({
    required ManholeCardImages manholeCardImages,
  }) async {
    var config = Configuration.local([
      RealmImageDAO.schema,
    ]);
    var realm = Realm(config);

    final realmImages = RealmImagesMapper.convertFromModel(
      model: manholeCardImages,
    );

    realm.write(() {
      realm.addAll(realmImages);
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<ManholeCardImage>> get({required String id}) async {
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
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした',
        ),
      );
    }
    final image = RealmImageMapper.convertToModel(dao: daoOrNull);
    return Result.success(image);
  }

  void dispose() {
    _logger.d('ImageRepositoryImpl dispose');
  }
}
