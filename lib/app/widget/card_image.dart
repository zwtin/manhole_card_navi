import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// マンホールカードの画像を表示するウィジェット。
///
/// 原本画像（カラー）URL を [imageUrl] に渡す。未所持（[alreadyGet] が false）の
/// 場合は実行時に彩度 0 のカラーフィルターを掛けてグレースケール表示する。
///
/// [memCacheWidth] / [maxWidthDiskCache] を指定すると原寸デコードを避けられる。
class CardImage extends StatelessWidget {
  const CardImage({
    required this.imageUrl,
    required this.alreadyGet,
    this.memCacheWidth,
    this.maxWidthDiskCache,
    this.fit,
    super.key,
  });

  final String imageUrl;
  final bool alreadyGet;
  final int? memCacheWidth;
  final int? maxWidthDiskCache;
  final BoxFit? fit;

  /// 彩度 0（グレースケール化）のカラーマトリクス。
  static const List<double> grayscaleMatrix = <double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  /// Hero 遷移中も所持状況に応じた色（未所持ならグレー）を維持するための
  /// flightShuttleBuilder を返す。
  ///
  /// Hero の飛行中はデフォルトで遷移先の child が表示されるが、遷移先
  /// （画像拡大の PhotoView）はグレーフィルタが Hero の外側にあるため、
  /// 未所持カードでも飛行中だけカラーが覗いてしまう。飛行中の widget を
  /// グレーフィルタで包むことでこれを防ぐ。
  ///
  /// 注意: 復路（拡大→詳細）では遷移先 child が詳細サムネの [CardImage] で、
  /// 既にグレー化済みのため、ここでの ColorFiltered と合わせて二重適用になる。
  /// [grayscaleMatrix]（彩度 0・係数和 1.0）は冪等なので二重適用でも結果は
  /// 変わらず問題ないが、この行列を彩度 0 以外（セピア等・係数和 ≠ 1.0）に
  /// 変更する場合は二重適用で色が破綻する点に注意すること。
  static HeroFlightShuttleBuilder heroFlightShuttleBuilder({
    required bool alreadyGet,
  }) {
    return (
      flightContext,
      animation,
      flightDirection,
      fromHeroContext,
      toHeroContext,
    ) {
      // 飛行中に表示する widget は遷移先 Hero の child を用いる
      // （デフォルトの flightShuttleBuilder と同じ挙動）。
      final toHero = toHeroContext.widget as Hero;
      if (alreadyGet) {
        return toHero.child;
      }
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix(grayscaleMatrix),
        child: toHero.child,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fadeInDuration: const Duration(microseconds: 0),
      memCacheWidth: memCacheWidth,
      maxWidthDiskCache: maxWidthDiskCache,
      fit: fit,
    );
    if (alreadyGet) {
      return image;
    }
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(grayscaleMatrix),
      child: image,
    );
  }
}
