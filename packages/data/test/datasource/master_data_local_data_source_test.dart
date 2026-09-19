import 'dart:io';

import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('master_data_store');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  MasterDataLocalDataSource store() => MasterDataLocalDataSource(directory: () async => directory);

  List<String> fileNames() {
    return directory
        .listSync()
        .map((entity) => entity.uri.pathSegments.last)
        .toList()
      ..sort();
  }

  test('まだ取り込んでいなければ、ないと答える', () async {
    expect(await store().readAll(), isNull);
    expect(await store().exists(), isFalse);
  });

  test('書いたカード一式は、次に起動したときにも読める', () async {
    final cards = [card(), card(id: '00-101-A001')];

    await store().writeAll(cards);

    final next = store();
    expect(await next.exists(), isTrue);
    expect(await next.readAll(), cards);
    expect(fileNames(), ['master_data_v1.json']);
  });

  test('入れ替えると、前のカードは残らない', () async {
    final target = store();
    await target.writeAll([card(id: 'A')]);

    await target.writeAll([card(id: 'B')]);

    expect((await store().readAll())!.map((card) => card.id), ['B']);
  });

  test('古い形のファイルと書きかけのファイルは消す', () async {
    File('${directory.path}/master_data_v0.json').writeAsStringSync('[]');
    File('${directory.path}/master_data_v1.json.tmp').writeAsStringSync('[');
    File('${directory.path}/other.json').writeAsStringSync('{}');

    expect(await store().exists(), isFalse);
    expect(fileNames(), ['other.json']);
  });

  test('壊れたファイルは消し、次の確認では取り込んでいない扱いになる', () async {
    File('${directory.path}/master_data_v1.json').writeAsStringSync('[{');

    await expectLater(
      store().readAll(),
      throwsA(isA<CorruptedDataException>()),
    );
    expect(await store().exists(), isFalse);
  });

  test('起動して最初に使うときに、後片付けを 1 回だけ行う', () async {
    var cleanUpCount = 0;
    final target = MasterDataLocalDataSource(
      directory: () async => directory,
      cleanUp: () async => cleanUpCount++,
    );

    await target.exists();
    await target.writeAll([card()]);
    await target.readAll();

    expect(cleanUpCount, 1);
  });
}
