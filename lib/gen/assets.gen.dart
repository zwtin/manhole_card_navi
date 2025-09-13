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

  /// Directory path: assets/images/license
  $AssetsImagesLicenseGen get license => const $AssetsImagesLicenseGen();

  /// Directory path: assets/images/terms
  $AssetsImagesTermsGen get terms => const $AssetsImagesTermsGen();

  /// Directory path: assets/images/tutorials
  $AssetsImagesTutorialsGen get tutorials => const $AssetsImagesTutorialsGen();
}

class $AssetsLottiesGen {
  const $AssetsLottiesGen();

  /// File path: assets/lotties/party.json
  String get party => 'assets/lotties/party.json';

  /// List of all assets
  List<String> get values => [party];
}

class $AssetsImagesLicenseGen {
  const $AssetsImagesLicenseGen();

  /// File path: assets/images/license/icon.png
  AssetGenImage get icon =>
      const AssetGenImage('assets/images/license/icon.png');

  /// List of all assets
  List<AssetGenImage> get values => [icon];
}

class $AssetsImagesTermsGen {
  const $AssetsImagesTermsGen();

  /// File path: assets/images/terms/terms.jpg
  AssetGenImage get terms =>
      const AssetGenImage('assets/images/terms/terms.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [terms];
}

class $AssetsImagesTutorialsGen {
  const $AssetsImagesTutorialsGen();

  /// File path: assets/images/tutorials/tutorial_1.jpg
  AssetGenImage get tutorial1 =>
      const AssetGenImage('assets/images/tutorials/tutorial_1.jpg');

  /// File path: assets/images/tutorials/tutorial_2.png
  AssetGenImage get tutorial2 =>
      const AssetGenImage('assets/images/tutorials/tutorial_2.png');

  /// File path: assets/images/tutorials/tutorial_3.png
  AssetGenImage get tutorial3 =>
      const AssetGenImage('assets/images/tutorials/tutorial_3.png');

  /// List of all assets
  List<AssetGenImage> get values => [tutorial1, tutorial2, tutorial3];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

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
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
