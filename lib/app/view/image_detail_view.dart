import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/image_detail_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/image_detail.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class ImageDetailView extends CommonWidget {
  const ImageDetailView({
    super.key,
    required this.cardId,
    required this.imageUrl,
    required this.imageTag,
  });

  final String cardId;
  final String imageUrl;
  final String imageTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(imageDetailViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(imageDetailViewModelProvider(key)).onLoad(cardId);
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
        child: ImageDetail(
          imageUrl: imageUrl,
          imageTag: imageTag,
        ),
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(imageDetailViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(imageDetailViewModelProvider(key)).onCameBack();
  }
}
