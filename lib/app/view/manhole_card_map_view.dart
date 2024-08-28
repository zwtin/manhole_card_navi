import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/provider/location_permission_provider.dart';
import '/app/view_model/manhole_card_map_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';

class ManholeCardMapView extends CommonWidget {
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
        await ref
            .read(manholeCardMapViewModelProvider(key))
            .updateMyLocationEnabled();
      },
    );

    return PVSenderWidget(
      key: key,
      parent: this,
      child: RouterWidget(
        key: key,
        parent: this,
        pop: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: TitleLargeText(
              viewModel.navigationTitle,
              fontWeight: FontWeight.bold,
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {
                  showModalBottomSheet<int>(
                    context: context,
                    builder: (modalContext) {
                      return SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: viewModel.mapState ==
                                        MapState.distribution
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                title: const TitleMediumText(
                                  '配布場所マップ',
                                ),
                                tileColor: Colors.transparent,
                                onTap: () async {
                                  Navigator.of(modalContext).pop();
                                  ref
                                      .read(
                                          manholeCardMapViewModelProvider(key))
                                      .onChangeMapState(MapState.distribution);
                                },
                              ),
                              ListTile(
                                leading: viewModel.mapState == MapState.position
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                                title: const TitleMediumText(
                                  '蓋マップ',
                                ),
                                tileColor: Colors.transparent,
                                onTap: () async {
                                  Navigator.of(modalContext).pop();
                                  ref
                                      .read(
                                          manholeCardMapViewModelProvider(key))
                                      .onChangeMapState(MapState.position);
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                color: Theme.of(context).colorScheme.background,
              ),
              Column(
                children: [
                  Flexible(
                    child: GoogleMap(
                      initialCameraPosition: viewModel.initialCameraPosition,
                      onMapCreated: (controller) async {
                        ref
                            .read(manholeCardMapViewModelProvider(key))
                            .setGoogleMapController(controller);
                        ref
                            .read(manholeCardMapViewModelProvider(key))
                            .updateMyLocationEnabled();
                      },
                      mapToolbarEnabled: false,
                      mapType: MapType.normal,
                      minMaxZoomPreference: const MinMaxZoomPreference(5, 17),
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
                      onCameraMove: (position) async {
                        ref
                            .read(manholeCardMapViewModelProvider(key))
                            .onCameraMove(position);
                      },
                      onCameraIdle: () async {
                        ref
                            .read(manholeCardMapViewModelProvider(key))
                            .onCameraIdle();
                      },
                    ),
                  ),
                  if (viewModel.isShowModal)
                    const SizedBox(
                      height: 300, // 適した値を取得するのが難しいので、仮値
                    ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              ref
                  .read(manholeCardMapViewModelProvider(key))
                  .onTapCurrentLocationButton();
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).iconTheme.color,
            shape: CircleBorder(
              side: BorderSide(
                color: Theme.of(context).iconTheme.color ?? Colors.transparent,
                width: 2,
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
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(manholeCardMapViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {
    await ref.read(manholeCardMapViewModelProvider(key)).onCameBack();
  }
}
