import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/datasource/master_data_remote_data_source.dart';
import 'package:data/src/model/firestore_master_models.dart';
import 'package:data/src/model/local_master_data_model.dart';
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
  late MockFirebaseCrashlytics crashlytics;

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

  void expectUnchanged(LocalMasterDataModel? master) {
    expect(master!.version, '0005');
    expect(master.cards.map((card) => card.id), ['old']);
  }

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('master_data');
    local = MasterDataLocalDataSource(directory: () async => directory);
    remote = MockMasterDataRemoteDataSource();
    crashlytics = MockFirebaseCrashlytics();
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
    await local.write(
      LocalMasterDataModel(
        version: '0005',
        cards: [localCard(id: 'old')],
      ),
    );
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
    final master = (await local.read())!;
    expect(master.version, '0006');
    final cards = master.cards;
    expect(cards.map((card) => card.id), ['27-226-B001']);
    expect(cards.single.prefecture.name, '大阪府');
    expect(cards.single.volume.name, '第1弾');
    expect(cards.single.image, 'https://example.com/27-226-B001.jpg');
    expect(cards.single.imageSub, 'https://sub.example.com/27-226-B001.jpg');
  });

  test('カードが 1 枚もなければ壊れたデータにし、端末のものは変えない', () async {
    await local.write(
      LocalMasterDataModel(
        version: '0005',
        cards: [localCard(id: 'old')],
      ),
    );
    stubRead();

    final result = await repository.replace(version: version);

    expect((result as Failure<void>).exception, isA<CorruptedDataException>());
    expectUnchanged(await local.read());
  });

  test('カードが、ない都道府県・弾を指していれば壊れたデータにし、端末のものは変えない', () async {
    await local.write(
      LocalMasterDataModel(
        version: '0005',
        cards: [localCard(id: 'old')],
      ),
    );
    for (final (prefectures, volumes) in [
      (
        <Map<String, dynamic>>[],
        [
          {'id': '0000', 'name': '第1弾'},
        ],
      ),
      (
        [
          {'id': '27', 'name': '大阪府'},
        ],
        <Map<String, dynamic>>[],
      ),
    ]) {
      stubRead(
        cards: [cardDocument()],
        prefectures: prefectures,
        volumes: volumes,
      );

      final result = await repository.replace(version: version);

      expect(
        (result as Failure<void>).exception,
        isA<CorruptedDataException>(),
      );
      expectUnchanged(await local.read());
    }
  });

  test('形の違うドキュメントがあれば壊れたデータにし、端末のものは変えない', () async {
    await local.write(
      LocalMasterDataModel(
        version: '0005',
        cards: [localCard(id: 'old')],
      ),
    );
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
    expectUnchanged(await local.read());
  });

  test('取得できなければ通信できない失敗にし、端末のものは変えない', () async {
    await local.write(
      LocalMasterDataModel(
        version: '0005',
        cards: [localCard(id: 'old')],
      ),
    );
    when(() => remote.read('0006')).thenThrow(
      FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
    );

    final result = await repository.replace(version: version);

    expect((result as Failure<void>).exception, isA<OfflineException>());
    expectUnchanged(await local.read());
  });

  group('getCurrentVersion', () {
    test('まだ取り込んでいなければ null', () async {
      expect(
        (await repository.getCurrentVersion() as Success<MasterVersion?>).value,
        isNull,
      );
    });

    test('入れ替えた後は、カードと一緒に書いたバージョンを返す', () async {
      stubRead(
        cards: [cardDocument()],
        prefectures: [
          {'id': '27', 'name': '大阪府'},
        ],
        volumes: [
          {'id': '0000', 'name': '第1弾'},
        ],
      );
      await repository.replace(version: version);

      final next = MasterDataRepositoryImpl(
        remote,
        MasterDataLocalDataSource(directory: () async => directory),
        CrashlyticsDataSource(crashlytics),
      );

      expect(
        (await next.getCurrentVersion() as Success<MasterVersion?>).value,
        version,
      );
    });

    test('壊れていれば 1 回記録して壊れたデータの失敗にし、次は取り込んでいない扱い', () async {
      File(
        '${directory.path}/master_data.json',
      ).writeAsStringSync('{"version":"0006","cards":[]}');

      final result = await repository.getCurrentVersion();

      expect(
        (result as Failure<MasterVersion?>).exception,
        isA<CorruptedDataException>(),
      );
      verify(
        () => crashlytics.recordError(
          any(),
          any(),
          fatal: any(named: 'fatal'),
          reason: any(named: 'reason'),
          information: any(named: 'information'),
        ),
      ).called(1);
      expect(
        (await repository.getCurrentVersion() as Success<MasterVersion?>).value,
        isNull,
      );
    });
  });
}
