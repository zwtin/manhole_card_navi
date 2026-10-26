import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/widget/card_image_provider.dart';

class CardImage extends ConsumerWidget {
  const CardImage({
    required this.cardId,
    required this.alreadyGet,
    this.memCacheWidth,
    this.fit,
    super.key,
  });

  final String cardId;
  final bool alreadyGet;

  /// 表示するときの幅。指定すると原寸でデコードしない。
  final int? memCacheWidth;
  final BoxFit? fit;

  static const List<double> grayscaleMatrix = <double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  /// Hero の飛行中は遷移先の child が出るが、画像拡大（PhotoView）はグレーの
  /// フィルタが Hero の外にあるので、未取得のカードでも飛行中だけカラーになる。
  /// 飛行中の widget をグレーのフィルタで包んで防ぐ。
  ///
  /// 復路（拡大→詳細）の遷移先は、グレーにしてある詳細の [CardImage] なので、
  /// フィルタが二重に掛かる。[grayscaleMatrix] は何度掛けても同じ結果になる
  /// （彩度 0・係数の和 1.0）ので問題ないが、セピアなど係数の和が 1.0 でない
  /// 行列に変えると色が崩れる。
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
      // 既定の flightShuttleBuilder と同じく、遷移先の Hero の child を出す。
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
  Widget build(BuildContext context, WidgetRef ref) {
    final image = Image(
      image: ResizeImage.resizeIfNeeded(
        memCacheWidth,
        null,
        ref.watch(cardImageProvider(cardId)),
      ),
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
