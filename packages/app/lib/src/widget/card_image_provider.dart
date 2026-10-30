import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:domain/domain.dart';

final cardImageProvider = Provider.autoDispose
    .family<CardImageProvider, String>(
      (ref, cardId) => CardImageProvider(
        useCase: ref.watch(cardUseCaseProvider),
        cardId: cardId,
      ),
    );

/// デコードした画像は Flutter の ImageCache に [cardId] で保存されるので、同じ
/// 画像を出す画面どうし（詳細のサムネイルと画像拡大など）で共有される。
///
/// 表示するときの縮小は [ResizeImage] で包んで行う。
@immutable
class CardImageProvider extends ImageProvider<CardImageProvider> {
  const CardImageProvider({required this.useCase, required this.cardId});

  final CardUseCase useCase;

  final String cardId;

  @override
  Future<CardImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CardImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    CardImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadCodec(key, decode),
      scale: 1.0,
      debugLabel: key.cardId,
      informationCollector:
          () => <DiagnosticsNode>[
            DiagnosticsProperty<ImageProvider>('Image provider', this),
            DiagnosticsProperty<CardImageProvider>('Image key', key),
          ],
    );
  }

  Future<ui.Codec> _loadCodec(
    CardImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    switch (await key.useCase.fetchImage(cardId: key.cardId)) {
      case Failure(:final exception):
        // 失敗した画像を ImageCache に残すと、画面を開き直しても取り直さない。
        scheduleMicrotask(() {
          PaintingBinding.instance.imageCache.evict(key);
        });
        // Flutter の画像の仕組みに失敗を伝えて errorBuilder を動かす。取得の
        // 失敗は data が記録済みなので、FlutterError では記録しない。
        throw exception;
      case Success(:final value):
        return decode(await ui.ImmutableBuffer.fromUint8List(value));
    }
  }

  @override
  bool operator ==(Object other) {
    return other is CardImageProvider && other.cardId == cardId;
  }

  @override
  int get hashCode => cardId.hashCode;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CardImageProvider')}("$cardId")';
}
