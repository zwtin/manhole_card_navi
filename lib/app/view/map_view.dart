import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/provider/location_permission_provider.dart';
import '/app/provider/map_modal_provider.dart';
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

    ref.listen(
      mapModalProvider,
      (previous, next) async {
        if (next) {
          await showCardModal(ref, context);
        }
      },
    );

    useOnAppLifecycleStateChange((previous, current) {
      Logger().d('did change to $current');
    });

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
                markers: viewModel.markers.toSet(),
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

  Future<void> showCardModal(WidgetRef ref, BuildContext context) async {
    final result = await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
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
                ],
              ),
            );
          },
        ) ??
        false;
    ref.read(mapViewModelProvider(key)).onCloseMarkerModal(result);
  }
}
