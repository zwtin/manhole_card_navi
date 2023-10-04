import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;

import '/app/provider/location_permission_provider.dart';
import '/app/view_model/map_view_model.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class MapView extends HookConsumerWidget {
  const MapView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(mapViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await viewModel.onLoad();
          },
        );
        return null;
      },
      const [],
    );

    ref.listen(
      locationPermissionProvider,
      (previous, next) async {
        await requestPermission(ref);
      },
    );

    return RouterWidget(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'マップ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: ColorName.main,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.white24,
              height: 1,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                ref.read(mapViewModelProvider(key)).onTap();
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Marker>>(
          future: Future.wait(
            viewModel.markersViewData.map(
              (viewData) async {
                final cardImageOrNull =
                    await img.decodeJpgFile(viewData.cardImagePath);
                final pinImageOrNull = await decodeAsset(viewData.pinImagePath);
                final cardImage = cardImageOrNull!;
                final pinImage = pinImageOrNull!;

                final cardThumbnail =
                    img.copyResize(cardImage, width: 259, height: 361);
                final pinThumbnail =
                    img.copyResize(pinImage, width: 309, height: 411);

                final mergeImage = img.Image(
                  width: 309,
                  height: 411,
                );
                img.compositeImage(
                  mergeImage,
                  pinThumbnail,
                );
                img.compositeImage(
                  mergeImage,
                  cardThumbnail,
                  dstX: 25,
                  dstY: 25,
                );
                return Marker(
                  markerId: MarkerId(viewData.id),
                  icon: BitmapDescriptor.fromBytes(
                    img.encodeJpg(mergeImage).buffer.asUint8List(),
                  ),
                  position: LatLng(
                    viewData.latitude,
                    viewData.longitude,
                  ),
                  infoWindow: InfoWindow(
                    title: viewData.title,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
          builder: (_, markerSnapshot) {
            final markers = <Marker>[];
            if (markerSnapshot.connectionState == ConnectionState.done &&
                markerSnapshot.hasData) {
              markers.addAll(markerSnapshot.data!);
            }
            return GoogleMap(
              onMapCreated: (controller) async {
                ref
                    .read(mapViewModelProvider(key))
                    .setGoogleMapController(controller);
                ref.read(mapViewModelProvider(key)).setupMyLocation();
              },
              initialCameraPosition: viewModel.currentCameraPosition,
              myLocationEnabled: viewModel.myLocationEnabled,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              mapType: MapType.normal,
              markers: markers.toSet(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ref.read(mapViewModelProvider(key)).onTapCurrentLocationButton();
          },
          backgroundColor: ColorName.main,
          foregroundColor: ColorName.background,
          shape: const CircleBorder(
            side: BorderSide(
              color: ColorName.background,
              width: 3,
            ),
          ),
          elevation: 0.0,
          focusElevation: 0.0,
          hoverElevation: 0.0,
          highlightElevation: 0.0,
          disabledElevation: 0.0,
          child: const Icon(Icons.room_outlined),
        ),
      ),
    );
  }

  Future<void> requestPermission(WidgetRef ref) async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error(
        'Location services are disabled.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
          'Location permissions are denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    ref.read(mapViewModelProvider(key)).setupMyLocation();
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
}
