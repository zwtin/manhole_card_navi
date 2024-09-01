import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '/app/view_model/detail_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class DetailView extends CommonWidget {
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

    return PVSenderWidget(
      key: key,
      parent: this,
      child: RouterWidget(
        key: key,
        parent: this,
        child: Scaffold(
          appBar: AppBar(
            title: const TitleLargeText(
              '詳細',
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Stack(
            children: [
              Container(
                color: Theme.of(context).colorScheme.background,
              ),
              LoadingOverlay(
                color: Theme.of(context).colorScheme.background,
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
                                  Builder(
                                    builder: (context) {
                                      final heroTag = const Uuid().v4();
                                      return GestureDetector(
                                        onTap: () async {
                                          await ref
                                              .read(
                                                  detailViewModelProvider(key))
                                              .onTapImage(heroTag);
                                        },
                                        child: Hero(
                                          tag: heroTag,
                                          child: SizedBox(
                                            width: 130,
                                            height: 180,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  viewModel.viewData.imageUrl,
                                              fadeInDuration: const Duration(
                                                microseconds: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
                                          child: BodyLargeText(
                                            '名前',
                                          ),
                                        ),
                                        Flexible(
                                          child: BodyLargeText(
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
                                          child: BodyLargeText(
                                            '都道府県',
                                          ),
                                        ),
                                        Flexible(
                                          child: BodyLargeText(
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
                                          child: BodyLargeText(
                                            '弾数',
                                          ),
                                        ),
                                        Flexible(
                                          child: BodyLargeText(
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
                                          child: BodyLargeText(
                                            '発行年月日',
                                          ),
                                        ),
                                        Flexible(
                                          child: BodyLargeText(
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
                                              child: BodyLargeText(
                                                '配布場所',
                                              ),
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
                                                      child: BodyLargeLinkText(
                                                        contactViewData.name,
                                                      ),
                                                    ),
                                                  if (contactViewData
                                                      .nameUrl.isEmpty)
                                                    BodyLargeText(
                                                      contactViewData.name,
                                                    ),
                                                  BodyLargeText(
                                                    contactViewData.address,
                                                  ),
                                                  BodyLargeText(
                                                    contactViewData.phoneNumber,
                                                  ),
                                                  BodyLargeText(
                                                    contactViewData.other,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  BodyLargeText(
                                                    contactViewData.time,
                                                  ),
                                                  BodyLargeText(
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
                                          child: BodyLargeText('在庫状況'),
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
                                                    if (await canLaunchUrl(
                                                        uri)) {
                                                      launchUrl(
                                                        uri,
                                                        mode: LaunchMode
                                                            .inAppWebView,
                                                      );
                                                    }
                                                  },
                                                  child: BodyLargeLinkText(
                                                    viewModel.viewData
                                                        .distributionLinkText,
                                                  ),
                                                ),
                                              BodyLargeText(
                                                viewModel
                                                    .viewData.distributionText,
                                              ),
                                              BodyLargeText(
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
                                          16, 0, 16, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await ref
                                              .read(
                                                  detailViewModelProvider(key))
                                              .onTapCheckWithMapButton();
                                        },
                                        child: SizedBox(
                                          height: 48,
                                          child: Center(
                                            child: TitleMediumText(
                                              'マップで見る',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await ref
                                              .read(
                                                  detailViewModelProvider(key))
                                              .onTapAlreadyGetButton();
                                        },
                                        child: SizedBox(
                                          height: 48,
                                          child: Center(
                                            child: TitleMediumText(
                                              viewModel
                                                  .alreadyGetActionButtonTitle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(detailViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(detailViewModelProvider(key)).onCameBack();
  }
}
