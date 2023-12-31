import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/provider/location_permission_provider.dart';
import '/app/provider/map_modal_provider.dart';
import '/app/view_data/map_modal_card_view_data.dart';
import '/app/view_model/manhole_card_map_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';

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
      pop: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TitleLargeText(
            'マップ',
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
                              leading: viewModel.mapState == MapState.position
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : const SizedBox(
                                      width: 40,
                                      height: 40,
                                    ),
                              title: const TitleMediumText(
                                '蓋マップ',
                              ),
                              tileColor: Colors.transparent,
                              onTap: () async {
                                Navigator.of(modalContext).pop();
                                ref
                                    .read(manholeCardMapViewModelProvider(key))
                                    .onChangeMapState(MapState.position);
                              },
                            ),
                            ListTile(
                              leading:
                                  viewModel.mapState == MapState.distribution
                                      ? Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : const SizedBox(
                                          width: 40,
                                          height: 40,
                                        ),
                              title: const TitleMediumText(
                                '配布場所マップ',
                              ),
                              tileColor: Colors.transparent,
                              onTap: () async {
                                Navigator.of(modalContext).pop();
                                ref
                                    .read(manholeCardMapViewModelProvider(key))
                                    .onChangeMapState(MapState.distribution);
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

    ref.read(manholeCardMapViewModelProvider(key)).updateMyLocationEnabled();
  }

  Future<void> showCardModal(
    WidgetRef ref,
    BuildContext context,
    MapModalCardViewData viewData,
  ) async {
    final _ = await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 120,
                            child: BodyLargeText(
                              '名前',
                            ),
                          ),
                          Flexible(
                            child: BodyLargeText(
                              viewData.name,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...viewData.contacts.map(
                      (contactViewData) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 120,
                                child: BodyLargeText(
                                  '配布場所',
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (contactViewData.nameUrl.isNotEmpty)
                                      TextButton(
                                        onPressed: () async {
                                          final uri = Uri.parse(
                                              contactViewData.nameUrl);
                                          if (await canLaunchUrl(uri)) {
                                            launchUrl(
                                              uri,
                                              mode: LaunchMode.inAppWebView,
                                            );
                                          }
                                        },
                                        child: BodyLargeLinkText(
                                          contactViewData.name,
                                        ),
                                      ),
                                    if (contactViewData.nameUrl.isEmpty)
                                      BodyLargeText(
                                        contactViewData.name,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 120,
                            child: BodyLargeText(
                              '在庫状況',
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (viewData.distributionLinkText.isNotEmpty)
                                  TextButton(
                                    onPressed: () async {
                                      final uri = Uri.parse(
                                          viewData.distributionLinkUrl);
                                      if (await canLaunchUrl(uri)) {
                                        launchUrl(
                                          uri,
                                          mode: LaunchMode.inAppWebView,
                                        );
                                      }
                                    },
                                    child: BodyLargeLinkText(
                                      viewData.distributionLinkText,
                                    ),
                                  ),
                                BodyLargeText(
                                  viewData.distributionText,
                                ),
                                BodyLargeText(
                                  viewData.distributionOther,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final uri = Uri(
                            scheme: 'https',
                            host: 'www.google.com',
                            path: '/maps/search/',
                            queryParameters: {
                              'api': '1',
                              'query':
                                  '${viewData.latitude},${viewData.longitude}',
                            },
                          );
                          if (await canLaunchUrl(uri)) {
                            launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: TitleMediumText(
                          'Google マップで開く',
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: OutlinedButton(
                              onPressed: () async {
                                await ref
                                    .read(manholeCardMapViewModelProvider(key))
                                    .onTapDetailButton(viewData.id);
                              },
                              child: SizedBox(
                                height: 48,
                                child: Center(
                                  child: TitleMediumText(
                                    '詳細を見る',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: StreamBuilder(
                              stream: viewData.alreadyGet,
                              builder: (_, snapshot) {
                                return OutlinedButton(
                                  onPressed: () async {
                                    ref
                                        .read(manholeCardMapViewModelProvider(
                                            key))
                                        .onTapAlreadyGetButton(
                                          viewData.id,
                                          snapshot.data ?? false,
                                        );
                                  },
                                  child: SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: TitleMediumText(
                                        snapshot.data ?? false
                                            ? '未取得に戻す'
                                            : '取得済みにする',
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
    ref.read(manholeCardMapViewModelProvider(key)).onCloseMarkerModal();
  }
}
