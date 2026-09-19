import 'dart:io';

import 'package:data/src/repository/card_repository_impl.dart';
import 'package:data/src/service/failure_recorder.dart';
import 'package:data/src/storage/master_data_store.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures.dart';
import '../service/crashlytics_mock.dart';

void main() {
  late Directory directory;
  late MasterDataStore store;
  late MockFirebaseCrashlytics crashlytics;
  late CardRepositoryImpl repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('card_repository');
    store = MasterDataStore(directory: () async => directory);
    crashlytics = MockFirebaseCrashlytics();
    stubRecordError(crashlytics);
    repository = CardRepositoryImpl(
      store,
      FailureRecorder(crashlytics: crashlytics),
    );
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('ID でカードを読む', () async {
    await store.writeAll([card(id: 'A'), card(id: 'B')]);

    final result = await repository.get(id: 'B');

    expect((result as Success<ManholeCard>).value.id, 'B');
  });

  test('ない ID は、データがない失敗として返し、記録する', () async {
    await store.writeAll([card(id: 'A')]);

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
}
