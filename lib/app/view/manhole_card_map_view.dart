import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/provider/location_permission_provider.dart';
import '/app/provider/map_modal_provider.dart';
import '/app/view_data/map_modal_view_data.dart';
import '/app/view_model/manhole_card_map_view_model.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

class ManholeCardMapView extends HookConsumerWidget {
  const ManholeCardMapView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(manholeCardMapViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(manholeCardMapViewModelProvider(key)).onLoad();
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

    ref.listen(
      mapModalProvider,
      (previous, next) async {
        if (previous == null && next != null) {
          await showCardModal(
            ref,
            context,
            next,
          );
        }
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
        ),
        body: Column(
          children: [
            Flexible(
              child: GoogleMap(
                initialCameraPosition: viewModel.currentCameraPosition,
                onMapCreated: (controller) async {
                  ref
                      .read(manholeCardMapViewModelProvider(key))
                      .setGoogleMapController(controller);
                  ref
                      .read(manholeCardMapViewModelProvider(key))
                      .setupMyLocation();
                },
                mapToolbarEnabled: false,
                mapType: MapType.normal,
                rotateGesturesEnabled: false,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
                myLocationEnabled: viewModel.myLocationEnabled,
                myLocationButtonEnabled: false,
                markers: viewModel.markersViewData.map(
                  (viewData) {
                    return Marker(
                      markerId: MarkerId(
                        viewData.id,
                      ),
                      icon: BitmapDescriptor.fromBytes(
                        viewData.icon,
                      ),
                      position: LatLng(
                        viewData.latitude,
                        viewData.longitude,
                      ),
                      onTap: () {
                        ref
                            .read(manholeCardMapViewModelProvider(key))
                            .onTapMarker(viewData.id);
                      },
                    );
                  },
                ).toSet(),
              ),
            ),
            if (viewModel.isShowModal)
              const SizedBox(
                height: 400,
                width: double.infinity,
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ref
                .read(manholeCardMapViewModelProvider(key))
                .onTapCurrentLocationButton();
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

    ref.read(manholeCardMapViewModelProvider(key)).setupMyLocation();
  }

  Future<void> showCardModal(
    WidgetRef ref,
    BuildContext context,
    MapModalViewData viewData,
  ) async {
    final _ = await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SizedBox(
              height: 400,
              child: Column(
                children: [
                  SizedBox(
                    width: 155.1,
                    height: 216.6,
                    child: Container(),
                  ),
                  const Text('data'),
                  const Text('data2'),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final uri = Uri(
                        scheme: 'https',
                        host: 'www.google.com',
                        path: '/maps/search/',
                        queryParameters: {
                          'api': '1',
                          'query': '${viewData.latitude},${viewData.longitude}',
                        },
                      );
                      if (await canLaunchUrl(uri)) {
                        launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: const Text('Googleマップで開く'),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
    ref.read(manholeCardMapViewModelProvider(key)).onCloseMarkerModal();
  }
}
