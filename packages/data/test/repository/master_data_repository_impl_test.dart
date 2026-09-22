import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/datasource/master_data_remote_data_source.dart';
import 'package:data/src/model/firestore_master_models.dart';
import 'package:data/src/repository/master_data_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';
import '../fixtures.dart';
import '../model/firestore_master_models_test.dart' show cardDocument;

class MockMasterDataRemoteDataSource extends Mock
    implements MasterDataRemoteDataSource {}

void main() {
  const version = MasterVersion(value: '0006');

  late Directory directory;
  late MasterDataLocalDataSource local;
  late MockMasterDataRemoteDataSource remote;
  late MasterDataRepositoryImpl repository;

  void stubRead({
    List<Map<String, dynamic>> cards = const [],
    List<Map<String, dynamic>> prefectures = const [],
    List<Map<String, dynamic>> volumes = const [],
  }) {
    when(() => remote.read('0006')).thenAnswer(
      (_) async => FirestoreMasterModel(
        cards: [
          for (final card in cards) FirestoreCardModel.fromDocument(card),
        ],
        prefectures: [
          for (final prefecture in prefectures)
            FirestorePrefectureModel.fromDocument(prefecture),
        ],
        volumes: [
          for (final volume in volumes)
            FirestoreVolumeModel.fromDocument(volume),
        ],
      ),
    );
  }

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('master_data');
    local = MasterDataLocalDataSource(directory: () async => directory);
    remote = MockMasterDataRemoteDataSource();
    final crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = MasterDataRepositoryImpl(
      remote,
      local,
      CrashlyticsDataSource(crashlytics),
    );
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('カードに都道府県名・弾名を引き当てて、端末のものと入れ替える', () async {
    await local.writeAll([localCard(id: 'old')]);
    stubRead(
      cards: [cardDocument()],
      prefectures: [
        {'id': '27', 'name': '大阪府'},
      ],
      volumes: [
        {'id': '0000', 'name': '第1弾'},
      ],
    );

    final result = await repository.replace(version: version);

    expect(result, isA<Success<void>>());
    final cards = (await local.readAll())!;
    expect(cards.map((card) => card.id), ['27-226-B001']);
    expect(cards.single.prefecture.name, '大阪府');
    expect(cards.single.volume.name, '第1弾');
    expect(cards.single.image, 'https://example.com/27-226-B001.jpg');
    expect(cards.single.imageSub, 'https://sub.example.com/27-226-B001.jpg');
  });

  test('カードが 1 枚もなければ壊れたデータにし、端末のものは変えない', () async {
    await local.writeAll([localCard(id: 'old')]);
    stubRead();

    final result = await repository.replace(version: version);

    expect(
      (result as Failure<void>).exception,
      isA<CorruptedDataException>(),
    );
    expect((await local.readAll())!.map((card) => card.id), ['old']);
  });

  test('形の違うドキュメントがあれば壊れたデータにし、端末のものは変えない', () async {
    await local.writeAll([localCard(id: 'old')]);
    when(() => remote.read('0006')).thenThrow(
      CheckedFromJsonException({}, 'name', 'FirestoreCardModel', '型が違います'),
    );

    final result = await repository.replace(version: version);

    expect(
      (result as Failure<void>).exception,
      isA<CorruptedDataException>().having(
        (exception) => exception.detail,
        'detail',
        contains('FirestoreCardModel の name'),
      ),
    );
    expect((await local.readAll())!.map((card) => card.id), ['old']);
  });

  test('取得できなければ通信できない失敗にし、端末のものは変えない', () async {
    await local.writeAll([localCard(id: 'old')]);
    when(() => remote.read('0006')).thenThrow(
      FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
    );

    final result = await repository.replace(version: version);

    expect((result as Failure<void>).exception, isA<OfflineException>());
    expect((await local.readAll())!.map((card) => card.id), ['old']);
  });
}
