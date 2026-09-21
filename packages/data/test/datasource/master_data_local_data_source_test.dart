import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/model/local_card_model.dart';

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

  List<Map<String, dynamic>> toJson(List<LocalCardModel>? cards) {
    return [for (final card in cards!) card.toJson()];
  }

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
    final cards = [localCard(), localCard(id: '00-101-A001')];

    await store().writeAll(cards);

    final next = store();
    expect(await next.exists(), isTrue);
    expect(toJson(await next.readAll()), toJson(cards));
    expect(fileNames(), ['master_data_v1.json']);
  });

  test('同時に読んでも、読み込みと変換は 1 回で済ませる', () async {
    await store().writeAll([localCard()]);
    final target = store();

    final results = await Future.wait([target.readAll(), target.readAll()]);

    expect(identical(results[0], results[1]), isTrue);
  });

  test('入れ替えると、前のカードは残らない', () async {
    final target = store();
    await target.writeAll([localCard(id: 'A')]);

    await target.writeAll([localCard(id: 'B')]);

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
      throwsA(isA<FormatException>()),
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
    await target.writeAll([localCard()]);
    await target.readAll();

    expect(cleanUpCount, 1);
  });
}
