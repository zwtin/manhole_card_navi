import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_data/map_modal_card_view_data.dart';

final mapModalProvider =
    StateNotifierProvider.autoDispose<MapModalNotifier, MapModalCardViewData?>(
  (ref) {
    return MapModalNotifier();
  },
);

class MapModalNotifier extends StateNotifier<MapModalCardViewData?> {
  MapModalNotifier() : super(null);

  void present({
    required MapModalCardViewData viewData,
  }) {
    state = viewData;
  }

  void dismiss() {
    state = null;
  }
}
