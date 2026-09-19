import 'dart:convert';

import 'package:data/src/mapper/local_card_mapper.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures.dart';

void main() {
  ManholeCard roundTrip(ManholeCard card) {
    final json = jsonDecode(jsonEncode(LocalCardMapper.toModel(card).toJson()))
        as Map<String, dynamic>;
    return LocalCardMapper.toCard(LocalCardModel.fromStoredJson(json));
  }

  test('保存したカードを、そのまま読み戻せる', () {
    for (final original in [
      card(),
      card(id: '00-101-A001', distributionPoints: const []),
    ]) {
      expect(roundTrip(original), original);
    }
  });

  test('座標が整数で書かれていても読める', () {
    final json = LocalCardMapper.toModel(card()).toJson()
      ..['position'] = {'latitude': 35, 'longitude': 139};

    final read = LocalCardMapper.toCard(LocalCardModel.fromStoredJson(json));

    expect(read.position, const Coordinate(latitude: 35, longitude: 139));
  });

  test('壊れたカードは、壊れたデータの失敗にする', () {
    Map<String, dynamic> broken(String key, Object? value) {
      final json = jsonDecode(jsonEncode(LocalCardMapper.toModel(card()).toJson()))
          as Map<String, dynamic>;
      return json..[key] = value;
    }

    for (final json in [
      broken('name', 1),
      broken('distributionState', 'unknown'),
      broken('publicationDate', 'きのう'),
      broken('prefecture', null),
    ]) {
      expect(
        () => LocalCardModel.fromStoredJson(json),
        throwsA(isA<CorruptedDataException>()),
        reason: '$json',
      );
    }
  });
}
