import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

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

  Future<void> onLoad() async {
    _logger.d('ManholeCardListViewModel');
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
