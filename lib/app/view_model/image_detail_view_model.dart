import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

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
    sendPV();
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

  @override
  void dispose() {
    super.dispose();
    _logger.d('ImageDetailViewModel dispose');
  }
}
