import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/view_model/image_detail_view_model.dart';
import 'package:app/src/widget/image_detail.dart';

class ImageDetailPage extends HookConsumerWidget {
  const ImageDetailPage({
    super.key,
    required this.cardId,
    required this.alreadyGet,
    required this.heroTag,
  });

  final String cardId;
  final bool alreadyGet;
  final String heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(imageDetailViewModelProvider(cardId));
    final viewModel = ref.read(imageDetailViewModelProvider(cardId).notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return ImageDetail(
      cardId: cardId,
      alreadyGet: alreadyGet,
      imageTag: heroTag,
    );
  }
}
