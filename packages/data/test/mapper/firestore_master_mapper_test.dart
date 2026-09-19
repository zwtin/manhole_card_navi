import 'package:data/src/mapper/firestore_master_mapper.dart';
import 'package:data/src/model/distribution_state_model.dart';
import 'package:data/src/model/firestore_master_models.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../model/firestore_master_models_test.dart' show cardDocument;

LocalCardModel _toLocalCard(Map<String, dynamic> data) {
  return FirestoreMasterMapper.toLocalCard(
    FirestoreCardModel.fromDocument(data, path: 'master/0006/cards/27-226-B001'),
    prefectures: const {'27': '大阪府'},
    volumes: const {'0000': '第1弾'},
  );
}

void main() {
  test('都道府県名・弾名を引き当てて、端末に保存するカードにする', () {
    final card = _toLocalCard(cardDocument());

    expect(card.id, '27-226-B001');
    expect(card.position.latitude, 34.5);
    expect(card.position.longitude, 135.6);
    expect(card.distributionState, DistributionStateModel.distributing);
    expect(
      [
        for (final point in card.distributionPoints)
          (point.latitude, point.longitude),
      ],
      [(34.1, 135.1)],
    );
    expect((card.prefecture.id, card.prefecture.name), ('27', '大阪府'));
    expect((card.volume.id, card.volume.name), ('0000', '第1弾'));
  });

  test('代替配信元の URL が無い世代の master では空文字にする', () {
    expect(_toLocalCard(cardDocument()..remove('image_sub_url')).imageSub, '');
  });

  test('都道府県の一覧に無い ID（全国向けなど）は名前を空にする', () {
    final card = _toLocalCard(cardDocument()..['prefecture_id'] = '00');

    expect((card.prefecture.id, card.prefecture.name), ('00', ''));
  });
}
