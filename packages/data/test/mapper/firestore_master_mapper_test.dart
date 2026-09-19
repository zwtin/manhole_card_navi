import 'package:data/src/mapper/firestore_master_mapper.dart';
import 'package:data/src/model/firestore_master_models.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../model/firestore_master_models_test.dart' show cardDocument;

ManholeCard _toCard(Map<String, dynamic> data) {
  return FirestoreMasterMapper.toCard(
    FirestoreCardModel.fromDocument(data, path: 'master/0006/cards/27-226-B001'),
    prefectures: const {
      '27': Prefecture(id: '27', name: '大阪府'),
    },
    volumes: const {
      '0000': Volume(id: '0000', name: '第1弾'),
    },
  );
}

void main() {
  test('都道府県名・弾名を引き当てたカードにする', () {
    final card = _toCard(cardDocument());

    expect(card.id, '27-226-B001');
    expect(card.position, const Coordinate(latitude: 34.5, longitude: 135.6));
    expect(card.distributionPoints, [
      const Coordinate(latitude: 34.1, longitude: 135.1),
    ]);
    expect(card.prefecture.name, '大阪府');
    expect(card.volume.name, '第1弾');
  });

  test('代替配信元の URL が無い世代の master では空文字にする', () {
    expect(_toCard(cardDocument()..remove('image_sub_url')).imageSub, '');
  });

  test('都道府県の一覧に無い ID（全国向けなど）は名前を空にする', () {
    final card = _toCard(cardDocument()..['prefecture_id'] = '00');

    expect(card.prefecture, const Prefecture(id: '00', name: ''));
  });
}
