import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class CustomIntroductionView extends StatelessWidget {
  const CustomIntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
          showNextButton: false,
          showDoneButton: false,
        ),
      ),
    );
  }
}
