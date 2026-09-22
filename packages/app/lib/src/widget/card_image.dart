import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'card_image_provider.dart';

/// マンホールカードの画像を表示するウィジェット。
///
/// [cardId] のカードの画像を出す。未所持（[alreadyGet] が false）の場合は実行時に
/// 彩度 0 のカラーフィルターを掛けてグレースケール表示する。
///
/// [memCacheWidth] は表示するときの幅。指定すると原寸デコードを避けられる。
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
  final int? memCacheWidth;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final image = Image(
      image: ResizeImage.resizeIfNeeded(
        memCacheWidth,
        null,
        CardImageProvider(
          useCase: ref.watch(cardUseCaseProvider),
          cardId: cardId,
        ),
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
