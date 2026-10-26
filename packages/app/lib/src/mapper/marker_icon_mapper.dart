import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:app/src/widget/card_image.dart';
import 'package:domain/domain.dart';

/// カード画像を、地図マーカーのアイコン（吹き出し枠との合成結果）にする。
abstract final class MarkerIconMapper {
  /// マーカーアイコンの出力サイズ（論理ピクセル基準の実ピクセル）。
  /// 枠 PNG のアスペクト比 200:300 に合わせる。
  static const int _iconWidth = 200;
  static const int _iconHeight = 300;

  /// 枠内で原本画像を描画する領域（吹き出しの角丸矩形部分）。
  /// 下部のピン部分には重ねない。値は _iconWidth/_iconHeight に対する割合。
  static const double _imageInsetRatio = 0.05;
  static const double _imageBottomRatio = 0.10;

  static String _framePath(DistributionState distributionState) {
    switch (distributionState) {
      case DistributionState.distributing:
        return 'packages/app/assets/images/markers/frame_green.png';
      case DistributionState.stopped:
        return 'packages/app/assets/images/markers/frame_red.png';
      case DistributionState.notClear:
        return 'packages/app/assets/images/markers/frame_yellow.png';
    }
  }

  static final Map<String, ui.Image> _frameCache = <String, ui.Image>{};

  /// 枠 PNG（3 色）を事前にデコードしてキャッシュしておく。地図表示前に
  /// 呼んでおくと、最初のマーカー合成時のアセット読み込み待ちを避けられる。
  static Future<void> preloadFrames() async {
    await Future.wait(
      DistributionState.values.map(_framePath).map(_loadFramePath),
    );
  }

  static Future<ui.Image> _loadFrame(DistributionState distributionState) {
    return _loadFramePath(_framePath(distributionState));
  }

  static Future<ui.Image> _loadFramePath(String path) async {
    final cached = _frameCache[path];
    if (cached != null) {
      return cached;
    }
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: _iconWidth,
      targetHeight: _iconHeight,
    );
    final frame = await codec.getNextFrame();
    _frameCache[path] = frame.image;
    return frame.image;
  }

  static Future<ui.Image> _decodeOriginal(Uint8List bytes) async {
    final targetWidth = (_iconWidth * (1 - _imageInsetRatio * 2)).round();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth,
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// [alreadyGet] が false なら、グレーで描く。
  static Future<Uint8List> toIcon({
    required Uint8List originalBytes,
    required DistributionState distributionState,
    required bool alreadyGet,
  }) async {
    final frame = await _loadFrame(distributionState);
    final original = await _decodeOriginal(originalBytes);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    canvas.drawImageRect(
      frame,
      Rect.fromLTWH(0, 0, frame.width.toDouble(), frame.height.toDouble()),
      Rect.fromLTWH(0, 0, _iconWidth.toDouble(), _iconHeight.toDouble()),
      Paint(),
    );

    final destLeft = _iconWidth * _imageInsetRatio;
    final destTop = _iconWidth * _imageInsetRatio;
    final destWidth = _iconWidth * (1 - _imageInsetRatio * 2);
    final destHeight =
        _iconHeight * (1 - _imageInsetRatio - _imageBottomRatio) - destTop;
    final dest = Rect.fromLTWH(destLeft, destTop, destWidth, destHeight);

    final imagePaint = Paint();
    if (!alreadyGet) {
      imagePaint.colorFilter = const ColorFilter.matrix(
        CardImage.grayscaleMatrix,
      );
    }
    canvas.drawImageRect(
      original,
      Rect.fromLTWH(
        0,
        0,
        original.width.toDouble(),
        original.height.toDouble(),
      ),
      dest,
      imagePaint,
    );

    final picture = recorder.endRecording();
    final composed = await picture.toImage(_iconWidth, _iconHeight);
    final byteData = await composed.toByteData(format: ui.ImageByteFormat.png);

    picture.dispose();
    composed.dispose();

    return byteData!.buffer.asUint8List();
  }
}
