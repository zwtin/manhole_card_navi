import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/datasource/card_updates_local_data_source.dart';

import '../fixtures.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('card_updates_store');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  CardUpdatesLocalDataSource store() =>
      CardUpdatesLocalDataSource(directory: () async => directory);

  File file() => File('${directory.path}/card_updates.json');

  test('まだ差分がなければ空', () async {
    expect(await store().readAll(), isEmpty);
  });

  test('書いた差分は、次に起動したときにも読める', () async {
    await store().writeAll([
      localCardUpdate(id: 'A'),
      localCardUpdate(id: 'B'),
    ]);

    final updates = await store().readAll();

    expect(updates.keys, ['A', 'B']);
    expect(updates['A']!.toJson(), localCardUpdate(id: 'A').toJson());
  });

  test('入れ替えると、前の差分は残らない', () async {
    final target = store();
    await target.writeAll([localCardUpdate(id: 'A')]);

    await target.writeAll([localCardUpdate(id: 'B')]);

    expect((await target.readAll()).keys, ['B']);
    expect((await store().readAll()).keys, ['B']);
  });

  test('消すと、メモリからもファイルからもなくなる', () async {
    final target = store();
    await target.writeAll([localCardUpdate(id: 'A')]);

    await target.delete();

    expect(await target.readAll(), isEmpty);
    expect(file().existsSync(), isFalse);
  });

  test('ファイルがなくても消せる', () async {
    await expectLater(store().delete(), completes);
  });

  test('壊れたファイルは消し、次は差分がない扱いになる', () async {
    file().writeAsStringSync('[{');

    await expectLater(store().readAll(), throwsA(isA<FormatException>()));
    expect(file().existsSync(), isFalse);
    expect(await store().readAll(), isEmpty);
  });

  test('形の違うファイルも消す', () async {
    file().writeAsStringSync('[{"id": "A"}]');

    await expectLater(
      store().readAll(),
      throwsA(isA<CheckedFromJsonException>()),
    );
    expect(file().existsSync(), isFalse);
  });
}
