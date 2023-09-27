import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        body: GoogleMap(
          onMapCreated: (controller) async {
            ref
                .read(mapViewModelProvider(key))
                .setGoogleMapController(controller);
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(35.80099213322445, 139.71850198834352),
            zoom: 17.0,
          ),
          markers: viewModel.markersViewData.map(
            (viewData) {
              return Marker(
                markerId: MarkerId(
                  viewData.id,
                ),
              );
            },
          ).toSet(),
        ),
      ),
    );
  }
}
