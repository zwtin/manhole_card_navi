import 'dart:async';
import 'dart:typed_data';

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
// BottomSheet の既定値。開くときも閉じるときも同じ曲線を掛ける）で、地図の
// padding とカメラを動かす。
const _cardModalEnterDuration = Duration(milliseconds: 250);
const _cardModalExitDuration = Duration(milliseconds: 200);
const _cardModalCurve = Easing.legacyDecelerate;

class ManholeCardMapPage extends HookConsumerWidget {
  const ManholeCardMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(manholeCardMapViewModelProvider);
    final viewModel = ref.read(manholeCardMapViewModelProvider.notifier);
    final sheet = useAnimationController(
      duration: _cardModalEnterDuration,
      reverseDuration: _cardModalExitDuration,
      initialValue: state.isShowingCardModal ? 1 : 0,
    );
    final cameraMotion = useAnimationController(
      duration: _cardModalEnterDuration,
    );
    final camera = useMemoized(
      () => _MapCamera(sheet: sheet, motion: cameraMotion),
    );
    // BitmapDescriptor は中身で比べないので、作り直すとすべてのピンが変わった扱いに
    // なり、地図が画像を全部受け取り直す。同じ画像（ViewModel が同じインスタンスを
    // 返す）には同じものを渡し、地図に出ていないピンのものは捨てる。
    final icons = useRef(<(Uint8List, double), BitmapDescriptor>{});
    // padding を動かす間は毎フレーム GoogleMap を作り直すので、ピンは同じものを渡す。
    final markers = useMemoized(() {
      final previousIcons = icons.value;
      final currentIcons = <(Uint8List, double), BitmapDescriptor>{};
      final markers =
          state.markers.map((viewData) {
            final key = (viewData.icon, state.pinWidth);
            final icon =
                currentIcons[key] ??=
                    previousIcons[key] ??
                    BitmapDescriptor.bytes(
                      viewData.icon,
                      width: state.pinWidth,
                    );
            return Marker(
              markerId: MarkerId(viewData.id),
              icon: icon,
              position: LatLng(viewData.latitude, viewData.longitude),
              // 押したときに地図が自分でカメラを動かさないようにする。地図の動きと
              // padding の変化が重なると、iOS ではカメラが押す前の位置へ戻る。
              consumeTapEvents: true,
              onTap: () => viewModel.onTapMarker(viewData.id),
            );
          }).toSet();
      icons.value = currentIcons;
      return markers;
    }, [state.markers, state.pinWidth]);

    useScreenView(ref, viewModel.sendScreenView);
    ref.listen(
      manholeCardMapViewModelProvider.select(
        (state) => state.isShowingCardModal,
      ),
      (previous, next) {
        unawaited(next ? sheet.forward() : sheet.reverse());
      },
    );
    ref.listen(
      manholeCardMapViewModelProvider.select((state) => state.cameraMove),
      (previous, next) {
        if (next == null) {
          return;
        }
        camera.moveTo(
          LatLng(next.latitude, next.longitude),
          animated: next.animated,
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
          final closedPadding = ShellScaffold.tabBarOverlap;
          final openPadding = CardModalPage.heightIn(constraints.maxHeight);
          return AnimatedBuilder(
            animation: sheet,
            builder: (context, _) {
              final t = _cardModalCurve.transform(sheet.value);
              final bottomPadding =
                  closedPadding + (openPadding - closedPadding) * t;
              return GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) async {
                  camera.controller = controller;
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
                onCameraMove: (position) {
                  camera.onCameraMove(position.target);
                  viewModel.onCameraMove(
                    latitude: position.target.latitude,
                    longitude: position.target.longitude,
                  );
                },
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

/// 地図のカメラの中心を、padding かカメラを動かしている間、毎フレームこちらから
/// 指定し直す。
///
/// padding を変えたときの地図の動きは SDK で違う。iOS はカメラの中心を保って地図を
/// ずらし、Android は見えている場所を保つ（地図はずれず、中心が変わる）。中心を
/// こちらで決め続ければ、どちらでも地図が padding と一緒にずれ、カメラを動かした
/// 先は見えている範囲の中央になる。
class _MapCamera {
  _MapCamera({required this.sheet, required this.motion}) {
    sheet
      ..addListener(_follow)
      ..addStatusListener(_settle);
    motion
      ..addListener(_follow)
      ..addStatusListener(_settle);
  }

  /// モーダルの出し入れ。0 でモーダルがなく、1 で開いている。
  final AnimationController sheet;

  /// カメラの動き。0 で [_from]、1 で [_to] にいる。
  final AnimationController motion;

  GoogleMapController? controller;

  LatLng _from = _initialCameraPosition.target;
  LatLng _to = _initialCameraPosition.target;

  bool _isFollowScheduled = false;

  bool get _isMoving => sheet.isAnimating || motion.isAnimating;

  LatLng get _target {
    final t = _cardModalCurve.transform(motion.value);
    return LatLng(
      _from.latitude + (_to.latitude - _from.latitude) * t,
      _from.longitude + (_to.longitude - _from.longitude) * t,
    );
  }

  /// 地図が知らせてきた中心を覚える。こちらで動かしている間は使わない。Android は
  /// padding を変えると、中心が変わったと知らせてくるため。
  void onCameraMove(LatLng target) {
    if (_isMoving) {
      return;
    }
    _from = target;
    _to = target;
  }

  /// 中心だけを動かし、ズームは利用者が合わせたままにする。
  void moveTo(LatLng target, {required bool animated}) {
    _from = _target;
    _to = target;
    if (animated) {
      unawaited(motion.forward(from: 0));
    } else {
      motion.value = 1;
    }
  }

  /// シートとカメラが同じフレームで進んでも、指定するのは 1 回にする。
  void _follow() {
    if (_isFollowScheduled) {
      return;
    }
    _isFollowScheduled = true;
    scheduleMicrotask(() {
      _isFollowScheduled = false;
      unawaited(controller?.moveCamera(CameraUpdate.newLatLng(_target)));
    });
  }

  /// 組み直した GoogleMap は、padding をフレームの後のマイクロタスクで送る。最後の
  /// フレームの padding はカメラより後に届き、Android はそこで中心がずれるので、
  /// 届き終えてからもう一度合わせる。
  void _settle(AnimationStatus status) {
    if (_isMoving) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => Timer.run(_follow));
  }
}
