import 'dart:convert';

import 'package:data/src/mapper/manhole_card_json_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures.dart';

void main() {
  test('書いたカード一式を、そのまま読み戻せる', () {
    final cards = [
      card(),
      card(id: '00-101-A001', distributionPoints: const []),
    ];

    final source = ManholeCardJsonMapper.toJsonString(cards);

    expect(ManholeCardJsonMapper.fromJsonString(source), cards);
  });

  test('座標が整数で書かれていても読める', () {
    final json = jsonDecode(ManholeCardJsonMapper.toJsonString([card()]))
        as List<dynamic>;
    (json.single as Map<String, dynamic>)['position'] = {
      'latitude': 35,
      'longitude': 139,
    };

    final read = ManholeCardJsonMapper.fromJsonString(jsonEncode(json)).single;

    expect(read.position, const Coordinate(latitude: 35, longitude: 139));
  });

  test('壊れたファイルは、壊れたデータの失敗にする', () {
    final valid = jsonDecode(ManholeCardJsonMapper.toJsonString([card()]))
        as List<dynamic>;
    Map<String, dynamic> broken(String key, Object? value) {
      return {...(valid.single as Map<String, dynamic>), key: value};
    }

    for (final source in [
      '{"cards": [',
      '{"cards": []}',
      jsonEncode([broken('name', 1)]),
      jsonEncode([broken('distributionState', 'unknown')]),
      jsonEncode([broken('publicationDate', 'きのう')]),
      jsonEncode([broken('prefecture', null)]),
    ]) {
      expect(
        () => ManholeCardJsonMapper.fromJsonString(source),
        throwsA(isA<CorruptedDataException>()),
        reason: source,
      );
    }
  });
}
