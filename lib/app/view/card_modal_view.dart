import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manhole_card_navi/app/view_data/modal_card_view_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/view_model/card_modal_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class CardModalView extends CommonWidget {
  const CardModalView({
    super.key,
    required this.cardId,
    required this.position,
  });

  final String cardId;
  final LatLng position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(cardModalViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(cardModalViewModelProvider(key)).onLoad(
                  cardId,
                  position,
                );
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                      ...viewModel.viewData.contacts.map(
                        (contactViewData) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              16,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      if (contactViewData.nameUrl.isNotEmpty)
                                        TextButton(
                                          onPressed: () async {
                                            final uri = Uri.parse(
                                                contactViewData.nameUrl);
                                            if (await canLaunchUrl(uri)) {
                                              launchUrl(
                                                uri,
                                                mode: LaunchMode.inAppWebView,
                                              );
                                            }
                                          },
                                          child: BodyLargeLinkText(
                                            contactViewData.name,
                                          ),
                                        ),
                                      if (contactViewData.nameUrl.isEmpty)
                                        BodyLargeText(
                                          contactViewData.name,
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
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: BodyLargeText(
                                '在庫状況',
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (viewModel
                                      .viewData.distributionLinkText.isNotEmpty)
                                    TextButton(
                                      onPressed: () async {
                                        final uri = Uri.parse(viewModel
                                            .viewData.distributionLinkUrl);
                                        if (await canLaunchUrl(uri)) {
                                          launchUrl(
                                            uri,
                                            mode: LaunchMode.inAppWebView,
                                          );
                                        }
                                      },
                                      child: BodyLargeLinkText(
                                        viewModel.viewData.distributionLinkText,
                                      ),
                                    ),
                                  BodyLargeText(
                                    viewModel.viewData.distributionText,
                                  ),
                                  BodyLargeText(
                                    viewModel.viewData.distributionOther,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              await openGoogleMap(
                                viewModel.viewData,
                              );
                            } else if (Platform.isIOS) {
                              await showSelectMapModal(
                                context,
                                viewModel.viewData,
                              );
                            }
                          },
                          child: TitleMediumText(
                            '別アプリで開く',
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: OutlinedButton(
                                onPressed: () async {
                                  await ref
                                      .read(cardModalViewModelProvider(key))
                                      .onTapDetailButton();
                                },
                                child: SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: TitleMediumText(
                                      '詳細を見る',
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: OutlinedButton(
                                onPressed: () async {
                                  await ref
                                      .read(cardModalViewModelProvider(key))
                                      .onTapAlreadyGetButton();
                                },
                                child: SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: TitleMediumText(
                                      viewModel.alreadyGetActionButtonTitle,
                                      color: Theme.of(context).primaryColor,
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
          ),
        ),
      ),
    );
  }

  Future<void> showSelectMapModal(
    BuildContext context,
    ModalCardViewData viewData,
  ) async {
    showModalBottomSheet<int>(
      context: context,
      builder: (modalContext) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const TitleMediumText(
                    'Apple Map で開く',
                  ),
                  tileColor: Colors.transparent,
                  onTap: () async {
                    Navigator.of(modalContext).pop();
                    await openAppleMap(viewData);
                  },
                ),
                ListTile(
                  title: const TitleMediumText(
                    'Google Map で開く',
                  ),
                  tileColor: Colors.transparent,
                  onTap: () async {
                    Navigator.of(modalContext).pop();
                    await openGoogleMap(viewData);
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
  }

  Future<void> openGoogleMap(ModalCardViewData viewData) async {
    final uri = Uri(
      scheme: 'https',
      host: 'maps.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '${viewData.latitude},${viewData.longitude}',
      },
    );
    if (await canLaunchUrl(uri)) {
      launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> openAppleMap(ModalCardViewData viewData) async {
    final uri = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      queryParameters: {
        'q': viewData.name,
        'll': '${viewData.latitude},${viewData.longitude}',
      },
    );
    if (await canLaunchUrl(uri)) {
      launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(cardModalViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(cardModalViewModelProvider(key)).onCameBack();
  }
}
