import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/use_screen_view.dart';
import '../view_model/card_modal_view_model.dart';
import '../view_model/manhole_card_map_view_model.dart';
import '../widget/custom_text.dart';
import '../widget/html_content.dart';

/// マップタブでピンをタップしたときに出るカードのモーダル。
class CardModalPage extends HookConsumerWidget {
  const CardModalPage({
    super.key,
    required this.cardId,
    this.latitude,
    this.longitude,
  });

  final String cardId;

  /// タップしたピンの座標。カード詳細の「マップで見る」から開いたときは null。
  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (cardId: cardId, latitude: latitude, longitude: longitude);
    final state = ref.watch(cardModalViewModelProvider(args)).valueOrNull;
    final viewModel = ref.read(cardModalViewModelProvider(args).notifier);
    // ドラッグハンドル領域を含むモーダル全体の高さ。マップの表示エリアの 2/3。
    final height = ref.watch(
      manholeCardMapViewModelProvider.select((state) => state.modalHeight),
    );

    useScreenView(ref, viewModel.sendScreenView);

    return SizedBox(
      // BottomSheet がドラッグハンドルの分だけ上に余白を足すため、その分を引く。
      height: height - kMinInteractiveDimension,
      child: SafeArea(
        child: state == null
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
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 120,
                                  child: BodyLargeText('名前'),
                                ),
                                Flexible(
                                  child: BodyLargeText(state.card.name),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 120,
                                    child: BodyLargeText('配布場所'),
                                  ),
                                  Flexible(
                                    child: HtmlContent(
                                      state.card.distributionPlaceHtml,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 120,
                                  child: BodyLargeText('在庫状況'),
                                ),
                                Flexible(
                                  child: HtmlContent(state.card.stockHtml),
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
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          await viewModel.openGoogleMap();
                        } else if (Platform.isIOS) {
                          await _showSelectMapModal(context, viewModel);
                        }
                      },
                      child: TitleMediumText(
                        '別アプリで開く',
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: OutlinedButton(
                            onPressed: viewModel.onTapDetailButton,
                            child: SizedBox(
                              height: 48,
                              child: Center(
                                child: TitleMediumText(
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: OutlinedButton(
                            onPressed: viewModel.onTapAlreadyGetButton,
                            child: SizedBox(
                              height: 48,
                              child: Center(
                                child: TitleMediumText(
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
  }

  /// iOS では Apple Map と Google Map のどちらで開くか選んでもらう。
  Future<void> _showSelectMapModal(
    BuildContext context,
    CardModalViewModel viewModel,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (modalContext) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const TitleMediumText('Apple Map で開く'),
                  tileColor: Colors.transparent,
                  onTap: () async {
                    Navigator.of(modalContext).pop();
                    await viewModel.openAppleMap();
                  },
                ),
                ListTile(
                  title: const TitleMediumText('Google Map で開く'),
                  tileColor: Colors.transparent,
                  onTap: () async {
                    Navigator.of(modalContext).pop();
                    await viewModel.openGoogleMap();
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
