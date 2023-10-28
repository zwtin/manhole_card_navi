import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/view_data/list_card_view_data.dart';
import 'package:manhole_card_navi/app/view_data/list_prefecture_view_data.dart';

final manholeCardListViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<ManholeCardListViewModel, Key?>(
  (ref, key) {
    return ManholeCardListViewModel(
      key,
      ref,
    );
  },
);

class ManholeCardListViewModel extends ChangeNotifier {
  ManholeCardListViewModel(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final List<ListPrefectureViewData> prefecturesViewData = [];

  Future<void> onLoad() async {
    _logger.d('ManholeCardListViewModel');
    prefecturesViewData.addAll([
      ListPrefectureViewData(id: '00', name: '', cards: [
        ListCardViewData(
          id: '00-101-A001',
          icon: Uint8List(1),
        ),
        ListCardViewData(
          id: '00-101-A001',
          icon: Uint8List(1),
        ),
        ListCardViewData(
          id: '00-101-A001',
          icon: Uint8List(1),
        ),
      ]),
      ListPrefectureViewData(id: '01', name: '北海道', cards: [
        ListCardViewData(
          id: '00-101-A001',
          icon: Uint8List(1),
        ),
        ListCardViewData(
          id: '00-101-A001',
          icon: Uint8List(1),
        ),
      ]),
      const ListPrefectureViewData(id: '02', name: '青森県', cards: []),
      const ListPrefectureViewData(id: '03', name: '岩手県', cards: []),
      const ListPrefectureViewData(id: '04', name: '宮城県', cards: []),
      const ListPrefectureViewData(id: '05', name: '秋田県', cards: []),
      const ListPrefectureViewData(id: '06', name: '山形県', cards: []),
      const ListPrefectureViewData(id: '07', name: '福島県', cards: []),
      const ListPrefectureViewData(id: '08', name: '茨城県', cards: []),
      const ListPrefectureViewData(id: '09', name: '栃木県', cards: []),
      const ListPrefectureViewData(id: '10', name: '群馬県', cards: []),
    ]);
    notifyListeners();
  }

  Future<void> onTap() async {
    _logger.d('ManholeCardListViewModel');
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('ManholeCardListViewModel dispose');
  }
}
