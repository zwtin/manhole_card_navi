import 'dart:async';
import 'dart:ui' as ui;

import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// カード画像を [CardImageUseCase] から受け取って表示する [ImageProvider]。
///
/// 画像の取得（端末への保存・配信元の切り替え・失敗の計測）は data が受け持ち、
/// ここは受け取ったデータをデコードするだけにする。デコードした画像は Flutter の
/// ImageCache に [url] と [maxWidth] の組で保存されるので、同じ画像を出す画面
/// どうし（詳細のサムネイルと画像拡大など）で共有される。
///
/// 表示するときの縮小は [ResizeImage] で包んで行う。
@immutable
class CardImageProvider extends ImageProvider<CardImageProvider> {
  const CardImageProvider({
    required this.useCase,
    required this.url,
    required this.subUrl,
    this.maxWidth,
  });

  final CardImageUseCase useCase;

  /// 画像の URL（主系の配信元）。
  final String url;

  /// 代わりの配信元の URL。代わりがなければ空文字。
  final String subUrl;

  /// 端末に縮小して保存する幅。null なら原寸のまま扱う。
  final int? maxWidth;

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
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<CardImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadCodec(
    CardImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    switch (await key.useCase.fetch(
      url: key.url,
      subUrl: key.subUrl,
      maxWidth: key.maxWidth,
    )) {
      case Failure(:final exception):
        // 失敗した画像を ImageCache に残すと、画面を開き直しても取り直さない。
        scheduleMicrotask(() {
          PaintingBinding.instance.imageCache.evict(key);
        });
        // 読み込めなかった画像は Flutter の画像の仕組みを通して FlutterError に
        // 報告され、Crashlytics の非重大に残る。画像が出ない問い合わせの調査で
        // 元の例外（WRONG_VERSION_NUMBER など）を見るため、変換前の例外を投げる。
        Error.throwWithStackTrace(
          exception.cause ?? exception,
          exception.stackTrace ?? StackTrace.current,
        );
      case Success(:final value):
        return decode(await ui.ImmutableBuffer.fromUint8List(value));
    }
  }

  @override
  bool operator ==(Object other) {
    return other is CardImageProvider &&
        other.url == url &&
        other.maxWidth == maxWidth;
  }

  @override
  int get hashCode => Object.hash(url, maxWidth);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CardImageProvider')}("$url", maxWidth: $maxWidth)';
}
