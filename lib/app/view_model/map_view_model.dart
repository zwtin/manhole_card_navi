import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

import '/app/provider/alert_provider.dart';
import '/app/provider/location_permission_provider.dart';
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
  final List<Marker> markers = [];

  Future<void> onLoad() async {
    _logger.d('MapViewModel');
    _ref.read(locationPermissionProvider.notifier).request();
    fetchDistributionMarker();
  }

  Future<void> setupMyLocation() async {
    var permission = await Geolocator.checkPermission();
    myLocationEnabled = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
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
    markers.clear();
    for (final dto in dtoList) {
      final cardImageOrNull = await img.decodeJpgFile(dto.cardImagePath);
      final pinImageOrNull = await decodeAsset(dto.pinImagePath);
      final cardImage = cardImageOrNull!;
      final pinImage = pinImageOrNull!;

      final cardThumbnail = img.copyResize(cardImage, width: 130, height: 180);
      final pinThumbnail = img.copyResize(pinImage, width: 146, height: 221);

      final mergeImage = img.Image(
        width: 146,
        height: 221,
        numChannels: 4,
      );
      img.compositeImage(
        mergeImage,
        pinThumbnail,
      );
      img.compositeImage(
        mergeImage,
        cardThumbnail,
        dstX: 8,
        dstY: 8,
      );
      markers.add(
        Marker(
          markerId: MarkerId(dto.id),
          icon: BitmapDescriptor.fromBytes(
            img.encodePng(mergeImage).buffer.asUint8List(),
          ),
          position: LatLng(
            dto.latitude,
            dto.longitude,
          ),
          onTap: () {},
        ),
      );
    }
    notifyListeners();
  }

  Future<img.Image?> decodeAsset(String path) async {
    final data = await rootBundle.load(path);

    final buffer = await ui.ImmutableBuffer.fromUint8List(
      data.buffer.asUint8List(),
    );

    final id = await ui.ImageDescriptor.encoded(buffer);
    final codec = await id.instantiateCodec(
      targetHeight: id.height,
      targetWidth: id.width,
    );

    final fi = await codec.getNextFrame();

    final uiImage = fi.image;
    final uiBytes = await uiImage.toByteData();

    final image = img.Image.fromBytes(
      width: id.width,
      height: id.height,
      bytes: uiBytes!.buffer,
      numChannels: 4,
    );
    return image;
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
