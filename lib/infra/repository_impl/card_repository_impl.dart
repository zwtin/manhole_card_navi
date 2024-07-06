import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/manhole_card_contact.dart';
import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_volume.dart';
import '/domain/entity/manhole_cards.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_contact_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/infra/mapper/realm_card_mapper.dart';
import '/infra/mapper/realm_cards_mapper.dart';

final cardRepositoryProvider = Provider.autoDispose<CardRepository>(
  (ref) {
    final cardRepository = CardRepositoryImpl();
    ref.onDispose(cardRepository.dispose);
    return cardRepository;
  },
);

class CardRepositoryImpl implements CardRepository {
  final _logger = Logger();
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ManholeCards>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  }) async {
    try {
      final cardsQuerySnapshot = await _firestore
          .collection('master')
          .doc(inquiredMasterVersion.value)
          .collection('cards')
          .get();
      final cardList = await Future.wait(
        cardsQuerySnapshot.docs.map(
          (doc) async {
            final cardId = doc['id'] as String;

            final contactsQuerySnapshot = await _firestore
                .collection('master')
                .doc(inquiredMasterVersion.value)
                .collection('cards')
                .doc(cardId)
                .collection('contact_id')
                .get();
            final contactList = contactsQuerySnapshot.docs.map((element) {
              return ManholeCardContact(
                address: '',
                id: element['id'] as String,
                latitude: 0.0,
                longitude: 0.0,
                name: '',
                nameUrl: '',
                other: '',
                phoneNumber: '',
                time: '',
                timeOther: '',
              );
            }).toList();
            final contacts = ManholeCardContacts(list: contactList);

            final latitudeNum = doc['latitude'] as num;
            var latitude = latitudeNum.toDouble();
            final longitudeNum = doc['longitude'] as num;
            var longitude = longitudeNum.toDouble();

            return ManholeCard(
              id: doc['id'] as String,
              latitude: latitude,
              longitude: longitude,
              name: doc['name'] as String,
              publicationDate: DateFormat('yyyy/MM/dd').parse(
                doc['publication_date'] as String,
              ),
              contacts: contacts,
              distributionState: ManholeCardDistributionState.values.byName(
                doc['distribution_state'] as String,
              ),
              distributionLinkText: doc['distribution_link_text'] as String,
              distributionLinkUrl: doc['distribution_link_url'] as String,
              distributionText: doc['distribution_text'] as String,
              distributionOther: doc['distribution_other'] as String,
              image: ManholeCardImage(
                id: doc['image_id'] as String,
                name: '',
              ),
              prefecture: ManholeCardPrefecture(
                id: doc['prefecture_id'] as String,
                name: '',
              ),
              volume: ManholeCardVolume(
                id: doc['volume_id'] as String,
                name: '',
              ),
            );
          },
        ),
      );

      return Result.success(
        ManholeCards(
          list: cardList,
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
          RealmCardDAO.schema,
          RealmContactDAO.schema,
          RealmImageDAO.schema,
          RealmPrefectureDAO.schema,
          RealmVolumeDAO.schema,
        ],
        shouldDeleteIfMigrationNeeded: true,
      );
      var realm = Realm(config);

      realm.write(() {
        realm.deleteAll<RealmCardDAO>();
        realm.deleteAll<RealmContactDAO>();
        realm.deleteAll<RealmImageDAO>();
        realm.deleteAll<RealmPrefectureDAO>();
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
    required ManholeCards manholeCards,
  }) async {
    try {
      var config = Configuration.local([
        RealmCardDAO.schema,
        RealmContactDAO.schema,
        RealmImageDAO.schema,
        RealmPrefectureDAO.schema,
        RealmVolumeDAO.schema,
      ]);
      var realm = Realm(config);

      final realmCards = RealmCardsMapper.convertFromEntity(
        entity: manholeCards,
      );

      realm.write(() {
        realm.addAll(
          realmCards,
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
  Future<Result<ManholeCard>> get({
    required String id,
  }) async {
    try {
      var config = Configuration.local([
        RealmCardDAO.schema,
        RealmContactDAO.schema,
        RealmImageDAO.schema,
        RealmPrefectureDAO.schema,
        RealmVolumeDAO.schema,
      ]);
      var realm = Realm(config);

      final daoOrNull = realm
          .all<RealmCardDAO>()
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
      final contact = RealmCardMapper.convertToEntity(dao: daoOrNull);
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
          text: 'カードデータの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('CardRepositoryImpl dispose');
  }
}
