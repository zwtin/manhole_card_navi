import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uuid/uuid.dart';

import '../router/use_screen_view.dart';
import '../service/card_image_cache_manager.dart';
import '../service/image_fallback.dart';
import '../view_model/detail_view_model.dart';
import '../widget/card_image.dart';
import '../widget/custom_text.dart';
import '../widget/html_content.dart';

/// カード詳細。リストタブと、マップタブのモーダルから開く。
class DetailPage extends HookConsumerWidget {
  const DetailPage({
    super.key,
    required this.cardId,
  });

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(detailViewModelProvider(cardId)).valueOrNull;
    final viewModel = ref.read(detailViewModelProvider(cardId).notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      appBar: AppBar(
        title: const TitleLargeText(
          '詳細',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
          ),
          LoadingOverlay(
            color: Theme.of(context).colorScheme.background,
            isLoading: card == null,
            child: card == null
                ? Container()
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Builder(
                                builder: (context) {
                                  final heroTag = const Uuid().v4();
                                  return GestureDetector(
                                    onTap: () async {
                                      // 画像拡大（PhotoView）で使う原寸画像の
                                      // デコード完了を待ってから遷移する。
                                      // 遷移開始時に PhotoView が即 Hero を
                                      // 構築でき、初回でも Hero が成立する。
                                      // 先読みに失敗しても遷移は続行する。
                                      try {
                                        await precacheImage(
                                          CachedNetworkImageProvider(
                                            card.imageUrl,
                                            headers: ImageFallback.headers(
                                              card.imageSubUrl,
                                            ),
                                            cacheManager:
                                                CardImageCacheManager(),
                                          ),
                                          context,
                                        );
                                      } on Exception {
                                        // 先読み失敗時はそのまま遷移する。
                                      }
                                      await viewModel.onTapImage(heroTag);
                                    },
                                    child: Hero(
                                      tag: heroTag,
                                      flightShuttleBuilder:
                                          CardImage.heroFlightShuttleBuilder(
                                        alreadyGet: card.alreadyGet,
                                      ),
                                      child: SizedBox(
                                        width: 130,
                                        height: 180,
                                        // memCacheWidth を指定せず原寸デコード
                                        // する。画像拡大（PhotoView）も原寸
                                        // デコードのため、デコード済みビット
                                        // マップが共有され、初回タップでも
                                        // Hero 遷移が成立する。
                                        child: CardImage(
                                          imageUrl: card.imageUrl,
                                          imageSubUrl: card.imageSubUrl,
                                          alreadyGet: card.alreadyGet,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              _DetailRow(
                                label: '名前',
                                child: BodyLargeText(card.name),
                              ),
                              _DetailRow(
                                label: '都道府県',
                                child: BodyLargeText(card.prefecture),
                              ),
                              _DetailRow(
                                label: '弾数',
                                child: BodyLargeText(card.volume),
                              ),
                              _DetailRow(
                                label: '発行年月日',
                                child: BodyLargeText(card.publicationDate),
                              ),
                              if (card.distributionPlaceHtml.isNotEmpty)
                                _DetailRow(
                                  label: '配布場所',
                                  child: HtmlContent(
                                    card.distributionPlaceHtml,
                                  ),
                                ),
                              if (card.distributionTimeHtml.isNotEmpty)
                                _DetailRow(
                                  label: '配布時間',
                                  child: HtmlContent(card.distributionTimeHtml),
                                ),
                              _DetailRow(
                                label: '在庫状況',
                                child: HtmlContent(card.stockHtml),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // 在庫状況のリンクと下のボタンが近すぎて押し間違えやすい
                          // ため、区切り線の上に少し余白を入れて間隔を空ける。
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: ElevatedButton(
                                    onPressed:
                                        viewModel.onTapCheckWithMapButton,
                                    child: SizedBox(
                                      height: 48,
                                      child: Center(
                                        child: TitleMediumText(
                                          'マップで見る',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: ElevatedButton(
                                    onPressed: viewModel.onTapAlreadyGetButton,
                                    child: SizedBox(
                                      height: 48,
                                      child: Center(
                                        child: TitleMediumText(
                                          card.alreadyGetActionButtonTitle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// 項目名と値を横に並べた 1 行。
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodyLargeText(label),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
