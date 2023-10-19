import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_data/map_modal_view_data.dart';

final mapModalProvider =
    StateNotifierProvider.autoDispose<MapModalNotifier, MapModalViewData?>(
  (ref) {
    return MapModalNotifier();
  },
);

class MapModalNotifier extends StateNotifier<MapModalViewData?> {
  MapModalNotifier() : super(null);

  void present({
    required MapModalViewData viewData,
  }) {
    state = viewData;
  }

  void dismiss() {
    state = null;
  }
}
