import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/pv_sender_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/use_case/use_case/analytics_use_case.dart';

final imageDetailViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<ImageDetailViewModel, Key?>(
  (ref, key) {
    return ImageDetailViewModel(
      key,
      ref,
      ref.watch(analyticsUseCaseProvider),
    );
  },
);

class ImageDetailViewModel extends ChangeNotifier {
  ImageDetailViewModel(
    this._key,
    this._ref,
    this._analyticsUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AnalyticsUseCase _analyticsUseCase;

  String _cardId = '';

  Future<void> onLoad(
    String cardId,
  ) async {
    _cardId = cardId;
    await onCameBack();
  }

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'image_detail_view',
        'card_id': _cardId,
      },
    );
  }

  Future<void> onCameBack() async {
    final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
    final selectedIndex = _ref
        .read(bottomTabViewModelProvider(bottomTabKey).notifier)
        .selectedIndex;
    _ref.read(tabKeyStorageProvider).setTabKey(selectedIndex, _key);
    _ref.read(pvSendProvider.notifier).send();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('ImageDetailViewModel dispose');
  }
}
