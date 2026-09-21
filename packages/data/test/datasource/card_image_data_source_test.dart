import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/card_image_data_source.dart';

class MockCacheManager extends Mock implements BaseCacheManager {}

const _url = 'https://r2.example.com/A.jpg';

void main() {
  late MockCacheManager cache;
  late CardImageDataSource dataSource;

  setUp(() {
    cache = MockCacheManager();
    dataSource = CardImageDataSource(cache);
  });

  Future<FileInfo> fileInfo(List<int> bytes) async {
    final file = await MemoryCacheSystem().createFile('A.jpg');
    await file.writeAsBytes(bytes);
    return FileInfo(file, FileSource.Cache, DateTime(2026), _url);
  }

  group('readCache', () {
    test('保存済みならそのデータを返す', () async {
      when(() => cache.getFileFromCache(_url))
          .thenAnswer((_) async => fileInfo([1, 2, 3]));

      expect(await dataSource.readCache(_url), [1, 2, 3]);
    });

    test('保存されていなければ null', () async {
      when(() => cache.getFileFromCache(_url)).thenAnswer((_) async => null);

      expect(await dataSource.readCache(_url), isNull);
    });
  });

  group('download', () {
    test('取って保存したデータを返す', () async {
      when(() => cache.downloadFile(_url))
          .thenAnswer((_) async => fileInfo([4, 5]));

      expect(await dataSource.download(_url), [4, 5]);
    });

    test('取れなければ、そのまま例外を投げる', () async {
      when(() => cache.downloadFile(_url))
          .thenThrow(const SocketException('だめ'));

      expect(dataSource.download(_url), throwsA(isA<SocketException>()));
    });
  });
}
