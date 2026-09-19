import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/src/mapper/firestore_master_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _cardData() {
  return {
    'id': '27-226-B001',
    'location': const GeoPoint(34.5, 135.6),
    'name': '藤井寺市',
    'publication_date': '2026/01/01',
    'distribution_state': 'distributing',
    'image_url': 'https://example.com/27-226-B001.jpg',
    'image_sub_url': 'https://sub.example.com/27-226-B001.jpg',
    'distribution_place_html': '<p>市役所</p>',
    'distribution_time_html': '<p>平日</p>',
    'stock_html': '<p>あり</p>',
    'distribution_points': [const GeoPoint(34.1, 135.1), 'not a point'],
    'prefecture_id': '27',
    'volume_id': '0000',
  };
}

ManholeCard _toCard(Map<String, dynamic> data) {
  return FirestoreMasterMapper.toCard(
    data,
    path: 'master/0006/cards/27-226-B001',
    prefectures: const {
      '27': ManholeCardPrefecture(id: '27', name: '大阪府'),
    },
    volumes: const {
      '0000': ManholeCardVolume(id: '0000', name: '第1弾'),
    },
  );
}

void main() {
  group('toCard', () {
    test('都道府県名・弾名を引き当てたカードにする', () {
      final card = _toCard(_cardData());

      expect(card.id, '27-226-B001');
      expect(card.position.latitude, 34.5);
      expect(card.publicationDate, DateTime(2026, 1, 1));
      expect(
        card.distributionState,
        ManholeCardDistributionState.distributing,
      );
      expect(card.prefecture.name, '大阪府');
      expect(card.volume.name, '第1弾');
    });

    test('配布地点は座標でない要素を読み飛ばす', () {
      final card = _toCard(_cardData());

      expect(
        card.distributionPoints,
        [const Coordinate(latitude: 34.1, longitude: 135.1)],
      );
    });

    test('代替配信元の URL が無い世代の master では空文字にする', () {
      final card = _toCard(_cardData()..remove('image_sub_url'));

      expect(card.imageSub, '');
    });

    test('都道府県の一覧に無い ID（全国向けなど）は名前を空にする', () {
      final card = _toCard(_cardData()..['prefecture_id'] = '00');

      expect(card.prefecture, const ManholeCardPrefecture(id: '00', name: ''));
    });

    test('必須の項目が欠けていれば、データが壊れている失敗にする', () {
      expect(
        () => _toCard(_cardData()..remove('name')),
        throwsA(
          isA<CorruptedDataException>().having(
            (exception) => exception.detail,
            'detail',
            contains('master/0006/cards/27-226-B001 の name'),
          ),
        ),
      );
    });

    test('項目の型が違えば、データが壊れている失敗にする', () {
      expect(
        () => _toCard(_cardData()..['location'] = '34.5,135.6'),
        throwsA(isA<CorruptedDataException>()),
      );
    });

    test('日付として読めなければ、データが壊れている失敗にする', () {
      expect(
        () => _toCard(_cardData()..['publication_date'] = '令和8年1月1日'),
        throwsA(isA<CorruptedDataException>()),
      );
    });

    test('知らない配布状態なら、データが壊れている失敗にする', () {
      expect(
        () => _toCard(_cardData()..['distribution_state'] = 'unknown'),
        throwsA(isA<CorruptedDataException>()),
      );
    });
  });
}
