import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
// GeoPoint は cloud_firestore と realm の両方にあるため、Firestore 側を使う。
import 'package:realm/realm.dart' hide GeoPoint;

import '/domain/entity/custom_exception.dart';
import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card.dart';
import '/domain/entity/manhole_card_distribution_point.dart';
import '/domain/entity/manhole_card_distribution_points.dart';
import '/domain/entity/manhole_card_distribution_state.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_volume.dart';
import '/domain/entity/manhole_cards.dart';
import '/domain/entity/result.dart';
import '/domain/repository/card_repository.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_configuration.dart';
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
      // 配布場所・画像はカードに埋め込まれているため、cards の 1 クエリだけで
      // 全カードが揃う。都道府県名・弾名は id のみ持ち、あとで引き当てる。
      final cardsQuerySnapshot = await _firestore
          .collection('master')
          .doc(inquiredMasterVersion.value)
          .collection('cards')
          .get();

      final cardList = cardsQuerySnapshot.docs.map(
        (doc) {
          final location = doc['location'] as GeoPoint;
          final geoPointList = doc['distribution_points'] as List<dynamic>;
          final distributionPoints = geoPointList
              .whereType<GeoPoint>()
              .map(
                (geoPoint) => ManholeCardDistributionPoint(
                  latitude: geoPoint.latitude,
                  longitude: geoPoint.longitude,
                ),
              )
              .toList();

          return ManholeCard(
            id: doc['id'] as String,
            latitude: location.latitude,
            longitude: location.longitude,
            name: doc['name'] as String,
            publicationDate: DateFormat('yyyy/MM/dd').parse(
              doc['publication_date'] as String,
            ),
            distributionState: ManholeCardDistributionState.fromString(
              doc['distribution_state'] as String,
            ),
            image: doc['image_url'] as String,
            distributionPlaceHtml: doc['distribution_place_html'] as String,
            distributionTimeHtml: doc['distribution_time_html'] as String,
            stockHtml: doc['stock_html'] as String,
            distributionPoints: ManholeCardDistributionPoints(
              list: distributionPoints,
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
      ).toList();

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
      var realm = RealmConfiguration.open();

      realm.write(() {
        realm.deleteAll<RealmCardDAO>();
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
      var realm = RealmConfiguration.open();

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
      var realm = RealmConfiguration.open();

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
      final card = RealmCardMapper.convertToEntity(dao: daoOrNull);
      realm.close();
      return Result.success(card);
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
