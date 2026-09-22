import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/app_router.dart';
import '../router/use_screen_view.dart';
import '../view_model/image_detail_view_model.dart';
import '../widget/image_detail.dart';

/// カード画像の拡大表示。
class ImageDetailPage extends HookConsumerWidget {
  const ImageDetailPage({
    super.key,
    required this.args,
  });

  final ImageDetailArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(imageDetailViewModelProvider(args.cardId));
    final viewModel = ref.read(
      imageDetailViewModelProvider(args.cardId).notifier,
    );

    useScreenView(ref, viewModel.sendScreenView);

    return ImageDetail(
      cardId: args.cardId,
      alreadyGet: args.alreadyGet,
      imageTag: args.heroTag,
    );
  }
}
