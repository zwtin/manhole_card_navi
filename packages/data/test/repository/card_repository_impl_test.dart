import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/card_image_data_source.dart';
import 'package:data/src/datasource/card_updates_local_data_source.dart';
import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/model/analytics_event_model.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/repository/card_repository_impl.dart';
import 'package:domain/domain.dart';

import '../datasource/crashlytics_mock.dart';
import '../fixtures.dart';

class MockCardImageDataSource extends Mock implements CardImageDataSource {}

class MockAnalyticsDataSource extends Mock implements AnalyticsDataSource {}

void main() {
  late Directory directory;
  late MasterDataLocalDataSource store;
  late CardUpdatesLocalDataSource updates;
  late MockCardImageDataSource cardImage;
  late MockAnalyticsDataSource analytics;
  late MockFirebaseCrashlytics crashlytics;
  late CardRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const AnalyticsEventModel(name: '', parameters: {}));
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('card_repository');
    store = MasterDataLocalDataSource(directory: () async => directory);
    updates = CardUpdatesLocalDataSource(directory: () async => directory);
    cardImage = MockCardImageDataSource();
    analytics = MockAnalyticsDataSource();
    when(() => analytics.send(any())).thenAnswer((_) async {});
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = CardRepositoryImpl(
      store,
      updates,
      cardImage,
      analytics,
      CrashlyticsDataSource(crashlytics),
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

    expect(
      (result as Failure<ManholeCard>).exception,
      isA<NotFoundException>(),
    );
    expect(recordedErrors(crashlytics).single.error, isA<NotFoundException>());
  });

  group('差分', () {
    test('差分のあるカードだけ、最新の値を重ねて返す', () async {
      await store.writeAll([localCard(id: 'A'), localCard(id: 'B')]);
      await updates.writeAll([localCardUpdate(id: 'B')]);

      final result = await repository.fetchAll();

      final cards = (result as Success<List<ManholeCard>>).value;
      expect(cards[0], card(id: 'A'));
      expect(cards[1].distributionState, DistributionState.distributing);
      expect(cards[1].distributionPlaceHtml, '<p>藤井寺市立図書館</p>');
      expect(cards[1].distributionPoints, const [
        Coordinate(latitude: 34.58, longitude: 135.61),
      ]);
      expect(cards[1].name, card(id: 'B').name);
    });

    test('1 枚だけ読むときも重ねる', () async {
      await store.writeAll([localCard(id: 'A')]);
      await updates.writeAll([localCardUpdate(id: 'A')]);

      final result = await repository.get(id: 'A');

      expect(
        (result as Success<ManholeCard>).value.distributionState,
        DistributionState.distributing,
      );
    });

    test('master にないカードの差分は無視する', () async {
      await store.writeAll([localCard(id: 'A')]);
      await updates.writeAll([localCardUpdate(id: 'Z')]);

      final result = await repository.fetchAll();

      expect((result as Success<List<ManholeCard>>).value, [card(id: 'A')]);
    });

    test('差分が壊れていても、記録してカードは master のまま返す', () async {
      await store.writeAll([localCard(id: 'A')]);
      File('${directory.path}/card_updates.json').writeAsStringSync('[{');

      final result = await repository.fetchAll();

      expect((result as Success<List<ManholeCard>>).value, [card(id: 'A')]);
      expect(recordedErrors(crashlytics).single.error, isA<FormatException>());
    });
  });

  test('マスターデータを取り込む前は、全件の読み取りも失敗にする', () async {
    final result = await repository.fetchAll();

    expect(
      (result as Failure<List<ManholeCard>>).exception,
      isA<NotFoundException>(),
    );
  });

  group('fetchImage', () {
    const url = 'https://r2/A.jpg';
    const subUrl = 'https://sub/A.jpg';

    /// [url] のカードを 1 枚だけ端末に持たせる。
    Future<void> storeCard() {
      return store.writeAll([localCard(id: 'A', image: url, imageSub: subUrl)]);
    }

    void stubCache(String target, List<int>? bytes) {
      when(() => cardImage.readCache(target)).thenAnswer(
        (_) async => bytes == null ? null : Uint8List.fromList(bytes),
      );
    }

    void stubDownload(String target, Future<Uint8List> Function() response) {
      when(() => cardImage.download(target)).thenAnswer((_) => response());
    }

    setUp(() {
      stubCache(url, null);
      stubCache(subUrl, null);
    });

    test('端末に保存済みならそれを返し、取りにいかない', () async {
      await storeCard();
      stubCache(url, [1, 2, 3]);

      final result = await repository.fetchImage(cardId: 'A');

      expect((result as Success<List<int>>).value, [1, 2, 3]);
      verifyNever(() => cardImage.download(any()));
    });

    test('主系が保存されていなくても、代わりの配信元のものがあれば使う', () async {
      await storeCard();
      stubCache(subUrl, [4, 5]);

      final result = await repository.fetchImage(cardId: 'A');

      expect((result as Success<List<int>>).value, [4, 5]);
      verifyNever(() => cardImage.download(any()));
    });

    test('保存されていなければ、主系から取って返す', () async {
      await storeCard();
      stubDownload(url, () async => Uint8List.fromList([6]));

      final result = await repository.fetchImage(cardId: 'A');

      expect((result as Success<List<int>>).value, [6]);
      verifyNever(() => cardImage.download(subUrl));
      verifyNever(() => analytics.send(any()));
    });

    test('主系で取れなければ代わりの配信元から取り、主系の失敗を計測する', () async {
      await storeCard();
      stubDownload(url, () async => throw const SocketException('だめ'));
      stubDownload(subUrl, () async => Uint8List.fromList([7]));

      final result = await repository.fetchImage(cardId: 'A');

      expect((result as Success<List<int>>).value, [7]);
      final sent = verify(
        () => analytics.send(captureAny()),
      ).captured.cast<AnalyticsEventModel>();
      expect(sent.single.name, 'image_load_failed');
      expect(sent.single.parameters['host'], 'r2');
      expect(sent.single.parameters['runtime_type'], 'SocketException');
    });

    test('どちらでも取れなければ、両方を計測して失敗を返す。記録はしない', () async {
      await storeCard();
      stubDownload(url, () async => throw const SocketException('だめ'));
      stubDownload(
        subUrl,
        () async => throw const HandshakeException('WRONG_VERSION_NUMBER'),
      );

      final result = await repository.fetchImage(cardId: 'A');

      expect((result as Failure).exception, isA<OfflineException>());
      final sent = verify(
        () => analytics.send(captureAny()),
      ).captured.cast<AnalyticsEventModel>();
      expect(sent.map((event) => event.parameters['host']), ['r2', 'sub']);
      expect(sent.map((event) => event.parameters['runtime_type']), [
        'SocketException',
        'HandshakeException',
      ]);
      // 遮断された端末で大量に出て、非重大の枠をほかの失敗から奪うため。
      verifyNotRecorded(crashlytics);
    });

    test('ない ID は、データがない失敗として返す', () async {
      await storeCard();

      final result = await repository.fetchImage(cardId: 'Z');

      expect((result as Failure).exception, isA<NotFoundException>());
      verifyNever(() => cardImage.readCache(any()));
    });
  });
}
