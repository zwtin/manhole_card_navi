import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../router/use_screen_view.dart';
import '../view_model/check_app_update_view_model.dart';

/// 起動時にアプリの強制アップデートが必要か確認する画面。
class CheckAppUpdatePage extends HookConsumerWidget {
  const CheckAppUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkAppUpdateViewModelProvider);
    final viewModel = ref.read(checkAppUpdateViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await viewModel.onLoad();
        });
        return null;
      },
      const [],
    );

    return LoadingOverlay(
      isLoading: state.isLoading,
      color: Theme.of(context).colorScheme.background,
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
