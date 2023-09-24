import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/current_master_version.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/manhole_card_contact.dart';
import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/manhole_card_distribution.dart';
import '/domain/entity/manhole_card_distributions.dart';
import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_images.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_prefectures.dart';
import '/domain/entity/manhole_card_volume.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/domain/entity/manhole_cards.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_contact_dao.dart';
import '/infra/dao/realm_distribution_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
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
    required CurrentMasterVersion currentMasterVersion,
  }) async {
    final cardsQuerySnapshot = await _firestore
        .collection('master')
        .doc(currentMasterVersion.version)
        .collection('cards')
        .get();
    final cardList = await Future.wait(
      cardsQuerySnapshot.docs.map(
        (doc) async {
          final cardId = doc['id'] as String;

          final contactsQuerySnapshot = await _firestore
              .collection('master')
              .doc(currentMasterVersion.version)
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
              other: '',
              phoneNumber: '',
            );
          }).toList();
          final contacts = ManholeCardContacts(list: contactList);

          final distributionsQuerySnapshot = await _firestore
              .collection('master')
              .doc(currentMasterVersion.version)
              .collection('cards')
              .doc(cardId)
              .collection('distribution_id')
              .get();
          final distributionList =
              distributionsQuerySnapshot.docs.map((element) {
            return ManholeCardDistribution(
              id: element['id'] as String,
              other: '',
              state: ManholeCardDistributionState.distributing,
            );
          }).toList();
          final distributions =
              ManholeCardDistributions(list: distributionList);

          final imagesQuerySnapshot = await _firestore
              .collection('master')
              .doc(currentMasterVersion.version)
              .collection('cards')
              .doc(cardId)
              .collection('image_id')
              .get();
          final imageList = imagesQuerySnapshot.docs.map((element) {
            return ManholeCardImage(
              id: element['id'] as String,
              name: '',
              path: '',
            );
          }).toList();
          final images = ManholeCardImages(list: imageList);

          final prefecturesQuerySnapshot = await _firestore
              .collection('master')
              .doc(currentMasterVersion.version)
              .collection('cards')
              .doc(cardId)
              .collection('prefecture_id')
              .get();
          final prefectureList = prefecturesQuerySnapshot.docs.map((element) {
            return ManholeCardPrefecture(
              id: element['id'] as String,
              name: '',
            );
          }).toList();
          final prefectures = ManholeCardPrefectures(list: prefectureList);

          final volumesQuerySnapshot = await _firestore
              .collection('master')
              .doc(currentMasterVersion.version)
              .collection('cards')
              .doc(cardId)
              .collection('volume_id')
              .get();
          final volumeList = volumesQuerySnapshot.docs.map((element) {
            return ManholeCardVolume(
              id: element['id'] as String,
              name: '',
            );
          }).toList();
          final volumes = ManholeCardVolumes(list: volumeList);

          return ManholeCard(
            id: doc['id'] as String,
            latitude: doc['latitude'] as double,
            longitude: doc['longitude'] as double,
            name: doc['name'] as String,
            publicationDate: DateFormat('yyyy/MM/dd')
                .parse(doc['publication_date'] as String),
            contacts: contacts,
            distributions: distributions,
            images: images,
            prefectures: prefectures,
            volumes: volumes,
          );
        },
      ),
    );

    return Result.success(
      ManholeCards(
        list: cardList,
      ),
    );
  }

  @override
  Future<Result<void>> deleteMaster() async {
    var config = Configuration.local([
      RealmCardDAO.schema,
      RealmContactDAO.schema,
      RealmDistributionDAO.schema,
      RealmImageDAO.schema,
      RealmPrefectureDAO.schema,
      RealmVolumeDAO.schema,
    ]);
    var realm = Realm(config);

    realm.write(() {
      realm.deleteAll<RealmCardDAO>();
      realm.deleteAll<RealmContactDAO>();
      realm.deleteAll<RealmDistributionDAO>();
      realm.deleteAll<RealmImageDAO>();
      realm.deleteAll<RealmPrefectureDAO>();
      realm.deleteAll<RealmVolumeDAO>();
    });
    realm.close();

    return const Result.success(null);
  }

  @override
  Future<Result<void>> saveMaster({
    required ManholeCards manholeCards,
  }) async {
    var config = Configuration.local([
      RealmCardDAO.schema,
      RealmContactDAO.schema,
      RealmDistributionDAO.schema,
      RealmImageDAO.schema,
      RealmPrefectureDAO.schema,
      RealmVolumeDAO.schema,
    ]);
    var realm = Realm(config);

    final realmCards = RealmCardsMapper.convertFromModel(
      model: manholeCards,
    );

    realm.write(() {
      realm.addAll(realmCards);
    });
    realm.close();

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('CardRepositoryImpl dispose');
  }
}
