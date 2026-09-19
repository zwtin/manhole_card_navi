import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/src/widget/card_image_provider.dart';
import 'package:domain/domain.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCardUseCase extends Mock implements CardUseCase {}

/// 1x1 の PNG。
final _pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

void main() {
  late MockCardUseCase useCase;

  setUp(() {
    useCase = MockCardUseCase();
    PaintingBinding.instance.imageCache.clear();
  });

  void stubFetch(Result<Uint8List> result) {
    when(
      () => useCase.fetchImage(
        cardId: any(named: 'cardId'),
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
      CardImageProvider(useCase: useCase, cardId: 'A', maxWidth: 520),
    );

    expect((loaded! as ImageInfo).image.width, 1);
    verify(
      () => useCase.fetchImage(cardId: 'A', maxWidth: 520),
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
      CardImageProvider(useCase: useCase, cardId: 'B'),
    );

    expect(loaded, same(cause));
  });

  test('カードと保存する幅が同じなら、同じ画像として扱う', () {
    final a = CardImageProvider(useCase: useCase, cardId: 'A');
    final b = CardImageProvider(useCase: MockCardUseCase(), cardId: 'A');

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(CardImageProvider(useCase: useCase, cardId: 'B')));
    expect(
      a,
      isNot(CardImageProvider(useCase: useCase, cardId: 'A', maxWidth: 520)),
    );
  });
}
