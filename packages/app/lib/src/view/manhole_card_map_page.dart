import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/shell_scaffold.dart';
import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/view/card_modal_page.dart';
import 'package:app/src/view_model/manhole_card_map_view_model.dart';
import 'package:app/src/widget/app_bar_title.dart';

final _initialCameraPosition = CameraPosition(
  target: LatLng(
    ManholeCardMapViewModel.initialCamera.latitude,
    ManholeCardMapViewModel.initialCamera.longitude,
  ),
  zoom: ManholeCardMapViewModel.initialCamera.zoom,
);

// カードのモーダルのシートが出てくる・閉じるのと同じ長さと曲線（Flutter の
// BottomSheet の既定値）で、地図の padding を動かす。
const _cardModalEnterDuration = Duration(milliseconds: 250);
const _cardModalExitDuration = Duration(milliseconds: 200);

class ManholeCardMapPage extends HookConsumerWidget {
  const ManholeCardMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(manholeCardMapViewModelProvider);
    final viewModel = ref.read(manholeCardMapViewModelProvider.notifier);
    final mapController = useRef<GoogleMapController?>(null);
    // padding を動かす間は毎フレーム GoogleMap を作り直すので、ピンは同じものを渡す。
    final markers = useMemoized(
      () =>
          state.markers.map((viewData) {
            return Marker(
              markerId: MarkerId(viewData.id),
              icon: BitmapDescriptor.bytes(viewData.icon),
              position: LatLng(viewData.latitude, viewData.longitude),
              // 押したときに地図が自分でカメラを動かさないようにする。地図の動きと
              // padding の変化が重なると、iOS ではカメラが押す前の位置へ戻る。
              consumeTapEvents: true,
              onTap: () => viewModel.onTapMarker(viewData.id),
            );
          }).toSet(),
      [state.markers],
    );

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
          // モーダルが覆う分を地図の padding にして、ピンを見えている範囲の中央に出す。
          // 地図の大きさは変えないので、Google のロゴも見えている範囲に動く。
          // モーダルがないときも、下タブの丸がはみ出す分は空けてロゴを隠さない。
          return TweenAnimationBuilder<double>(
            tween: Tween(
              end:
                  state.isShowingCardModal
                      ? CardModalPage.heightIn(constraints.maxHeight)
                      : ShellScaffold.tabBarOverlap,
            ),
            duration:
                state.isShowingCardModal
                    ? _cardModalEnterDuration
                    : _cardModalExitDuration,
            curve: Easing.legacyDecelerate,
            builder: (context, bottomPadding, _) {
              return GoogleMap(
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
                markers: markers,
                onCameraMove:
                    (position) => viewModel.onCameraMove(
                      latitude: position.target.latitude,
                      longitude: position.target.longitude,
                    ),
                onCameraIdle: viewModel.onCameraIdle,
                padding: EdgeInsets.only(bottom: bottomPadding),
              );
            },
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
