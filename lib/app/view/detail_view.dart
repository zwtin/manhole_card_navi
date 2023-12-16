import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

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
            LoadingOverlay(
              isLoading: viewModel.isLoading,
              child: viewModel.isLoading
                  ? Container()
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 130,
                                  height: 180,
                                  child: Image.memory(
                                    viewModel.viewData.icon,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: BodyLargeRegularText('名前'),
                                      ),
                                      Flexible(
                                        child: BodyLargeRegularText(
                                          viewModel.viewData.name,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: BodyLargeRegularText('都道府県'),
                                      ),
                                      Flexible(
                                        child: BodyLargeRegularText(
                                          viewModel.viewData.prefecture,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: BodyLargeRegularText('弾数'),
                                      ),
                                      Flexible(
                                        child: BodyLargeRegularText(
                                          viewModel.viewData.volume,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: BodyLargeRegularText('発行年月日'),
                                      ),
                                      Flexible(
                                        child: BodyLargeRegularText(
                                          viewModel.viewData.publicationDate,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...viewModel.viewData.contacts.map(
                                  (contactViewData) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        8,
                                        16,
                                        8,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 120,
                                            child: BodyLargeRegularText('配布場所'),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (contactViewData
                                                    .nameUrl.isNotEmpty)
                                                  TextButton(
                                                    onPressed: () async {
                                                      final uri = Uri.parse(
                                                          contactViewData
                                                              .nameUrl);
                                                      if (await canLaunchUrl(
                                                          uri)) {
                                                        launchUrl(
                                                          uri,
                                                          mode: LaunchMode
                                                              .inAppWebView,
                                                        );
                                                      }
                                                    },
                                                    child:
                                                        BodyLargeRegularLinkText(
                                                      contactViewData.name,
                                                    ),
                                                  ),
                                                if (contactViewData
                                                    .nameUrl.isEmpty)
                                                  BodyLargeRegularText(
                                                    contactViewData.name,
                                                  ),
                                                BodyLargeRegularText(
                                                  contactViewData.address,
                                                ),
                                                BodyLargeRegularText(
                                                  contactViewData.phoneNumber,
                                                ),
                                                BodyLargeRegularText(
                                                  contactViewData.other,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                BodyLargeRegularText(
                                                  contactViewData.time,
                                                ),
                                                BodyLargeRegularText(
                                                  contactViewData.timeOther,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: BodyLargeRegularText('在庫状況'),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (viewModel
                                                .viewData
                                                .distributionLinkText
                                                .isNotEmpty)
                                              TextButton(
                                                onPressed: () async {
                                                  final uri = Uri.parse(
                                                      viewModel.viewData
                                                          .distributionLinkUrl);
                                                  if (await canLaunchUrl(uri)) {
                                                    launchUrl(
                                                      uri,
                                                      mode: LaunchMode
                                                          .inAppWebView,
                                                    );
                                                  }
                                                },
                                                child: BodyLargeRegularLinkText(
                                                  viewModel.viewData
                                                      .distributionLinkText,
                                                ),
                                              ),
                                            BodyLargeRegularText(
                                              viewModel
                                                  .viewData.distributionText,
                                            ),
                                            BodyLargeRegularText(
                                              viewModel
                                                  .viewData.distributionOther,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Divider(),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 30),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await ref
                                            .read(detailViewModelProvider(key))
                                            .onTapCheckWithMapButton();
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        child: Center(
                                          child:
                                              TitleMediumRegularText('マップで見る'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 30),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await ref
                                            .read(detailViewModelProvider(key))
                                            .onTapAlreadyGetButton();
                                      },
                                      child: SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: TitleMediumRegularText(
                                            viewModel
                                                .alreadyGetActionButtonTitle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
