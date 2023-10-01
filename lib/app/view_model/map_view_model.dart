import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/view_data/map_marker_view_data.dart';

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
  late CameraPosition currentCameraPosition = const CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.5,
  );
  final List<MapMarkerViewData> markersViewData = [];

  Future<void> onLoad() async {
    _logger.d('MapViewModel');
  }

  Future<void> setGoogleMapController(GoogleMapController controller) async {
    mapController = controller;
  }

  Future<void> onTapCurrentLocationButton() async {
    final position = await Geolocator.getCurrentPosition();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 12.5,
        ),
      ),
    );
  }

  void onTap() {
    notifyListeners();
  }

  Future<void> onTapMarker(String markerId) async {}

  @override
  void dispose() {
    super.dispose();
    _logger.d('MapViewModel dispose');
  }
}
