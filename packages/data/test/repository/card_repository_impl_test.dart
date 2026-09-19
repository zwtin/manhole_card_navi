import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/card_image_cache_manager.dart';
import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/datasource/image_fallback.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/repository/card_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';
import '../fixtures.dart';

class MockCardImageCacheManager extends Mock
    implements CardImageCacheManager {}

void main() {
  late Directory directory;
  late MasterDataLocalDataSource store;
  late MockCardImageCacheManager imageCacheManager;
  late MockFirebaseCrashlytics crashlytics;
  late CardRepositoryImpl repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('card_repository');
    store = MasterDataLocalDataSource(directory: () async => directory);
    imageCacheManager = MockCardImageCacheManager();
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = CardRepositoryImpl(
      store,
      imageCacheManager,
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
    void stubImage(Stream<FileResponse> Function() response) {
      when(
        () => imageCacheManager.getImageFile(
          any(),
          headers: any(named: 'headers'),
          maxWidth: any(named: 'maxWidth'),
        ),
      ).thenAnswer((_) => response());
    }

    test('カードの画像の URL と代わりの配信元で取り、保存したデータを返す', () async {
      await store.writeAll([
        localCard(
          id: 'A',
          image: 'https://r2/A.jpg',
          imageSub: 'https://sub/A.jpg',
        ),
      ]);
      final file = await MemoryCacheSystem().createFile('A.jpg');
      await file.writeAsBytes([1, 2, 3]);
      stubImage(
        () => Stream.value(
          FileInfo(file, FileSource.Cache, DateTime(2026), 'https://r2/A.jpg'),
        ),
      );

      final result = await repository.fetchImage(cardId: 'A', maxWidth: 520);

      expect((result as Success<List<int>>).value, [1, 2, 3]);
      verify(
        () => imageCacheManager.getImageFile(
          'https://r2/A.jpg',
          headers: ImageFallback.headers('https://sub/A.jpg'),
          maxWidth: 520,
        ),
      ).called(1);
    });

    test('ない ID は、データがない失敗として返す', () async {
      await store.writeAll([localCard(id: 'A')]);

      final result = await repository.fetchImage(cardId: 'Z');

      expect((result as Failure).exception, isA<NotFoundException>());
      verifyNever(
        () => imageCacheManager.getImageFile(
          any(),
          headers: any(named: 'headers'),
          maxWidth: any(named: 'maxWidth'),
        ),
      );
    });

    test('画像の取得の失敗は、種類に変換して返すが記録しない', () async {
      await store.writeAll([localCard(id: 'A')]);
      stubImage(
        () => Stream.error(
          const HandshakeException('WRONG_VERSION_NUMBER'),
        ),
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
