import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final detailViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<DetailViewModel, Key?>(
  (ref, key) {
    return DetailViewModel(
      key,
      ref,
    );
  },
);

class DetailViewModel extends ChangeNotifier {
  DetailViewModel(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  Future<void> onLoad() async {
    _logger.d('DetailViewModel');
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('DetailViewModel dispose');
  }
}
