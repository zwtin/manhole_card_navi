import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/view_model/manhole_card_map_view_model.dart';
import '/use_case/use_case/already_get_card_use_case.dart';

final detailViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<DetailViewModel, Key?>(
  (ref, key) {
    return DetailViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardUseCaseProvider),
    );
  },
);

class DetailViewModel extends ChangeNotifier {
  DetailViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  String cardId = '';
  bool b = true; // 挙動確認のため仮置き

  final AlreadyGetCardUseCase _alreadyGetCardUseCase;

  Future<void> onLoad(
    String cardId,
  ) async {
    _logger.d('DetailViewModel');
    this.cardId = cardId;
  }

  Future<void> onTapShowInMap() async {
    final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
    _ref.read(bottomTabViewModelProvider(bottomTabKey)).onTap(0);
    final mapTabKey = _ref.read(tabKeyStorageProvider).getTabKey(0);
    _ref
        .read(manholeCardMapViewModelProvider(mapTabKey))
        .onTapShowMarkerModalButton(cardId);
  }

  Future<void> onTap() async {
    if (b) {
      b = false;
      saveCard();
    } else {
      b = true;
      deleteCard();
    }
  }

  Future<void> saveCard() async {
    _alreadyGetCardUseCase.save(id: cardId);
  }

  Future<void> deleteCard() async {
    _alreadyGetCardUseCase.delete(id: cardId);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('DetailViewModel dispose');
  }
}
