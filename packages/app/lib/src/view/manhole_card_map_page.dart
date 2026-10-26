import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/use_screen_view.dart';
import '../view_model/manhole_card_map_view_model.dart';
import '../widget/app_bar_title.dart';

final _initialCameraPosition = CameraPosition(
  target: LatLng(
    ManholeCardMapViewModel.initialCamera.latitude,
    ManholeCardMapViewModel.initialCamera.longitude,
  ),
  zoom: ManholeCardMapViewModel.initialCamera.zoom,
);

/// マップタブ。
class ManholeCardMapPage extends HookConsumerWidget {
  const ManholeCardMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(manholeCardMapViewModelProvider);
    final viewModel = ref.read(manholeCardMapViewModelProvider.notifier);
    final mapController = useRef<GoogleMapController?>(null);

    useScreenView(ref, viewModel.sendScreenView);
    ref.listen(
      manholeCardMapViewModelProvider.select((state) => state.cameraMove),
      (previous, next) {
        final controller = mapController.value;
        if (next == null || controller == null) {
          return;
        }
        // 中心だけを動かし、ズームは利用者が合わせたままにする。
        final update = CameraUpdate.newLatLng(
          LatLng(next.latitude, next.longitude),
        );
        unawaited(
          next.animated
              ? controller.animateCamera(update)
              : controller.moveCamera(update),
        );
      },
    );
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await viewModel.onLoad();
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(state.navigationTitle),
        actions: <Widget>[
          IconButton(
            tooltip: '検索条件',
            icon: Badge.count(
              count: state.activeFilterCount,
              isLabelVisible: state.activeFilterCount > 0,
              child: const Icon(Icons.tune),
            ),
            onPressed: viewModel.onTapSearchCondition,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // モーダルはこの表示エリアの 2/3 を占めるため、マップを残り 1/3 に
          // 縮めて、ピンが見えている範囲の中央に来るようにする。
          // build 中に状態を変えられないので、描画後に高さを渡す。
          if (constraints.maxHeight != state.mapAreaHeight) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.setMapAreaHeight(constraints.maxHeight);
            });
          }
          return Stack(
            children: [
              Container(color: Theme.of(context).colorScheme.surface),
              Column(
                children: [
                  Flexible(
                    child: GoogleMap(
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (controller) async {
                        mapController.value = controller;
                        await viewModel.updateMyLocationEnabled();
                      },
                      mapToolbarEnabled: false,
                      mapType: MapType.normal,
                      minMaxZoomPreference: const MinMaxZoomPreference(5, 17),
                      rotateGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      tiltGesturesEnabled: false,
                      myLocationEnabled: state.myLocationEnabled,
                      myLocationButtonEnabled: false,
                      markers:
                          state.markers.map((viewData) {
                            return Marker(
                              markerId: MarkerId(viewData.id),
                              icon: BitmapDescriptor.bytes(viewData.icon),
                              position: LatLng(
                                viewData.latitude,
                                viewData.longitude,
                              ),
                              onTap: () => viewModel.onTapMarker(viewData.id),
                            );
                          }).toSet(),
                      onCameraMove:
                          (position) => viewModel.onCameraMove(
                            latitude: position.target.latitude,
                            longitude: position.target.longitude,
                          ),
                      onCameraIdle: viewModel.onCameraIdle,
                    ),
                  ),
                  if (state.isShowingCardModal)
                    SizedBox(height: state.modalHeight),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.onTapCurrentLocationButton,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        shape: CircleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            width: 2,
          ),
        ),
        elevation: 0.0,
        focusElevation: 0.0,
        hoverElevation: 0.0,
        highlightElevation: 0.0,
        disabledElevation: 0.0,
        child: const Icon(Icons.near_me_outlined),
      ),
    );
  }
}
