import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/use_screen_view.dart';
import '../view_model/manhole_card_list_view_model.dart';
import '../widget/card_image.dart';
import '../widget/custom_text.dart';

/// リストタブ。都道府県ごとにカードを折りたたんで表示する。
class ManholeCardListPage extends HookConsumerWidget {
  const ManholeCardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(manholeCardListViewModelProvider);
    final state = asyncState.valueOrNull;
    final viewModel = ref.read(manholeCardListViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      appBar: AppBar(
        title: TitleLargeText(
          state?.navigationTitle ?? 'リスト',
          fontWeight: FontWeight.bold,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: '検索条件',
            icon: Badge.count(
              count: state?.activeFilterCount ?? 0,
              isLabelVisible: (state?.activeFilterCount ?? 0) > 0,
              child: const Icon(
                Icons.tune,
              ),
            ),
            onPressed: viewModel.onTapSearchCondition,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
          ),
          if (state == null)
            const Center(child: CircularProgressIndicator())
          else if (state.prefectures.isEmpty)
            ListView.builder(
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
          else
            ListView.separated(
              itemCount: state.prefectures.length + 3,
              itemBuilder: (itemContext, index) {
                if (index == 0) {
                  return Container(
                    color: Theme.of(context).dividerColor,
                    height: 0.5,
                  );
                }
                if (index == state.prefectures.length + 1) {
                  return Container(
                    color: Theme.of(context).dividerColor,
                  );
                }
                if (index == state.prefectures.length + 2) {
                  return Container(
                    color: Colors.transparent,
                    height: 0.5,
                  );
                }
                final prefectureViewData =
                    state.prefectures.getByIndex(index - 1);
                final cardWithSeparator = prefectureViewData.cards.map(
                  (cardViewData) {
                    return GestureDetector(
                      onTap: () => viewModel.onTap(cardViewData.id),
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
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: SafeArea(
                          child: Row(
                            children: [
                              SizedBox(
                                child: CardImage(
                                  cardId: cardViewData.id,
                                  alreadyGet: cardViewData.alreadyGet,
                                  memCacheWidth: 260,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TitleMediumText(prefectureViewData.name),
                      ),
                      TitleMediumText(
                        '${prefectureViewData.alreadyGetCount}/${prefectureViewData.totalCount}',
                      ),
                    ],
                  ),
                  initiallyExpanded: prefectureViewData.initiallyExpanded,
                  onExpansionChanged: (expanded) {
                    viewModel.onExpandedChanged(
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
    );
  }
}
