import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/model/local_master_data_model.dart';

import '../fixtures.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('master_data_store');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  MasterDataLocalDataSource store() =>
      MasterDataLocalDataSource(directory: () async => directory);

  LocalMasterDataModel master(String version, List<String> cardIds) {
    return LocalMasterDataModel(
      version: version,
      cards: [for (final id in cardIds) localCard(id: id)],
    );
  }

  Map<String, dynamic>? toJson(LocalMasterDataModel? master) =>
      master?.toJson();

  List<String> fileNames() {
    return directory
        .listSync()
        .map((entity) => entity.uri.pathSegments.last)
        .toList()
      ..sort();
  }

  File file() => File('${directory.path}/master_data.json');

  test('まだ取り込んでいなければ null', () async {
    expect(await store().read(), isNull);
  });

  test('書いたバージョンとカードは、次に起動したときにも一緒に読める', () async {
    final written = master('0006', ['A', 'B']);

    await store().write(written);

    final read = await store().read();
    expect(read!.version, '0006');
    expect(toJson(read), toJson(written));
    expect(fileNames(), ['master_data.json']);
  });

  test('同時に読んでも、読み込みと変換は 1 回で済ませる', () async {
    await store().write(master('0006', ['A']));
    final target = store();

    final results = await Future.wait([target.read(), target.read()]);

    expect(identical(results[0], results[1]), isTrue);
  });

  test('入れ替えると、前のバージョンとカードは残らない', () async {
    final target = store();
    await target.write(master('0005', ['A']));

    await target.write(master('0006', ['B']));

    expect((await target.read())!.version, '0006');
    final next = (await store().read())!;
    expect(next.version, '0006');
    expect(next.cards.map((card) => card.id), ['B']);
  });

  group('残ったファイル', () {
    test('1.5.0 までのファイル（master_data_v1.json）は読まずに消し、取り込んでいない扱いにする', () async {
      File(
        '${directory.path}/master_data_v1.json',
      ).writeAsStringSync(jsonEncode([localCard().toJson()]));

      expect(await store().read(), isNull);
      expect(fileNames(), isEmpty);
    });

    test('書きかけのファイルは消す', () async {
      File('${directory.path}/master_data.json.tmp').writeAsStringSync('{');
      File('${directory.path}/master_data_v1.json.tmp').writeAsStringSync('[');
      File('${directory.path}/other.json').writeAsStringSync('{}');

      expect(await store().read(), isNull);
      expect(fileNames(), ['other.json']);
    });
  });

  group('書き込みの失敗', () {
    test('一時ファイルを書けなければ、前のファイルとキャッシュを残す', () async {
      final target = store();
      await target.write(master('0005', ['A']));
      // 一時ファイルの場所にディレクトリがあると書けない。
      Directory('${file().path}.tmp').createSync();

      await expectLater(
        target.write(master('0006', ['B'])),
        throwsA(isA<FileSystemException>()),
      );

      expect((await target.read())!.version, '0005');
      expect((await store().read())!.version, '0005');
    });

    test('置き換えられなければ、前のキャッシュを残し、やり直せば入れ替わる', () async {
      final target = store();
      // 本体の場所に空でないディレクトリがあると、一時ファイルで置き換えられない。
      Directory('${file().path}/blocker').createSync(recursive: true);

      await expectLater(
        target.write(master('0006', ['B'])),
        throwsA(isA<FileSystemException>()),
      );
      expect(await target.read(), isNull);

      Directory(file().path).deleteSync(recursive: true);
      await target.write(master('0006', ['B']));

      expect((await store().read())!.version, '0006');
    });
  });

  group('同時の読み書き', () {
    test('読んでいる間に書き込みが終わっても、古い内容でキャッシュを戻さない', () async {
      // 読み込みのほうが書き込みより遅く終わるよう、前のものを大きくする。
      await store().write(
        master('0005', [for (var i = 0; i < 5000; i++) 'A$i']),
      );
      final target = store();

      final reading = target.read();
      final writing = target.write(master('0006', ['B']));
      await Future.wait([reading, writing]);

      expect((await target.read())!.version, '0006');
    });

    test('同時に書いても、一時ファイルを取り合わず、後に書いたものが残る', () async {
      final target = store();

      await Future.wait([
        target.write(master('0005', ['A'])),
        target.write(master('0006', ['B'])),
        target.write(master('0007', ['C'])),
      ]);

      expect((await target.read())!.version, '0007');
      final next = (await store().read())!;
      expect(next.version, '0007');
      expect(next.cards.map((card) => card.id), ['C']);
      expect(fileNames(), ['master_data.json']);
    });
  });

  group('壊れたファイル', () {
    Map<String, dynamic> valid() => master('0006', ['A']).toJson();

    final cases = <String, Object? Function(Map<String, dynamic> json)>{
      'JSON として読めない': (_) => '{',
      'オブジェクトでない': (json) => [json],
      'バージョンがない': (json) => json..remove('version'),
      'バージョンが文字列でない': (json) => json..['version'] = 6,
      'バージョンが空': (json) => json..['version'] = '',
      'カードが 0 件': (json) => json..['cards'] = <Object>[],
      '座標が範囲外': (json) {
        final card = (json['cards'] as List<dynamic>).first as Map;
        card['position'] = {'latitude': 91.0, 'longitude': 135.0};
        return json;
      },
    };

    for (final MapEntry(key: name, value: corrupt) in cases.entries) {
      test('$name なら投げてファイルを消し、次は取り込んでいない扱いになる', () async {
        final content = corrupt(valid());
        file().writeAsStringSync(
          content is String ? content : jsonEncode(content),
        );

        await expectLater(
          store().read(),
          throwsA(
            anyOf(isA<FormatException>(), isA<CheckedFromJsonException>()),
          ),
        );
        expect(file().existsSync(), isFalse);
        expect(await store().read(), isNull);
      });
    }
  });
}
