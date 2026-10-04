import 'dart:async';
import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/map_coordinate_type_name_mapper.dart';
import '../mapper/map_markers_view_data_mapper.dart';
import '../mapper/marker_icon_mapper.dart';
import '../router/app_router.dart';
import '../router/current_route.dart';
import '../router/navigation_service.dart';
import '../view_data/manhole_card_map_view_data.dart';
import '../view_data/map_marker_view_data.dart';
import '../view_data/map_markers_view_data.dart';

final manholeCardMapViewModelProvider = NotifierProvider.autoDispose<
  ManholeCardMapViewModel,
  ManholeCardMapViewData
>(ManholeCardMapViewModel.new);

/// マップタブの ViewModel。
class ManholeCardMapViewModel
    extends AutoDisposeNotifier<ManholeCardMapViewData> {
  static const initialCameraPosition = CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.0,
  );

  late final AlreadyGetCardUseCase _alreadyGetCardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final CardUseCase _cardUseCase;
  late final LocationUseCase _locationUseCase;
  late final NavigationService _navigationService;
  late final SearchConditionUseCase _searchConditionUseCase;

  GoogleMapController? _mapController;

  /// マーカー生成の世代番号。生成中に新しい再読み込みが始まったら、古い世代の
  /// プログレッシブ通知・最終結果を破棄するために使う。
  int _markerGeneration = 0;

  SearchCondition _searchCondition = SearchCondition.initial();

  MapCoordinateType get _coordinateType => _searchCondition.map.coordinateType;

  /// 座標の種別ごとのピン。カードを読み込むまでは空。
  Map<MapCoordinateType, List<CardPin>> _pins = {};

  List<CardPin> get _currentPins => _pins[_coordinateType] ?? const [];
  Set<String> _alreadyGetCardIds = {};
  double _zoom = initialCameraPosition.zoom;
  LatLng _position = initialCameraPosition.target;

  /// マップタブで最後に表示していた画面のパス。
  String? _mapLocation;

  /// 最後にマーカー再生成した「座標種別 + 絞り込み条件 + 中心座標」。同じ状態での
  /// 重複再生成を防ぐ。
  String? _lastReloadKey;

  @override
  ManholeCardMapViewData build() {
    _alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _cardUseCase = ref.watch(cardUseCaseProvider);
    _locationUseCase = ref.watch(locationUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);
    _searchConditionUseCase = ref.watch(searchConditionUseCaseProvider);

    ref.listen(currentRouteProvider, (previous, next) => _onRouteChanged(next));
    // 起動時に下タブが許可を求める。答えが出たら現在地の表示を切り替える。
    final subscription = _locationUseCase.watchPermissionGranted().listen(
      _setMyLocationEnabled,
    );
    ref.onDispose(subscription.cancel);
    return ManholeCardMapViewData(
      navigationTitle: MapCoordinateTypeNameMapper.mapTitleOf(_coordinateType),
    );
  }

  Future<void> onLoad() async {
    // 枠 PNG のデコードを先行させ、最初のマーカー合成の待ちを減らす。
    // 初期化フローを塞がないよう await しない。
    unawaited(MarkerIconMapper.preloadFrames());
    await _loadSearchCondition();
    await _fetchCards();
    await _reloadMarkerViewData();
    _listenAlreadyGetCard();
    _listenSearchCondition();
  }

  /// 検索条件画面へ遷移する。
  Future<void> onTapSearchCondition() async {
    await _navigationService.presentSearchCondition();
  }

  void setGoogleMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void setMapAreaHeight(double height) {
    if (state.mapAreaHeight == height) {
      return;
    }
    state = state.copyWith(mapAreaHeight: height);
  }

  Future<void> updateMyLocationEnabled() async {
    final result = await _locationUseCase.isPermissionGranted();
    await _setMyLocationEnabled(result is Success<bool> && result.value);
  }

  Future<void> onTapCurrentLocationButton() async {
    if (!state.myLocationEnabled ||
        await _moveToCurrentLocation(false) == _CurrentLocation.unavailable) {
      await _navigationService.showAlert(
        title: 'エラー',
        message: '位置情報を取得できません。設定を変更してください。',
      );
    }
  }

  Future<void> onTapMarker(String markerId) async {
    final markerViewData = state.markers.getByMarkerId(markerId);
    if (markerViewData == null) {
      await _navigationService.showAlert(
        title: 'エラー',
        message: 'カード情報の取得に失敗しました',
      );
      return;
    }
    // カメラの移動は、モーダルの表示を検知した _onRouteChanged が行う。
    _navigationService.presentCardModal(
      cardId: markerViewData.cardId,
      latitude: markerViewData.latitude,
      longitude: markerViewData.longitude,
    );
  }

  Future<void> onCameraMove(CameraPosition position) async {
    _zoom = position.zoom;
    final latitudeDistance =
        (_position.latitude - position.target.latitude).abs();
    final longitudeDistance =
        (_position.longitude - position.target.longitude).abs();
    if (latitudeDistance * latitudeDistance +
            longitudeDistance * longitudeDistance >
        0.01) {
      _position = position.target;
      await _reloadMarkerViewData();
    }
  }

  Future<void> onCameraIdle() async {
    await _reloadMarkerViewData();
  }

  /// 表示中の座標種別で、カードのピンの位置を返す。見つからなければ null。
  ///
  /// 配布場所マップでは 1 枚のカードに複数のピンがあるため、最初のピンを返す。
  Future<LatLng?> _findCardPosition(String cardId) async {
    await _fetchCards();
    final pin = _currentPins.where((pin) => pin.card.id == cardId).firstOrNull;
    if (pin == null) {
      return null;
    }
    return LatLng(pin.coordinate.latitude, pin.coordinate.longitude);
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: AnalyticsEvent.screenView(
        screenName: 'manhole_card_map_view',
        parameters: {
          'coordinate_type': _coordinateType.name,
          'active_filter_count': state.activeFilterCount,
        },
      ),
    );
  }

  /// マップタブの画面遷移に合わせて、表示エリアの縮小とカメラの移動を行う。
  Future<void> _onRouteChanged(CurrentRoute? route) async {
    // 他のタブや、タブの外に積んだ画面へ移ったときは、マップタブの状態は変わらない。
    if (route == null || !route.matchedLocation.startsWith(AppRoutePath.map)) {
      return;
    }
    final previousLocation = _mapLocation;
    final location = route.matchedLocation;
    _mapLocation = location;

    final isShowingCardModal = location.startsWith(
      AppRoutePath.cardModalPrefix,
    );
    if (state.isShowingCardModal != isShowingCardModal) {
      state = state.copyWith(isShowingCardModal: isShowingCardModal);
    }
    final cardId = route.pathParameters['cardId'];
    if (!isShowingCardModal || cardId == null) {
      return;
    }

    // 同じカードのモーダルと詳細の間を行き来しただけなら、カメラは動かさない。
    final cardModalLocation = AppRoutePath.cardModal(cardId);
    if (previousLocation == cardModalLocation ||
        (previousLocation?.startsWith('$cardModalLocation/') ?? false)) {
      return;
    }

    final pin = AppRoutePath.pinOf(route.uri);
    if (pin != null) {
      // ピンをタップして開いたときは、ピンが見えている範囲の中央へ滑らかに動かす。
      await _moveToLocation(LatLng(pin.latitude, pin.longitude), true);
      return;
    }

    // カード詳細の「マップで見る」から開いたときは、カードの位置へすぐ動かす。
    final position = await _findCardPosition(cardId);
    if (position == null) {
      await _navigationService.showAlert(
        title: 'エラー',
        message: 'カード情報の取得に失敗しました',
      );
      return;
    }
    await _moveToLocation(position, false);
  }

  Future<void> _loadSearchCondition() async {
    _applySearchCondition(await _searchConditionUseCase.watch().first);
  }

  void _applySearchCondition(SearchCondition condition) {
    _searchCondition = condition;
    state = state.copyWith(
      navigationTitle: MapCoordinateTypeNameMapper.mapTitleOf(
        condition.map.coordinateType,
      ),
      activeFilterCount: condition.activeFilterCount,
    );
  }

  /// カードをまだ読み込んでいなければ読み込み、座標の種別ごとのピンを作る。
  Future<void> _fetchCards() async {
    if (_pins.isNotEmpty) {
      return;
    }
    final result = await _cardUseCase.fetchAll();
    if (result case Failure(:final exception)) {
      await _navigationService.showFailure(
        title: 'カード情報を取得できませんでした',
        exception: exception,
      );
      return;
    }
    final cards = (result as Success<List<ManholeCard>>).value;
    _pins = {
      for (final coordinateType in MapCoordinateType.values)
        coordinateType: MapMarkersViewDataMapper.toPins(cards, coordinateType),
    };
  }

  void _listenAlreadyGetCard() {
    final subscription = _alreadyGetCardUseCase.watch().listen((cardIds) async {
      _alreadyGetCardIds = cardIds;
      // 取得済みが変わるとアイコンの見た目も変わるので、必ず作り直す。
      _lastReloadKey = null;
      await _reloadMarkerViewData();
    });
    ref.onDispose(subscription.cancel);
  }

  void _listenSearchCondition() {
    final subscription = _searchConditionUseCase.watch().listen((
      condition,
    ) async {
      // タイトル・フィルタバッジを更新する。
      _applySearchCondition(condition);
      // 起動時に読み込めていなければ、ここで読み込み直す。
      await _fetchCards();
      await _reloadMarkerViewData();
    });
    ref.onDispose(subscription.cancel);
  }

  Future<void> _reloadMarkerViewData() async {
    final reloadKey =
        '${_coordinateType.name}_${_searchCondition.common.hashCode}_'
        '${_position.latitude}_${_position.longitude}';
    if (reloadKey == _lastReloadKey) {
      return;
    }
    _lastReloadKey = reloadKey;

    final generation = ++_markerGeneration;
    final pins = MapMarkersViewDataMapper.selectNearest(
      pins: _currentPins,
      searchCondition: _searchCondition.common,
      alreadyGetCardIds: _alreadyGetCardIds,
      center: Coordinate(
        latitude: _position.latitude,
        longitude: _position.longitude,
      ),
    );

    // できたものから順に地図へ反映する。30 枚そろうまで待つと、地図がしばらく
    // ピンのないまま残る。
    final markers = <MapMarkerViewData>[];
    await Future.wait(
      pins.map((pin) async {
        final icon = await _buildIcon(pin);
        // 生成中に新しい再読み込みが始まっていたら、古い世代の結果は捨てる。
        if (icon == null || generation != _markerGeneration) {
          return;
        }
        markers.add(MapMarkersViewDataMapper.toMarker(pin: pin, icon: icon));
        state = state.copyWith(
          markers: MapMarkersViewData(list: List.of(markers)),
        );
      }),
    );
    // 1 枚もできなくても最新世代なら反映する（近傍にマーカーが無い領域へ移動した
    // ときに古いマーカーを消すため）。
    if (generation == _markerGeneration) {
      state = state.copyWith(markers: MapMarkersViewData(list: markers));
    }
  }

  /// 取れなかった・合成できなかったカードは、そのピンを立てない。
  Future<Uint8List?> _buildIcon(CardPin pin) async {
    final Uint8List original;
    switch (await _cardUseCase.fetchImage(cardId: pin.card.id)) {
      case Failure():
        return null;
      case Success(:final value):
        original = value;
    }
    try {
      return await MarkerIconMapper.toIcon(
        originalBytes: original,
        distributionState: pin.card.distributionState,
        alreadyGet: _alreadyGetCardIds.contains(pin.card.id),
      );
    } on Exception {
      // 壊れた画像はデコードできない。Error はバグなので捨てずに流す。
      return null;
    }
  }

  Future<void> _setMyLocationEnabled(bool enabled) async {
    state = state.copyWith(myLocationEnabled: enabled);
    await _moveToCurrentLocation(false);
  }

  /// 現在地へカメラを動かす。動かせなかったときは、その理由を返す。
  Future<_CurrentLocation> _moveToCurrentLocation(bool animation) async {
    if (!state.myLocationEnabled) {
      return _CurrentLocation.unavailable;
    }
    switch (await _locationUseCase.getCurrentLocation()) {
      case Failure():
        return _CurrentLocation.failed;
      case Success(value: null):
        return _CurrentLocation.unavailable;
      case Success(value: final coordinate?):
        await _moveToLocation(
          LatLng(coordinate.latitude, coordinate.longitude),
          animation,
        );
        return _CurrentLocation.moved;
    }
  }

  Future<void> _moveToLocation(LatLng latLng, bool animation) async {
    final cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: _zoom),
    );
    if (animation) {
      await _mapController?.animateCamera(cameraUpdate);
    } else {
      await _mapController?.moveCamera(cameraUpdate);
    }
    _position = latLng;
    await _reloadMarkerViewData();
  }
}

/// 現在地へカメラを動かした結果。
enum _CurrentLocation {
  moved,

  /// 端末の位置情報がオフ・許可されていない。
  unavailable,

  /// 取得に失敗した（タイムアウトなど）。
  failed,
}
