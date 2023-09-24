import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/custom_exception.dart';
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
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final querySnapshot = await _firestore
        .collection('master')
        .doc(currentMasterVersion.version)
        .collection('contacts')
        .get();
    final list = querySnapshot.docs.map(
      (doc) {
        return ManholeCardContact(
          address: doc['address'] as String,
          id: doc['id'] as String,
          latitude: doc['latitude'] as double,
          longitude: doc['longitude'] as double,
          name: doc['name'] as String,
          other: doc['other'] as String,
          phoneNumber: doc['phone_number'] as String,
        );
      },
    ).toList();
    return Result.success(
      ManholeCardContacts(
        list: list,
      ),
    );
  }

  @override
  Future<Result<void>> deleteMaster() async {
    var config = Configuration.local([
      RealmContactDAO.schema,
    ]);
    var realm = Realm(config);

    realm.write(() {
      realm.deleteAll<RealmContactDAO>();
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<void>> saveMaster({
    required ManholeCardContacts manholeCardContacts,
  }) async {
    var config = Configuration.local([
      RealmContactDAO.schema,
    ]);
    var realm = Realm(config);

    final realmContacts = RealmContactsMapper.convertFromModel(
      model: manholeCardContacts,
    );

    realm.write(() {
      realm.addAll(realmContacts);
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<ManholeCardContact>> get({
    required String id,
  }) async {
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
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした',
        ),
      );
    }
    final contact = RealmContactMapper.convertToModel(dao: daoOrNull);
    return Result.success(contact);
  }

  void dispose() {
    _logger.d('ContactRepositoryImpl dispose');
  }
}
