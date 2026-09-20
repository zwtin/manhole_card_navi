import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:data/src/datasource/card_image_cache_manager.dart';
import 'package:data/src/datasource/card_image_data_source.dart';
import 'package:data/src/datasource/image_fallback.dart';

class MockCardImageCacheManager extends Mock
    implements CardImageCacheManager {}

void main() {
  late MockCardImageCacheManager cacheManager;
  late CardImageDataSource dataSource;

  setUp(() {
    cacheManager = MockCardImageCacheManager();
    dataSource = CardImageDataSource(cacheManager);
  });

  Future<FileInfo> fileInfo(List<int> bytes) async {
    final file = await MemoryCacheSystem().createFile('A.jpg');
    await file.writeAsBytes(bytes);
    return FileInfo(file, FileSource.Cache, DateTime(2026), 'https://r2/A.jpg');
  }

  void stubImage(Stream<FileResponse> Function() response) {
    when(
      () => cacheManager.getImageFile(
        any(),
        headers: any(named: 'headers'),
        maxWidth: any(named: 'maxWidth'),
      ),
    ).thenAnswer((_) => response());
  }

  test('代わりの配信元と縮小する幅を渡して取り、データを返す', () async {
    stubImage(() => Stream.fromFuture(fileInfo([1, 2, 3])));

    final bytes = await dataSource.fetch(
      url: 'https://r2/A.jpg',
      subUrl: 'https://sub/A.jpg',
      maxWidth: 520,
    );

    expect(bytes, [1, 2, 3]);
    verify(
      () => cacheManager.getImageFile(
        'https://r2/A.jpg',
        headers: ImageFallback.headers('https://sub/A.jpg'),
        maxWidth: 520,
      ),
    ).called(1);
  });

  test('取得の進み具合は読み飛ばし、最初のファイルを使う', () async {
    stubImage(
      () async* {
        yield DownloadProgress('https://r2/A.jpg', 100, 10);
        yield await fileInfo([4, 5]);
      },
    );

    expect(
      await dataSource.fetch(url: 'https://r2/A.jpg', subUrl: 'https://sub'),
      [4, 5],
    );
  });

  test('取れなければ、そのまま例外を投げる', () async {
    stubImage(() => Stream.error(const HttpException('だめ')));

    expect(
      dataSource.fetch(url: 'https://r2/A.jpg', subUrl: 'https://sub'),
      throwsA(isA<HttpException>()),
    );
  });
}
