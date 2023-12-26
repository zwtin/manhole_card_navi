import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '/app/view_model/custom_introduction_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class CustomIntroductionView extends HookConsumerWidget {
  const CustomIntroductionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(customIntroductionViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(customIntroductionViewModelProvider(key)).onLoad();
          },
        );
        return null;
      },
      const [],
    );

    return RouterWidget(
      key: key,
      child: Container(
        color: ColorName.screenBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              8.0,
              16.0,
              8.0,
              0.0,
            ),
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
                  image: Image.asset(
                    'assets/images/frame_green.png',
                  ),
                ),
                PageViewModel(
                  titleWidget: const TitleLargeText(
                    '近所のマンホールを探そう！',
                    fontWeight: FontWeight.bold,
                  ),
                  bodyWidget: const TitleMediumText(
                    '枠の色でカードが配布中かわかります。\n\n緑色: 配布中\n赤色: 配布停止\n黄色: 不明',
                  ),
                  image: Image.asset(
                    'assets/images/frame_yellow.png',
                  ),
                ),
                PageViewModel(
                  titleWidget: const TitleLargeText(
                    '取得済みカードをチェック！',
                    fontWeight: FontWeight.bold,
                  ),
                  bodyWidget: const TitleMediumText(
                    'カードの色で取得済みかわかります。\n\nカラー: 取得済み\nグレー: 未取得',
                  ),
                  image: Image.asset(
                    'assets/images/frame_red.png',
                  ),
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
                    color: ColorName.icon,
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
                      color: ColorName.icon,
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
                      color: ColorName.icon,
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
              globalBackgroundColor: ColorName.screenBackground,
              dotsDecorator: const DotsDecorator(
                activeColor: ColorName.primary,
                color: ColorName.icon,
              ),
              animationDuration: 200,
            ),
          ),
        ),
      ),
    );
  }
}
