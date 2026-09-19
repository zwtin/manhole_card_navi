import 'dart:io';

import 'package:data/src/repository/card_repository_impl.dart';
import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../datasource/crashlytics_mock.dart';
import '../fixtures.dart';

void main() {
  late Directory directory;
  late MasterDataLocalDataSource store;
  late MockFirebaseCrashlytics crashlytics;
  late CardRepositoryImpl repository;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('card_repository');
    store = MasterDataLocalDataSource(directory: () async => directory);
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
}
