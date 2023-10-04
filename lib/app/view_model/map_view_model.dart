import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/location_permission_provider.dart';
import '/app/view_data/map_marker_view_data.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/distribution_cards_query_service_impl.dart';
import '/use_case/dto/map_card_dto.dart';
import '/use_case/query_service/distribution_cards_query_service.dart';

final mapViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<MapViewModel, Key?>(
  (ref, key) {
    return MapViewModel(
      key,
      ref,
      ref.watch(distributionCardsQueryServiceProvider),
    );
  },
);

class MapViewModel extends ChangeNotifier {
  MapViewModel(
    this._key,
    this._ref,
    this._distributionCardsQueryService,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final DistributionCardsQueryService _distributionCardsQueryService;

  late GoogleMapController mapController;
  CameraPosition currentCameraPosition = const CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.5,
  );
  bool myLocationEnabled = false;
  final List<MapMarkerViewData> markersViewData = [];

  Future<void> onLoad() async {
    _logger.d('MapViewModel');
    _ref.read(locationPermissionProvider.notifier).request();
    fetchDistributionMarker();
  }

  Future<void> setupMyLocation() async {
    myLocationEnabled = true;
    await _moveToCurrentLocation(false);
    notifyListeners();
  }

  Future<void> setGoogleMapController(GoogleMapController controller) async {
    mapController = controller;
  }

  Future<void> onTapCurrentLocationButton() async {
    await _moveToCurrentLocation(true);
  }

  Future<void> _moveToCurrentLocation(bool animation) async {
    final position = await Geolocator.getCurrentPosition();
    if (animation) {
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
    } else {
      mapController.moveCamera(
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
  }

  Future<void> fetchDistributionMarker() async {
    final result = await _distributionCardsQueryService.fetch();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dtoList = (result as Success<List<MapCardDTO>>).value;
    markersViewData.clear();
    markersViewData.addAll(
      dtoList.map(
        (dto) {
          return MapMarkerViewData(
            id: dto.id,
            title: dto.title,
            pinImagePath: dto.pinImagePath,
            cardImagePath: dto.cardImagePath,
            latitude: dto.latitude,
            longitude: dto.longitude,
          );
        },
      ),
    );
    notifyListeners();
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
