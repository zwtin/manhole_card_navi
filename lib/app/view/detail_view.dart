import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/detail_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class DetailView extends HookConsumerWidget {
  const DetailView({
    super.key,
    required this.cardId,
  });

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(detailViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(detailViewModelProvider(key)).onLoad(cardId);
          },
        );
        return null;
      },
      const [],
    );

    return RouterWidget(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const TitleLargeBoldText(
            '詳細',
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: ColorName.main,
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const SizedBox(
                              height: 50,
                              child: Center(
                                child: BodyMediumRegularText('マップで見る'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                          child: ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .read(detailViewModelProvider(key))
                                  .onTap();
                            },
                            child: const SizedBox(
                              height: 50,
                              child: Center(
                                child: BodyMediumRegularText('取得済みにする'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
