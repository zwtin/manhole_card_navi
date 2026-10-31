import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:data/src/model/distribution_state_model.dart';
import 'package:data/src/model/firestore_master_models.dart';
import 'package:json_annotation/json_annotation.dart';

Map<String, dynamic> cardDocument() {
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

Map<String, dynamic> cardUpdateDocument() {
  return {
    'id': '27-226-B001',
    'distribution_state': 'stopped',
    'distribution_place_html': '<p>図書館</p>',
    'distribution_time_html': '<p>土日</p>',
    'stock_html': '<p>なし</p>',
    'distribution_points': [const GeoPoint(34.2, 135.2), 'not a point'],
  };
}

void main() {
  FirestoreCardModel decode(Map<String, dynamic> data) {
    return FirestoreCardModel.fromDocument(data);
  }

  group('差分のドキュメント', () {
    test('変わったカードの最新の値を読む', () {
      final model = FirestoreCardUpdatesModel.fromDocument({
        'cards': [cardUpdateDocument()],
      }).cards.single;

      expect(model.id, '27-226-B001');
      expect(model.distributionState, DistributionStateModel.stopped);
      expect(model.distributionPlaceHtml, '<p>図書館</p>');
      expect(model.distributionPoints, [const GeoPoint(34.2, 135.2)]);
    });

    test('知らない配布状態は、読めなかったことを知らせる', () {
      expect(
        () => FirestoreCardUpdatesModel.fromDocument({
          'cards': [cardUpdateDocument()..['distribution_state'] = 'unknown'],
        }),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });
  });

  test('カードのドキュメントを読む', () {
    final model = decode(cardDocument());

    expect(model.id, '27-226-B001');
    expect(model.location, const GeoPoint(34.5, 135.6));
    expect(model.publicationDate, DateTime(2026, 1, 1));
    expect(model.distributionState, DistributionStateModel.distributing);
  });

  test('配布地点は座標でない要素を読み飛ばす', () {
    expect(decode(cardDocument()).distributionPoints, [
      const GeoPoint(34.1, 135.1),
    ]);
  });

  test('必須の項目が欠けていれば、どの項目かを添えて読めなかったことを知らせる', () {
    expect(
      () => decode(cardDocument()..remove('name')),
      throwsA(
        isA<CheckedFromJsonException>()
            .having((exception) => exception.key, 'key', 'name')
            .having(
              (exception) => exception.className,
              'className',
              'FirestoreCardModel',
            ),
      ),
    );
  });

  test('型が違う・日付として読めない・知らない配布状態なら、壊れたデータにする', () {
    for (final entry in <String, Object>{
      'location': '34.5,135.6',
      'publication_date': '令和8年1月1日',
      'distribution_state': 'unknown',
      'distribution_points': 'none',
    }.entries) {
      expect(
        () => decode(cardDocument()..[entry.key] = entry.value),
        throwsA(isA<CheckedFromJsonException>()),
        reason: entry.key,
      );
    }
  });

  test('都道府県・弾のドキュメントも、欠けていれば読めなかったことを知らせる', () {
    expect(
      FirestorePrefectureModel.fromDocument({'id': '27', 'name': '大阪府'}).name,
      '大阪府',
    );
    expect(
      () => FirestoreVolumeModel.fromDocument({'id': '0000'}),
      throwsA(isA<CheckedFromJsonException>()),
    );
  });
}
