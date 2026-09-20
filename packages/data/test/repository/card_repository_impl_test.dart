import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/card_image_data_source.dart';
import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/repository/card_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';
import '../fixtures.dart';

class MockCardImageDataSource extends Mock implements CardImageDataSource {}

void main() {
  late Directory directory;
  late MasterDataLocalDataSource store;
  late MockCardImageDataSource cardImage;
  late MockFirebaseCrashlytics crashlytics;
  late CardRepositoryImpl repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('card_repository');
    store = MasterDataLocalDataSource(directory: () async => directory);
    cardImage = MockCardImageDataSource();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = CardRepositoryImpl(
      store,
      cardImage,
      FailureRecorder(crashlytics: crashlytics),
    );
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('ID でカードを読む', () async {
    await store.writeAll([localCard(id: 'A'), localCard(id: 'B')]);

    final result = await repository.get(id: 'B');

    expect((result as Success<ManholeCard>).value, card(id: 'B'));
  });

  test('ない ID は、データがない失敗として返し、記録する', () async {
    await store.writeAll([localCard(id: 'A')]);

    final result = await repository.get(id: 'Z');

    expect((result as Failure<ManholeCard>).exception, isA<NotFoundException>());
    expect(recordedErrors(crashlytics).single.error, isA<NotFoundException>());
  });

  test('マスターデータを取り込む前は、全件の読み取りも失敗にする', () async {
    final result = await repository.fetchAll();

    expect(
      (result as Failure<List<ManholeCard>>).exception,
      isA<NotFoundException>(),
    );
  });

  group('fetchImage', () {
    void stubImage(Future<Uint8List> Function() response) {
      when(
        () => cardImage.fetch(
          url: any(named: 'url'),
          subUrl: any(named: 'subUrl'),
          maxWidth: any(named: 'maxWidth'),
        ),
      ).thenAnswer((_) => response());
    }

    test('カードの画像の URL と代わりの配信元を渡して取る', () async {
      await store.writeAll([
        localCard(
          id: 'A',
          image: 'https://r2/A.jpg',
          imageSub: 'https://sub/A.jpg',
        ),
      ]);
      stubImage(() async => Uint8List.fromList([1, 2, 3]));

      final result = await repository.fetchImage(cardId: 'A', maxWidth: 520);

      expect((result as Success<List<int>>).value, [1, 2, 3]);
      verify(
        () => cardImage.fetch(
          url: 'https://r2/A.jpg',
          subUrl: 'https://sub/A.jpg',
          maxWidth: 520,
        ),
      ).called(1);
    });

    test('ない ID は、データがない失敗として返す', () async {
      await store.writeAll([localCard(id: 'A')]);

      final result = await repository.fetchImage(cardId: 'Z');

      expect((result as Failure).exception, isA<NotFoundException>());
      verifyNever(
        () => cardImage.fetch(
          url: any(named: 'url'),
          subUrl: any(named: 'subUrl'),
          maxWidth: any(named: 'maxWidth'),
        ),
      );
    });

    test('画像の取得の失敗は、種類に変換して返すが記録しない', () async {
      await store.writeAll([localCard(id: 'A')]);
      stubImage(
        () async => throw const HandshakeException('WRONG_VERSION_NUMBER'),
      );

      final result = await repository.fetchImage(cardId: 'A');

      expect((result as Failure).exception, isA<OfflineException>());
      verifyNever(
        () => crashlytics.recordError(
          any(),
          any(),
          reason: any(named: 'reason'),
          information: any(named: 'information'),
          printDetails: any(named: 'printDetails'),
          fatal: any(named: 'fatal'),
        ),
      );
    });
  });
}
