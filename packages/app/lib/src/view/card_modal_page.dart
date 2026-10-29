import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/app_router.dart';
import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/view_model/card_modal_view_model.dart';
import 'package:app/src/widget/app_text.dart';
import 'package:app/src/widget/html_content.dart';

class CardModalPage extends HookConsumerWidget {
  const CardModalPage({super.key, required this.cardId, this.pin});

  final String cardId;

  /// タップしたピンの座標。カード詳細の「マップで見る」から開いたときは null。
  final PinCoordinate? pin;

  /// マップの表示エリア（AppBar より下）の高さに対する、ドラッグハンドルを含む
  /// モーダル全体の高さ。マップは、この分を地図の padding にしてピンを残りの中央に出す。
  static double heightIn(double mapAreaHeight) => mapAreaHeight * 2 / 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (cardId: cardId, pin: pin);
    final state = ref.watch(cardModalViewModelProvider(args)).valueOrNull;
    final viewModel = ref.read(cardModalViewModelProvider(args).notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return LayoutBuilder(
      builder: (context, constraints) {
        // シートはステータスバーより下に置かれ、ドラッグハンドルの分を除いた高さが
        // ここに渡される。そこからマップの AppBar を除くと、マップの表示エリアになる。
        final mapAreaHeight =
            constraints.maxHeight + kMinInteractiveDimension - kToolbarHeight;
        return SizedBox(
          // BottomSheet がドラッグハンドルの分だけ上に余白を足すため、その分を引く。
          height: heightIn(mapAreaHeight) - kMinInteractiveDimension,
          child: SafeArea(
            child:
                state == null
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: AppText.bodyLarge('名前'),
                                      ),
                                      Flexible(
                                        child: AppText.bodyLarge(
                                          state.card.name,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (state.card.distributionPlaceHtml.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      0,
                                      16,
                                      16,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: AppText.bodyLarge('配布場所'),
                                        ),
                                        Flexible(
                                          child: HtmlContent(
                                            state.card.distributionPlaceHtml,
                                            onTapLink: viewModel.onTapLink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: AppText.bodyLarge('在庫状況'),
                                      ),
                                      Flexible(
                                        child: HtmlContent(
                                          state.card.stockHtml,
                                          onTapLink: viewModel.onTapLink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 在庫状況のリンクと「別アプリで開く」ボタンが近すぎて
                        // 押し間違えやすいため、間に少し余白を入れる。
                        const SizedBox(height: 12),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: ElevatedButton(
                            onPressed: viewModel.onTapOpenInOtherApp,
                            child: AppText.titleMedium(
                              '別アプリで開く',
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLowest,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  0,
                                ),
                                child: OutlinedButton(
                                  onPressed: viewModel.onTapDetailButton,
                                  child: SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: AppText.titleMedium(
                                        '詳細を見る',
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  0,
                                ),
                                child: OutlinedButton(
                                  onPressed: viewModel.onTapAlreadyGetButton,
                                  child: SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: AppText.titleMedium(
                                        state.alreadyGetActionButtonTitle,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 下タブ(少し上にはみ出す形)とボタンが被らないよう、
                        // DetailPage と同じ 40px の余白を下に取ってボタンを持ち上げる。
                        const SizedBox(height: 40),
                      ],
                    ),
          ),
        );
      },
    );
  }
}
