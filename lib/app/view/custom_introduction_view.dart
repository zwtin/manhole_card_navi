import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '/app/view_model/custom_introduction_view_model.dart';
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
        color: ColorName.main,
        child: SafeArea(
          child: IntroductionScreen(
            key: key,
            pages: [
              PageViewModel(
                title: 'Page One',
                bodyWidget: const Text('That\'s all folks'),
              ),
              PageViewModel(
                titleWidget: Container(),
                bodyWidget: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              ),
            ],
            showNextButton: true,
            showDoneButton: true,
            showBackButton: true,
            done: const Text(
              'OK!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onDone: () async {
              await ref.read(customIntroductionViewModelProvider(key)).onDone();
            },
            next: const Icon(Icons.arrow_forward_ios),
            back: const Icon(Icons.arrow_back_ios),
            globalBackgroundColor: ColorName.main,
          ),
        ),
      ),
    );
  }
}
