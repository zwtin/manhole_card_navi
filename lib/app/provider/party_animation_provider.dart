import 'package:hooks_riverpod/hooks_riverpod.dart';

final partyAnimationProvider =
    StateNotifierProvider.autoDispose<PartyAnimationNotifier, bool?>(
  (ref) {
    return PartyAnimationNotifier();
  },
);

class PartyAnimationNotifier extends StateNotifier<bool?> {
  PartyAnimationNotifier() : super(null);

  void start() {
    state = true;
  }

  void finish() {
    state = null;
  }
}
