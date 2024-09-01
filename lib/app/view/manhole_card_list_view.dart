import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/view_model/manhole_card_list_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class ManholeCardListView extends CommonWidget {
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

    return PVSenderWidget(
      key: key,
      parent: this,
      child: RouterWidget(
        key: key,
        parent: this,
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
            title: TitleLargeText(
              viewModel.navigationTitle,
              fontWeight: FontWeight.bold,
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
                      return SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: viewModel.listState == ListState.all
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                title: const TitleMediumText(
                                  'すべて',
                                ),
                                tileColor: Colors.transparent,
                                onTap: () async {
                                  Navigator.of(modalContext).pop();
                                  ref
                                      .read(
                                          manholeCardListViewModelProvider(key))
                                      .onChangeMapState(ListState.all);
                                },
                              ),
                              ListTile(
                                leading: viewModel.listState ==
                                        ListState.alreadyGet
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                title: const TitleMediumText(
                                  '取得済みのみ',
                                ),
                                tileColor: Colors.transparent,
                                onTap: () async {
                                  Navigator.of(modalContext).pop();
                                  ref
                                      .read(
                                          manholeCardListViewModelProvider(key))
                                      .onChangeMapState(ListState.alreadyGet);
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
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
                color: Theme.of(context).colorScheme.background,
              ),
              viewModel.prefecturesViewData.isEmpty
                  ? ListView.builder(
                      itemBuilder: (itemContext, index) {
                        return const SafeArea(
                          child: SizedBox(
                            height: 250,
                            child: Center(
                              child: BodyMediumText(
                                '表示できるデータがありません',
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: 1,
                    )
                  : ListView.separated(
                      itemCount: viewModel.prefecturesViewData.length + 3,
                      itemBuilder: (itemContext, index) {
                        if (index == 0) {
                          return Container(
                            color: Theme.of(context).dividerColor,
                            height: 0.5,
                          );
                        }
                        if (index == viewModel.prefecturesViewData.length + 1) {
                          return Container(
                            color: Theme.of(context).dividerColor,
                          );
                        }
                        if (index == viewModel.prefecturesViewData.length + 2) {
                          return Container(
                            color: Colors.transparent,
                            height: 0.5,
                          );
                        }
                        final prefectureViewData =
                            viewModel.prefecturesViewData.getByIndex(index - 1);
                        final cardWithSeparator = prefectureViewData.cards.map(
                          (cardViewData) {
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(manholeCardListViewModelProvider(key))
                                    .onTap(cardViewData.id);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                height: 120,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: SafeArea(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: CachedNetworkImage(
                                          imageUrl: cardViewData.imageUrl,
                                          fadeInDuration: const Duration(
                                            microseconds: 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TitleMediumText(
                                              cardViewData.name,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            BodyMediumText(
                                              cardViewData.id,
                                            ),
                                            const Spacer(),
                                            BodyMediumText(
                                              cardViewData.volume,
                                            ),
                                            BodyMediumText(
                                              cardViewData.publicationDate,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList();
                        return ExpansionTile(
                          title: TitleMediumText(
                            prefectureViewData.name,
                          ),
                          initiallyExpanded:
                              prefectureViewData.initiallyExpanded,
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
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(manholeCardListViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(manholeCardListViewModelProvider(key)).onCameBack();
  }
}
