import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/repository/master_data_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';
import '../fixtures.dart';
import '../model/firestore_master_models_test.dart' show cardDocument;

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

void main() {
  const version = MasterVersion(value: '0006');

  late Directory directory;
  late MasterDataLocalDataSource store;
  late MockFirestore firestore;
  late MockDocument master;
  late MasterDataRepositoryImpl repository;

  void stubCollection(String name, List<Map<String, dynamic>> documents) {
    final collection = MockCollection();
    final snapshot = MockQuerySnapshot();
    final docs = [
      for (final (index, data) in documents.indexed)
        _document(data, path: 'master/0006/$name/$index'),
    ];
    when(() => master.collection(name)).thenReturn(collection);
    when(() => collection.get()).thenAnswer((_) async => snapshot);
    when(() => snapshot.docs).thenReturn(docs);
  }

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('master_data');
    store = MasterDataLocalDataSource(directory: () async => directory);
    firestore = MockFirestore();
    master = MockDocument();
    final masters = MockCollection();
    when(() => firestore.collection('master')).thenReturn(masters);
    when(() => masters.doc('0006')).thenReturn(master);
    when(() => master.path).thenReturn('master/0006');
    final crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = MasterDataRepositoryImpl(
      firestore,
      store,
      FailureRecorder(crashlytics: crashlytics),
    );
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('カードに都道府県名・弾名を引き当てて、端末のものと入れ替える', () async {
    await store.writeAll([localCard(id: 'old')]);
    stubCollection('cards', [cardDocument()]);
    stubCollection('prefectures', [
      {'id': '27', 'name': '大阪府'},
    ]);
    stubCollection('volumes', [
      {'id': '0000', 'name': '第1弾'},
    ]);

    final result = await repository.replace(version: version);

    expect(result, isA<Success<void>>());
    final cards = (await store.readAll())!;
    expect(cards.map((card) => card.id), ['27-226-B001']);
    expect(cards.single.prefecture.name, '大阪府');
    expect(cards.single.volume.name, '第1弾');
    expect(cards.single.image, 'https://example.com/27-226-B001.jpg');
    expect(cards.single.imageSub, 'https://sub.example.com/27-226-B001.jpg');
  });

  test('カードが 1 枚もなければ壊れたデータにし、端末のものは変えない', () async {
    await store.writeAll([localCard(id: 'old')]);
    stubCollection('cards', []);
    stubCollection('prefectures', []);
    stubCollection('volumes', []);

    final result = await repository.replace(version: version);

    expect(
      (result as Failure<void>).exception,
      isA<CorruptedDataException>(),
    );
    expect((await store.readAll())!.map((card) => card.id), ['old']);
  });

  test('形の違うドキュメントがあれば壊れたデータにし、端末のものは変えない', () async {
    await store.writeAll([localCard(id: 'old')]);
    stubCollection('cards', [cardDocument()..remove('name')]);
    stubCollection('prefectures', []);
    stubCollection('volumes', []);

    final result = await repository.replace(version: version);

    expect(
      (result as Failure<void>).exception,
      isA<CorruptedDataException>().having(
        (exception) => exception.detail,
        'detail',
        contains('master/0006/cards/0 の name'),
      ),
    );
    expect((await store.readAll())!.map((card) => card.id), ['old']);
  });

  test('取得できなければ通信できない失敗にし、端末のものは変えない', () async {
    await store.writeAll([localCard(id: 'old')]);
    stubCollection('prefectures', []);
    stubCollection('volumes', []);
    final cards = MockCollection();
    when(() => master.collection('cards')).thenReturn(cards);
    when(() => cards.get()).thenThrow(
      FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
    );

    final result = await repository.replace(version: version);

    expect((result as Failure<void>).exception, isA<OfflineException>());
    expect((await store.readAll())!.map((card) => card.id), ['old']);
  });
}

MockQueryDocument _document(
  Map<String, dynamic> data, {
  required String path,
}) {
  final document = MockQueryDocument();
  final reference = MockDocument();
  when(() => document.data()).thenReturn(data);
  when(() => document.reference).thenReturn(reference);
  when(() => reference.path).thenReturn(path);
  return document;
}
