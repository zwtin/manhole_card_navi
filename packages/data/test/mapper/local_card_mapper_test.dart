import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:data/src/mapper/local_card_mapper.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:domain/domain.dart';

import '../fixtures.dart';

void main() {
  Map<String, dynamic> stored(LocalCardModel card) {
    return jsonDecode(jsonEncode(card.toJson())) as Map<String, dynamic>;
  }

  test('保存したカードを読み戻して、エンティティにできる', () {
    expect(
      LocalCardMapper.toCard(LocalCardModel.fromJson(stored(localCard()))),
      card(),
    );
    expect(
      LocalCardMapper.toCard(
        LocalCardModel.fromJson(
          stored(localCard(id: '00-101-A001', distributionPoints: const [])),
        ),
      ),
      card(id: '00-101-A001', distributionPoints: const []),
    );
  });

  test('座標が整数で書かれていても読める', () {
    final json = stored(localCard())
      ..['position'] = {'latitude': 35, 'longitude': 139};

    final read = LocalCardMapper.toCard(LocalCardModel.fromJson(json));

    expect(read.position, const Coordinate(latitude: 35, longitude: 139));
  });

  test('差分を重ねると、変わる項目だけが差分の値になる', () {
    final updated = LocalCardMapper.toUpdatedCard(
      localCard(),
      localCardUpdate(),
    );

    final expected = localCard().toJson()
      ..addAll({
        'distributionState': 'distributing',
        'distributionPlaceHtml': '<p>藤井寺市立図書館</p>',
        'distributionTimeHtml': '<p>10:00〜18:00</p>',
        'stockHtml': '<p>再開</p>',
        'distributionPoints': [
          {'latitude': 34.58, 'longitude': 135.61},
        ],
      });
    expect(updated.toJson(), expected);
  });

  test('壊れたカードは、壊れたデータの失敗にする', () {
    Map<String, dynamic> broken(String key, Object? value) {
      return stored(localCard())..[key] = value;
    }

    for (final json in [
      broken('name', 1),
      broken('distributionState', 'unknown'),
      broken('publicationDate', 'きのう'),
      broken('prefecture', null),
    ]) {
      expect(
        () => LocalCardModel.fromJson(json),
        throwsA(isA<CheckedFromJsonException>()),
        reason: '$json',
      );
    }
  });
}
