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
                showModalBottomSheet<int>(
                  context: context,
                  builder: (modalContext) {
                    return Container(
                      color: ColorName.main,
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading:
                                const Icon(Icons.edit, color: Colors.white),
                            title: const TitleMediumRegularText('全表示'),
                            trailing: const Icon(Icons.check,
                                color: ColorName.accent),
                            onTap: () async {
                              Navigator.of(modalContext).pop();
                              ref
                                  .read(manholeCardListViewModelProvider(key))
                                  .onTap();
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            title: const TitleMediumRegularText('取得済みのみ'),
                            onTap: () async {
                              Navigator.of(modalContext).pop();
                              ref
                                  .read(manholeCardListViewModelProvider(key))
                                  .onTap();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
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
              itemCount: viewModel.prefecturesViewData.length,
              itemBuilder: (itemContext, index) {
                final viewData =
                    viewModel.prefecturesViewData.getByIndex(index);
                final cardWithSeparator = viewData.cards.expand(
                  (card) {
                    return [
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          showLicensePage(context: context);
                        },
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: ColorName.main,
                          child: const BodyLargeRegularText(
                            'This is tile number 1',
                          ),
                        ),
                      ),
                    ];
                  },
                ).toList();
                if (cardWithSeparator.isNotEmpty) {
                  cardWithSeparator.add(const Divider());
                }
                return ExpansionTile(
                  title: TitleMediumRegularText(viewData.name),
                  children: cardWithSeparator,
                );
              },
              separatorBuilder: (separatorContext, index) {
                return const Divider();
              },
            ),
          ],
        ),
      ),
    );
  }
}
