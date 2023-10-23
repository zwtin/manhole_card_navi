import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/manhole_card_list_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';

class ManholeCardListView extends HookConsumerWidget {
  const ManholeCardListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(manholeCardListViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(manholeCardListViewModelProvider(key)).onLoad();
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
            'リスト',
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                ref.read(manholeCardListViewModelProvider(key)).onTap();
              },
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }
}
