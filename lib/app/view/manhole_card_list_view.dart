import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/manhole_card_list_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class ManholeCardListView extends HookConsumerWidget {
  const ManholeCardListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(manholeCardListViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(manholeCardListViewModelProvider(key)).onLoad();
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
            'リスト',
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                ref.read(manholeCardListViewModelProvider(key)).onTap();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: ColorName.main,
            ),
            ListView.separated(
              itemCount: 3,
              itemBuilder: (_context, index) {
                switch (index) {
                  case 0:
                    return ExpansionTile(
                      title: const TitleMediumRegularText('全国'),
                      shape: const Border(),
                      children: <Widget>[
                        const Divider(),
                        GestureDetector(
                          onTap: () {
                            showLicensePage(context: context);
                          },
                          child: Container(
                            height: 100,
                            color: ColorName.main,
                            child: const BodyLargeRegularText(
                              'This is tile number 1',
                            ),
                          ),
                        ),
                        const Divider(),
                        Container(
                          height: 100,
                          color: ColorName.main,
                          child: const BodyMediumRegularText(
                            'This is tile number 1',
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  case 1:
                    return ExpansionTile(
                      title: const TitleMediumRegularText('北海道'),
                      shape: const Border(),
                      children: <Widget>[
                        const Divider(),
                        GestureDetector(
                          onTap: () {
                            showLicensePage(context: context);
                          },
                          child: Container(
                            height: 100,
                            color: ColorName.main,
                            child: const TitleMediumRegularText(
                              'This is tile number 1',
                            ),
                          ),
                        ),
                        const Divider(),
                        Container(
                          height: 100,
                          color: ColorName.main,
                          child: const TitleMediumRegularText(
                            'This is tile number 1',
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  case 2:
                    return ExpansionTile(
                      title: const TitleMediumRegularText('埼玉県'),
                      shape: const Border(),
                      children: <Widget>[
                        const Divider(),
                        GestureDetector(
                          onTap: () {
                            showLicensePage(context: context);
                          },
                          child: Container(
                            height: 100,
                            color: ColorName.main,
                            child: const TitleMediumRegularText(
                              'This is tile number 1',
                            ),
                          ),
                        ),
                        const Divider(),
                        Container(
                          height: 100,
                          color: ColorName.main,
                          child: const TitleMediumRegularText(
                            'This is tile number 1',
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                }
              },
              separatorBuilder: (_context, index) {
                return Divider();
              },
            ),
          ],
        ),
      ),
    );
  }
}
