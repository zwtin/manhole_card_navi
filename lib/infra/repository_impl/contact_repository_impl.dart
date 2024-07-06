import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_contact.dart';
import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/result.dart';
import '/domain/repository/contact_repository.dart';
import '/infra/dao/realm_contact_dao.dart';
import '/infra/mapper/realm_contact_mapper.dart';
import '/infra/mapper/realm_contacts_mapper.dart';

final contactRepositoryProvider = Provider.autoDispose<ContactRepository>(
  (ref) {
    final contactRepository = ContactRepositoryImpl();
    ref.onDispose(contactRepository.dispose);
    return contactRepository;
  },
);

class ContactRepositoryImpl implements ContactRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ManholeCardContacts>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('master')
          .doc(inquiredMasterVersion.value)
          .collection('contacts')
          .get();
      final list = querySnapshot.docs.map(
        (doc) {
          final latitudeNum = doc['latitude'] as num;
          var latitude = latitudeNum.toDouble();
          final longitudeNum = doc['longitude'] as num;
          var longitude = longitudeNum.toDouble();
          return ManholeCardContact(
            address: doc['address'] as String,
            id: doc['id'] as String,
            latitude: latitude,
            longitude: longitude,
            name: doc['name'] as String,
            nameUrl: doc['name_url'] as String,
            other: doc['other'] as String,
            phoneNumber: doc['phone_number'] as String,
            time: doc['time'] as String,
            timeOther: doc['time_other'] as String,
          );
        },
      ).toList();
      return Result.success(
        ManholeCardContacts(
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
          RealmContactDAO.schema,
        ],
        shouldDeleteIfMigrationNeeded: true,
      );
      var realm = Realm(config);

      realm.write(() {
        realm.deleteAll<RealmContactDAO>();
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
    required ManholeCardContacts manholeCardContacts,
  }) async {
    try {
      var config = Configuration.local([
        RealmContactDAO.schema,
      ]);
      var realm = Realm(config);

      final realmContacts = RealmContactsMapper.convertFromEntity(
        entity: manholeCardContacts,
      );

      realm.write(() {
        realm.addAll(
          realmContacts,
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
  Future<Result<ManholeCardContact>> get({
    required String id,
  }) async {
    try {
      var config = Configuration.local([
        RealmContactDAO.schema,
      ]);
      var realm = Realm(config);

      final daoOrNull = realm
          .all<RealmContactDAO>()
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
      final contact = RealmContactMapper.convertToEntity(dao: daoOrNull);
      realm.close();
      return Result.success(contact);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '配布場所データの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('ContactRepositoryImpl dispose');
  }
}
