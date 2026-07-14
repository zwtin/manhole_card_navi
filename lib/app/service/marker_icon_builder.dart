import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '/app/widget/card_image.dart';

/// 地図マーカーのアイコン画像（吹き出し枠 + 原本画像の合成結果）を生成する。
///
/// 原本画像（カラー）を実行時に縮小し、頒布状況に応じた枠 PNG（吹き出し型）へ
/// 重ねてラスタライズする。未所持カードは彩度 0 のグレースケールで描画する。
///
/// 枠 PNG は `assets/images/markers/` に配置された 200x300 の吹き出し画像。
/// 一度読み込んだ枠 PNG とデコード済みの合成結果はメモリにキャッシュする。
class MarkerIconBuilder {
  MarkerIconBuilder._();

  /// マーカーアイコンの出力サイズ（論理ピクセル基準の実ピクセル）。
  /// 枠 PNG のアスペクト比 200:300 に合わせる。
  static const int _iconWidth = 200;
  static const int _iconHeight = 300;

  /// 枠内で原本画像を描画する領域（吹き出しの角丸矩形部分）。
  /// 下部のピン部分には重ねない。値は _iconWidth/_iconHeight に対する割合。
  static const double _imageInsetRatio = 0.05;
  static const double _imageBottomRatio = 0.10;

  /// 枠と画像のレイアウト（サイズ・余白）を変えたら手動で上げるバージョン番号。
  /// 上げると旧レイアウトで合成したキャッシュとは別エントリになり、
  /// 再インストールなしで新しいレイアウトが反映される。
  static const int _layoutVersion = 1;

  /// アイコンのサイズ・レイアウトを表すキャッシュ識別子。これが変わると
  /// 旧レイアウトで合成した古いキャッシュとは別エントリになる。
  static String get sizeKey => '${_iconWidth}x${_iconHeight}_v$_layoutVersion';

  /// 頒布状況 → 枠 PNG アセットパス。
  static const Map<String, String> _framePathByState = <String, String>{
    'distributing': 'assets/images/markers/frame_green.png',
    'stopped': 'assets/images/markers/frame_red.png',
    'notClear': 'assets/images/markers/frame_yellow.png',
  };
  static const String _defaultFramePath =
      'assets/images/markers/frame_yellow.png';

  /// デコード済みの枠 PNG（アセットパス → ui.Image）のキャッシュ。
  static final Map<String, ui.Image> _frameCache = <String, ui.Image>{};

  /// 枠 PNG（3 色）を事前にデコードしてキャッシュしておく。地図表示前に
  /// 呼んでおくと、最初のマーカー合成時のアセット読み込み待ちを避けられる。
  static Future<void> preloadFrames() async {
    final paths = <String>{..._framePathByState.values, _defaultFramePath};
    await Future.wait(paths.map(_loadFramePath));
  }

  /// 頒布状況に対応する枠 PNG アセットを読み込み、デコードして返す。
  static Future<ui.Image> _loadFrame(String distributionState) {
    final path = _framePathByState[distributionState] ?? _defaultFramePath;
    return _loadFramePath(path);
  }

  /// アセットパスから枠 PNG を読み込み、デコードして返す（結果をキャッシュ）。
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

  /// 原本画像のバイト列を、原本領域の幅に合わせてデコードする。
  static Future<ui.Image> _decodeOriginal(Uint8List bytes) async {
    final targetWidth = (_iconWidth * (1 - _imageInsetRatio * 2)).round();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth,
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// 枠画像の上に原本画像を重ねて合成し、PNG バイト列を返す。
  ///
  /// [originalBytes] は原本画像のエンコード済みバイト列。
  /// [distributionState] は 'distributing'/'stopped'/'notClear'。
  /// [alreadyGet] が false の場合はグレースケールで描画する。
  static Future<Uint8List> build({
    required Uint8List originalBytes,
    required String distributionState,
    required bool alreadyGet,
  }) async {
    final frame = await _loadFrame(distributionState);
    final original = await _decodeOriginal(originalBytes);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    // 枠（吹き出し）を全面に描画。
    canvas.drawImageRect(
      frame,
      Rect.fromLTWH(0, 0, frame.width.toDouble(), frame.height.toDouble()),
      Rect.fromLTWH(0, 0, _iconWidth.toDouble(), _iconHeight.toDouble()),
      Paint(),
    );

    // 原本画像を吹き出しの角丸矩形部分へ収めて描画。
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
