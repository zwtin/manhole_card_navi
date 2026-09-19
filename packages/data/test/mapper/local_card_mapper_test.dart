import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:data/src/mapper/local_card_mapper.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:data/src/model/malformed_data_exception.dart';
import 'package:domain/domain.dart';

import '../fixtures.dart';

void main() {
  Map<String, dynamic> stored(LocalCardModel card) {
    return jsonDecode(jsonEncode(card.toJson())) as Map<String, dynamic>;
  }

  test('保存したカードを読み戻して、エンティティにできる', () {
    expect(
      LocalCardMapper.toCard(LocalCardModel.fromStoredJson(stored(localCard()))),
      card(),
    );
    expect(
      LocalCardMapper.toCard(
        LocalCardModel.fromStoredJson(
          stored(localCard(id: '00-101-A001', distributionPoints: const [])),
        ),
      ),
      card(id: '00-101-A001', distributionPoints: const []),
    );
  });

  test('座標が整数で書かれていても読める', () {
    final json = stored(localCard())
      ..['position'] = {'latitude': 35, 'longitude': 139};

    final read = LocalCardMapper.toCard(LocalCardModel.fromStoredJson(json));

    expect(read.position, const Coordinate(latitude: 35, longitude: 139));
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
        () => LocalCardModel.fromStoredJson(json),
        throwsA(isA<MalformedDataException>()),
        reason: '$json',
      );
    }
  });
}
