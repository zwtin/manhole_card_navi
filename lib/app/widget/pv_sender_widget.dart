import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/pv_sender_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/widget/common_widget.dart';

class PVSendWidget extends HookConsumerWidget {
  const PVSendWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      pvSendProvider,
      (previous, next) async {
        if (previous != null || next == null) {
          return;
        }
        final bottomTabKey = ref.read(tabKeyStorageProvider).getBottomTabKey();
        final selectedIndex = ref
            .read(bottomTabViewModelProvider(bottomTabKey).notifier)
            .selectedIndex;
        final selectedKey =
            ref.read(tabKeyStorageProvider).getTabKey(selectedIndex);
        ref.read(pvSenderProvider(selectedKey).notifier).send();
      },
    );
    return child;
  }
}

class PVSenderWidget<T extends CommonWidget> extends HookConsumerWidget {
  const PVSenderWidget({
    super.key,
    required this.child,
    required this.parent,
  });

  final Widget child;
  final T parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      pvSenderProvider(key),
      (previous, next) async {
        if (previous != null || next == null) {
          return;
        }
        final currentWidget = context.findAncestorWidgetOfExactType<T>();
        await currentWidget?.sendPV(ref);
      },
    );
    return child;
  }
}
