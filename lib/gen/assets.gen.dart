/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/frame_gray.png
  AssetGenImage get frameGray =>
      const AssetGenImage('assets/images/frame_gray.png');

  /// File path: assets/images/frame_green.png
  AssetGenImage get frameGreen =>
      const AssetGenImage('assets/images/frame_green.png');

  /// File path: assets/images/frame_red.png
  AssetGenImage get frameRed =>
      const AssetGenImage('assets/images/frame_red.png');

  /// File path: assets/images/frame_yellow.png
  AssetGenImage get frameYellow =>
      const AssetGenImage('assets/images/frame_yellow.png');

  /// File path: assets/images/icon_development.png
  AssetGenImage get iconDevelopment =>
      const AssetGenImage('assets/images/icon_development.png');

  /// File path: assets/images/icon_production.png
  AssetGenImage get iconProduction =>
      const AssetGenImage('assets/images/icon_production.png');

  /// File path: assets/images/terms.jpg
  AssetGenImage get terms => const AssetGenImage('assets/images/terms.jpg');

  /// File path: assets/images/tutorial_1.jpg
  AssetGenImage get tutorial1 =>
      const AssetGenImage('assets/images/tutorial_1.jpg');

  /// File path: assets/images/tutorial_2.png
  AssetGenImage get tutorial2 =>
      const AssetGenImage('assets/images/tutorial_2.png');

  /// File path: assets/images/tutorial_3.png
  AssetGenImage get tutorial3 =>
      const AssetGenImage('assets/images/tutorial_3.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        frameGray,
        frameGreen,
        frameRed,
        frameYellow,
        iconDevelopment,
        iconProduction,
        terms,
        tutorial1,
        tutorial2,
        tutorial3
      ];
}

class $AssetsLottiesGen {
  const $AssetsLottiesGen();

  /// File path: assets/lotties/party.json
  String get party => 'assets/lotties/party.json';

  /// List of all assets
  List<String> get values => [party];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
