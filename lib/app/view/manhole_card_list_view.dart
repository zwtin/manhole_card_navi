import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
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
      pop: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          final bottomTabKey =
              ref.read(tabKeyStorageProvider).getBottomTabKey();
          ref.read(bottomTabViewModelProvider(bottomTabKey)).onTap(0);
        }
      },
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
                            leading: viewModel.listState == ListState.all
                                ? const Icon(
                                    Icons.check,
                                    color: ColorName.accent,
                                  )
                                : const SizedBox(
                                    width: 40,
                                    height: 40,
                                  ),
                            title: const TitleMediumRegularText('すべて'),
                            onTap: () async {
                              Navigator.of(modalContext).pop();
                              ref
                                  .read(manholeCardListViewModelProvider(key))
                                  .onChangeMapState(ListState.all);
                            },
                          ),
                          ListTile(
                            leading: viewModel.listState == ListState.alreadyGet
                                ? const Icon(
                                    Icons.check,
                                    color: ColorName.accent,
                                  )
                                : const SizedBox(
                                    width: 40,
                                    height: 40,
                                  ),
                            title: const TitleMediumRegularText('取得済みのみ'),
                            onTap: () async {
                              Navigator.of(modalContext).pop();
                              ref
                                  .read(manholeCardListViewModelProvider(key))
                                  .onChangeMapState(ListState.alreadyGet);
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
            viewModel.prefecturesViewData.where(
              (prefectureViewData) {
                return !prefectureViewData.cards.where(
                  (card) {
                    return !card.isHidden;
                  },
                ).isEmpty;
              },
            ).isEmpty
                ? ListView.builder(
                    itemBuilder: (itemContext, index) {
                      return const SizedBox(
                        height: 250,
                        child: Center(
                            child: TitleMediumRegularText('表示できるデータがありません')),
                      );
                    },
                    itemCount: 1,
                  )
                : ListView.separated(
                    itemCount: viewModel.prefecturesViewData.where(
                          (prefectureViewData) {
                            return !prefectureViewData.cards.where(
                              (card) {
                                return !card.isHidden;
                              },
                            ).isEmpty;
                          },
                        ).length +
                        2,
                    itemBuilder: (itemContext, index) {
                      if (index == 0) {
                        return Container(
                          color: Colors.white,
                          height: 0.5,
                        );
                      }
                      if (index ==
                          viewModel.prefecturesViewData.where(
                                (prefectureViewData) {
                                  return !prefectureViewData.cards.where(
                                    (card) {
                                      return !card.isHidden;
                                    },
                                  ).isEmpty;
                                },
                              ).length +
                              1) {
                        return Container();
                      }
                      final prefectureViewData =
                          viewModel.prefecturesViewData.where(
                        (prefectureViewData) {
                          return !prefectureViewData.cards.where(
                            (card) {
                              return !card.isHidden;
                            },
                          ).isEmpty;
                        },
                      ).getByIndex(index - 1);
                      final cardWithSeparator = prefectureViewData.cards.where(
                        (cardViewData) {
                          return !cardViewData.isHidden;
                        },
                      ).map(
                        (cardViewData) {
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(manholeCardListViewModelProvider(key))
                                  .onTap(cardViewData.id);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              height: 120,
                              width: double.infinity,
                              // color: ColorName.main,
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Row(
                                children: [
                                  Image.memory(cardViewData.icon),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cardViewData.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        BodyMediumRegularText(cardViewData.id),
                                        const Spacer(),
                                        BodyMediumRegularText(
                                            cardViewData.volume),
                                        BodyMediumRegularText(
                                            cardViewData.publicationDate),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList();
                      return ExpansionTile(
                        title: TitleMediumRegularText(prefectureViewData.name),
                        initiallyExpanded: prefectureViewData.initiallyExpanded,
                        onExpansionChanged: (expanded) async {
                          await ref
                              .read(manholeCardListViewModelProvider(key))
                              .onExpandedChanged(
                                expanded,
                                prefectureViewData.id,
                              );
                        },
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
