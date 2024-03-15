import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/image_detail_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/image_detail.dart';

class ImageDetailView extends CommonWidget {
  const ImageDetailView({
    super.key,
    required this.cardId,
    required this.imageData,
    required this.imageTag,
  });

  final String cardId;
  final Uint8List imageData;
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

    return ImageDetail(
      imageData: imageData,
      imageTag: imageTag,
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    ref.read(imageDetailViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCloseModal(WidgetRef ref) async {}
}
