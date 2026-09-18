import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/src/widget/card_image_provider.dart';
import 'package:domain/domain.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCardImageUseCase extends Mock implements CardImageUseCase {}

/// 1x1 の PNG。
final _pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

void main() {
  late MockCardImageUseCase useCase;

  setUp(() {
    useCase = MockCardImageUseCase();
    PaintingBinding.instance.imageCache.clear();
  });

  void stubFetch(Result<Uint8List> result) {
    when(
      () => useCase.fetch(
        url: any(named: 'url'),
        subUrl: any(named: 'subUrl'),
        maxWidth: any(named: 'maxWidth'),
      ),
    ).thenAnswer((_) async => result);
  }

  /// [provider] を読み込み、画像か、報告された例外を返す。
  Future<Object?> load(WidgetTester tester, CardImageProvider provider) {
    return tester.runAsync(() {
      final completer = Completer<Object>();
      provider.resolve(ImageConfiguration.empty).addListener(
            ImageStreamListener(
              (info, _) => completer.complete(info),
              onError: (error, _) => completer.complete(error),
            ),
          );
      return completer.future;
    });
  }

  testWidgets('受け取った画像データをデコードする', (tester) async {
    stubFetch(Result.success(_pngBytes));

    final loaded = await load(
      tester,
      CardImageProvider(
        useCase: useCase,
        url: 'https://example.com/a.jpg',
        subUrl: 'https://example.web.app/a.jpg',
        maxWidth: 520,
      ),
    );

    expect((loaded! as ImageInfo).image.width, 1);
    verify(
      () => useCase.fetch(
        url: 'https://example.com/a.jpg',
        subUrl: 'https://example.web.app/a.jpg',
        maxWidth: 520,
      ),
    ).called(1);
  });

  testWidgets('取れなかったときは、変換前の例外を報告する', (tester) async {
    const cause = HandshakeException('WRONG_VERSION_NUMBER(tls_record.cc:127)');
    stubFetch(
      Result.failure(
        OfflineException(cause: cause, stackTrace: StackTrace.current),
      ),
    );

    final loaded = await load(
      tester,
      CardImageProvider(
        useCase: useCase,
        url: 'https://example.com/b.jpg',
        subUrl: '',
      ),
    );

    expect(loaded, same(cause));
  });

  test('URL と保存する幅が同じなら、同じ画像として扱う', () {
    final a = CardImageProvider(useCase: useCase, url: 'u', subUrl: 's');
    final b = CardImageProvider(useCase: useCase, url: 'u', subUrl: '');

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(
      a,
      isNot(CardImageProvider(useCase: useCase, url: 'u', subUrl: 's', maxWidth: 520)),
    );
  });
}
