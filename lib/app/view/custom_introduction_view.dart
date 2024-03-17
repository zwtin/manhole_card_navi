import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '/app/view_model/custom_introduction_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';
import '/gen/assets.gen.dart';

class CustomIntroductionView extends CommonWidget {
  const CustomIntroductionView({
    super.key,
    required this.isTutorial,
  });

  final bool isTutorial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(customIntroductionViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref
                .read(customIntroductionViewModelProvider(key))
                .onLoad(isTutorial);
          },
        );
        return null;
      },
      const [],
    );

    return PVSenderWidget(
      key: key,
      parent: this,
      child: RouterWidget(
        key: key,
        parent: this,
        child: Scaffold(
          appBar: AppBar(
            title: const TitleLargeText(
              'アプリの使い方',
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Container(
            color: Theme.of(context).colorScheme.background,
            child: SafeArea(
              child: IntroductionScreen(
                key: key,
                pages: [
                  PageViewModel(
                    titleWidget: const TitleLargeText(
                      'ようこそ！',
                      fontWeight: FontWeight.bold,
                    ),
                    bodyWidget: const TitleMediumText(
                      'マンホールカード集めをもっと楽しもう！',
                    ),
                    image: Assets.images.tutorial1.image(),
                  ),
                  PageViewModel(
                    titleWidget: const TitleLargeText(
                      '近所のマンホールを探そう！',
                      fontWeight: FontWeight.bold,
                    ),
                    bodyWidget: const TitleMediumText(
                      '枠の色でカードが配布中かわかります。\n\n緑色: 配布中\n赤色: 配布停止\n黄色: 不明',
                    ),
                    image: Assets.images.tutorial2.image(),
                  ),
                  PageViewModel(
                    titleWidget: const TitleLargeText(
                      '取得済みカードをチェック！',
                      fontWeight: FontWeight.bold,
                    ),
                    bodyWidget: const TitleMediumText(
                      'カードの色で取得済みかわかります。\n\nカラー: 取得済み\nグレー: 未取得',
                    ),
                    image: Assets.images.tutorial3.image(),
                  ),
                ],
                showNextButton: true,
                showDoneButton: true,
                showBackButton: true,
                done: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TitleMediumText(
                      'OK!',
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.check,
                    ),
                  ],
                ),
                onDone: () async {
                  await ref
                      .read(customIntroductionViewModelProvider(key))
                      .onDone();
                },
                next: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const TitleMediumText(
                      '次へ',
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Transform.scale(
                      scale: 0.75,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ),
                  ],
                ),
                back: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 0.75,
                      child: const Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const TitleMediumText(
                      '前へ',
                    ),
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
        ),
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(customIntroductionViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(customIntroductionViewModelProvider(key)).onCameBack();
  }
}
