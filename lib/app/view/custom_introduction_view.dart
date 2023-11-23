import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:manhole_card_navi/app/widget/custom_text.dart';

import '/app/view_model/custom_introduction_view_model.dart';
import '/app/widget/alert_widget.dart';
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

    return AlertWidget(
      child: RouterWidget(
        key: key,
        child: Container(
          color: ColorName.main,
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
                    titleWidget: const TitleLargeBoldText('ようこそ！'),
                    bodyWidget:
                        const TitleMediumRegularText('マンホールカード集めをもっと楽しもう！'),
                    image: Image.asset('assets/images/frame_green.png'),
                  ),
                  PageViewModel(
                    titleWidget: const TitleLargeBoldText('近所のマンホールを探そう！'),
                    bodyWidget: const TitleMediumRegularText(
                        '枠の色でカードが配布中かわかります。\n\n緑色: 配布中\n赤色: 配布停止\n黄色: 不明'),
                    image: Image.asset('assets/images/frame_yellow.png'),
                  ),
                  PageViewModel(
                    titleWidget: const TitleLargeBoldText('取得済みカードをチェック！'),
                    bodyWidget: const TitleMediumRegularText(
                        'カードの色で取得済みかわかります。\n\nカラー: 取得済み\nグレー: 未取得'),
                    image: Image.asset('assets/images/frame_red.png'),
                  ),
                ],
                showNextButton: true,
                showDoneButton: true,
                showBackButton: true,
                done: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TitleMediumRegularText('OK!'),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.white,
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
                    const TitleMediumRegularText('次へ'),
                    const SizedBox(
                      width: 4,
                    ),
                    Transform.scale(
                      scale: 0.75,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const TitleMediumRegularText('前へ'),
                  ],
                ),
                globalBackgroundColor: ColorName.main,
                dotsDecorator: const DotsDecorator(
                  activeColor: ColorName.accent,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
