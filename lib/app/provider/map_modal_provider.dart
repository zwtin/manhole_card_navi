import 'package:hooks_riverpod/hooks_riverpod.dart';

final mapModalProvider =
    StateNotifierProvider.autoDispose<MapModalNotifier, bool>(
  (ref) {
    return MapModalNotifier();
  },
);

class MapModalNotifier extends StateNotifier<bool> {
  MapModalNotifier() : super(false);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}
