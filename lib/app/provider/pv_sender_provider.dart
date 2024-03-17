import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pvSenderProvider =
    StateNotifierProvider.family.autoDispose<PVSenderNotifier, bool?, Key?>(
  (ref, key) {
    return PVSenderNotifier();
  },
);

class PVSenderNotifier extends StateNotifier<bool?> {
  PVSenderNotifier() : super(null);

  void send() {
    state = true;
    state = null;
  }
}

final pvSendProvider = StateNotifierProvider.autoDispose<PVSendNotifier, bool?>(
  (ref) {
    return PVSendNotifier();
  },
);

class PVSendNotifier extends StateNotifier<bool?> {
  PVSendNotifier() : super(null);

  void send() {
    state = true;
    state = null;
  }
}
