import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;

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
          ], // 影をなくす
        ),
        body: FutureBuilder<List<Marker>>(
          future: Future.wait(
            viewModel.markersViewData.map(
              (viewData) async {
                final cardImageOrNull =
                    await decodeAsset(viewData.cardImagePath);
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
          builder: (_, snapshot) {
            final markers = <Marker>[];
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              markers.addAll(snapshot.data!);
            }
            return GoogleMap(
              onMapCreated: (controller) async {
                ref
                    .read(mapViewModelProvider(key))
                    .setGoogleMapController(controller);
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(35.80099213322445, 139.71850198834352),
                zoom: 17.0,
              ),
              markers: markers.toSet(),
            );
          },
        ),
      ),
    );
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
