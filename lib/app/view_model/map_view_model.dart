import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/view_data/map_marker_view_data.dart';

import '/app/provider/router_provider.dart';
import '/app/view/map_view.dart';

final mapViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<MapViewModel, Key?>(
  (ref, key) {
    return MapViewModel(
      key,
      ref,
    );
  },
);

class MapViewModel extends ChangeNotifier {
  MapViewModel(
    this._key,
    this._ref,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  late GoogleMapController mapController;
  final List<MapMarkerViewData> markersViewData = [];

  Future<void> onLoad() async {
    _logger.d('MapViewModel');
  }

  void setGoogleMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void onTap() {
    _ref.read(routerProvider(_key).notifier).push(
          nextWidget: MapView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> onTapMarker(String markerId) async {}

  @override
  void dispose() {
    super.dispose();
    _logger.d('MapViewModel dispose');
  }
}
