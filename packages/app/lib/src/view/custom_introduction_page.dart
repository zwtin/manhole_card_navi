import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../gen/assets.gen.dart';
import '../router/use_screen_view.dart';
import '../view_model/custom_introduction_view_model.dart';
import '../widget/custom_text.dart';

/// アプリの使い方。初回起動時のチュートリアルと、設定の「アプリの使い方」で使う。
class CustomIntroductionPage extends HookConsumerWidget {
  const CustomIntroductionPage({super.key, required this.isTutorial});

  /// 初回起動時のチュートリアルか。true なら完了後に同意画面へ進み、false なら閉じる。
  final bool isTutorial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(customIntroductionViewModelProvider(isTutorial));
    final viewModel = ref.read(
      customIntroductionViewModelProvider(isTutorial).notifier,
    );

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      appBar: AppBar(
        title: const TitleLargeText('アプリの使い方', fontWeight: FontWeight.bold),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                titleWidget: const TitleLargeText(
                  'ようこそ！',
                  fontWeight: FontWeight.bold,
                ),
                bodyWidget: const TitleMediumText('マンホールカード集めをもっと楽しもう！'),
                image: Assets.images.tutorials.tutorial1.image(),
              ),
              PageViewModel(
                titleWidget: const TitleLargeText(
                  '近所のマンホールを探そう！',
                  fontWeight: FontWeight.bold,
                ),
                bodyWidget: const TitleMediumText(
                  '枠の色でカードが配布中かわかります。\n\n緑色: 配布中\n赤色: 配布停止\n黄色: 不明',
                ),
                image: Assets.images.tutorials.tutorial2.image(),
              ),
              PageViewModel(
                titleWidget: const TitleLargeText(
                  '取得済みカードをチェック！',
                  fontWeight: FontWeight.bold,
                ),
                bodyWidget: const TitleMediumText(
                  'カードの色で取得済みかわかります。\n\nカラー: 取得済み\nグレー: 未取得',
                ),
                image: Assets.images.tutorials.tutorial3.image(),
              ),
            ],
            showNextButton: true,
            showDoneButton: true,
            showBackButton: true,
            done: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TitleMediumText('OK!'),
                SizedBox(width: 8),
                Icon(Icons.check),
              ],
            ),
            onDone: viewModel.onDone,
            next: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const TitleMediumText('次へ'),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.75,
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            back: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.75,
                  child: const Icon(Icons.arrow_back_ios),
                ),
                const SizedBox(width: 4),
                const TitleMediumText('前へ'),
              ],
            ),
            globalBackgroundColor: Theme.of(context).colorScheme.background,
            dotsDecorator: DotsDecorator(
              color: Theme.of(context).iconTheme.color ?? Colors.grey,
            ),
            animationDuration: 200,
            bodyPadding: const EdgeInsets.only(top: 16),
            controlsPosition: const Position(left: 8, right: 8, bottom: 32),
          ),
        ),
      ),
    );
  }
}
