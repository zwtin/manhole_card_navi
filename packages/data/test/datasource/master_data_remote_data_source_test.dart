import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/master_data_remote_data_source.dart';

import '../model/firestore_master_models_test.dart'
    show cardDocument, cardUpdateDocument;

// Firestore の型は sealed だが、テストのために差し替える。
// ignore_for_file: subtype_of_sealed_class

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollection extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocument extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocument extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirestore firestore;
  late MockDocument master;
  late MasterDataRemoteDataSource dataSource;

  void stubCollection(String name, List<Map<String, dynamic>> documents) {
    final collection = MockCollection();
    final snapshot = MockQuerySnapshot();
    final docs = [for (final data in documents) _document(data)];
    when(() => master.collection(name)).thenReturn(collection);
    when(collection.get).thenAnswer((_) async => snapshot);
    when(() => snapshot.docs).thenReturn(docs);
  }

  setUp(() {
    firestore = MockFirestore();
    master = MockDocument();
    final masters = MockCollection();
    when(() => firestore.collection('master')).thenReturn(masters);
    when(() => masters.doc('0006')).thenReturn(master);
    dataSource = MasterDataRemoteDataSource(firestore);
  });

  test('master の配下にある 3 つのコレクションを読んで model にする', () async {
    stubCollection('cards', [cardDocument()]);
    stubCollection('prefectures', [
      {'id': '27', 'name': '大阪府'},
    ]);
    stubCollection('volumes', [
      {'id': '0000', 'name': '第1弾'},
    ]);

    final master = await dataSource.read('0006');

    expect(master.cards.single.id, '27-226-B001');
    expect(master.prefectures.single.name, '大阪府');
    expect(master.volumes.single.name, '第1弾');
  });

  test('カードが 1 枚もなくても、空のまま返す（判断は Repository の役目）', () async {
    stubCollection('cards', []);
    stubCollection('prefectures', []);
    stubCollection('volumes', []);

    final master = await dataSource.read('0006');

    expect(master.cards, isEmpty);
  });

  test('形の違うドキュメントは、読めなかったことをそのまま投げる', () async {
    stubCollection('cards', [cardDocument()..remove('name')]);
    stubCollection('prefectures', []);
    stubCollection('volumes', []);

    await expectLater(
      dataSource.read('0006'),
      throwsA(isA<CheckedFromJsonException>()),
    );
  });

  test('取得できなければ、Firestore の例外をそのまま投げる', () async {
    stubCollection('prefectures', []);
    stubCollection('volumes', []);
    final cards = MockCollection();
    when(() => master.collection('cards')).thenReturn(cards);
    when(cards.get).thenThrow(
      FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
    );

    await expectLater(
      dataSource.read('0006'),
      throwsA(isA<FirebaseException>()),
    );
  });

  group('readCardUpdates', () {
    void stubCardUpdates(Map<String, dynamic>? data) {
      final collection = MockCollection();
      final document = MockDocument();
      final snapshot = MockDocumentSnapshot();
      when(() => master.collection('card_updates')).thenReturn(collection);
      when(() => collection.doc('current')).thenReturn(document);
      when(document.get).thenAnswer((_) async => snapshot);
      when(snapshot.data).thenReturn(data);
    }

    test('master の配下の差分を読んで model にする', () async {
      stubCardUpdates({
        'cards': [cardUpdateDocument()],
      });

      final updates = await dataSource.readCardUpdates('0006');

      expect(updates.single.id, '27-226-B001');
    });

    test('ドキュメントがなければ、差分はない', () async {
      stubCardUpdates(null);

      expect(await dataSource.readCardUpdates('0006'), isEmpty);
    });

    test('形の違うドキュメントは、読めなかったことをそのまま投げる', () async {
      stubCardUpdates({
        'cards': [cardUpdateDocument()..remove('stock_html')],
      });

      await expectLater(
        dataSource.readCardUpdates('0006'),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });
  });
}

MockQueryDocument _document(Map<String, dynamic> data) {
  final document = MockQueryDocument();
  when(document.data).thenReturn(data);
  return document;
}
