import 'dart:async';

import 'package:domain/domain.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/map_markers_view_data_mapper.dart';
import '../router/app_router.dart';
import '../router/current_route.dart';
import '../service/marker_icon_builder.dart';
import '../view_data/manhole_card_map_view_data.dart';
import 'shell_view_model.dart';

final manholeCardMapViewModelProvider = NotifierProvider.autoDispose<
    ManholeCardMapViewModel, ManholeCardMapViewData>(
  ManholeCardMapViewModel.new,
);

/// マップタブの ViewModel。
class ManholeCardMapViewModel
    extends AutoDisposeNotifier<ManholeCardMapViewData> {
  static const initialCameraPosition = CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.0,
  );

  late final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  late final DistributionCardsQueryService _distributionCardsQueryService;
  late final PositionCardsQueryService _positionCardsQueryService;
  late final SearchConditionQueryService _searchConditionQueryService;
  late final AnalyticsUseCase _analyticsUseCase;
  late final LocationUseCase _locationUseCase;
  late final NavigationService _navigationService;

  GoogleMapController? _mapController;

  /// マーカー生成の世代番号。生成中に新しい再読み込みが始まったら、古い世代の
  /// プログレッシブ通知・最終結果を破棄するために使う。
  int _markerGeneration = 0;

  SearchCondition _searchCondition = SearchCondition.initial();

  MapCoordinateType get _coordinateType => _searchCondition.map.coordinateType;

  List<MapMarkerDTO> get _currentMarkerDTOList =>
      _coordinateType == MapCoordinateType.position
          ? _positionMarkerDTOList
          : _distributionMarkerDTOList;

  final List<MapMarkerDTO> _positionMarkerDTOList = [];
  final List<MapMarkerDTO> _distributionMarkerDTOList = [];
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
    _alreadyGetCardQueryService = ref.watch(alreadyGetCardQueryServiceProvider);
    _distributionCardsQueryService = ref.watch(
      distributionCardsQueryServiceProvider,
    );
    _positionCardsQueryService = ref.watch(positionCardsQueryServiceProvider);
    _searchConditionQueryService = ref.watch(
      searchConditionQueryServiceProvider,
    );
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _locationUseCase = ref.watch(locationUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    ref.listen(currentRouteProvider, (previous, next) => _onRouteChanged(next));
    ref.listen(
      locationPermissionRequestedProvider,
      (previous, next) => updateMyLocationEnabled(),
    );
    return const ManholeCardMapViewData();
  }

  Future<void> onLoad() async {
    // 枠 PNG のデコードを先行させ、最初のマーカー合成の待ちを減らす。
    // 初期化フローを塞がないよう await しない。
    unawaited(MarkerIconBuilder.preloadFrames());
    await _loadSearchCondition();
    await _fetchCurrentMarkerDTOList();
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
    state = state.copyWith(
      myLocationEnabled: result is Success<bool> && result.value,
    );
    await _moveToCurrentLocation(false);
  }

  Future<void> onTapCurrentLocationButton() async {
    if (!state.myLocationEnabled) {
      await _navigationService.showAlert(
        title: 'エラー',
        message: '位置情報を取得できません。設定を変更してください。',
      );
      return;
    }
    await _moveToCurrentLocation(false);
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
  Future<LatLng?> findCardPosition(String cardId) async {
    await _fetchCurrentMarkerDTOList();
    final dto = _currentMarkerDTOList
        .where((element) => element.cardId == cardId)
        .firstOrNull;
    if (dto == null) {
      return null;
    }
    return LatLng(dto.latitude, dto.longitude);
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'manhole_card_map_view',
        'coordinate_type': state.coordinateType.name,
        'active_filter_count': state.activeFilterCount,
      },
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

    final latitude = double.tryParse(route.uri.queryParameters['latitude'] ?? '');
    final longitude = double.tryParse(
      route.uri.queryParameters['longitude'] ?? '',
    );
    if (latitude != null && longitude != null) {
      // ピンをタップして開いたときは、ピンが見えている範囲の中央へ滑らかに動かす。
      await _moveToLocation(LatLng(latitude, longitude), true);
      return;
    }

    // カード詳細の「マップで見る」から開いたときは、カードの位置へすぐ動かす。
    final position = await findCardPosition(cardId);
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
    final result = await _searchConditionQueryService.get();
    if (result is Success<SearchCondition>) {
      _applySearchCondition(result.value);
    }
  }

  void _applySearchCondition(SearchCondition condition) {
    _searchCondition = condition;
    state = state.copyWith(
      coordinateType: condition.map.coordinateType,
      activeFilterCount: condition.activeFilterCount,
    );
  }

  /// 表示中の座標種別のピンを、未取得なら取得する。
  Future<void> _fetchCurrentMarkerDTOList() async {
    if (_coordinateType == MapCoordinateType.position) {
      await _fetchPositionMarker();
    } else {
      await _fetchDistributionMarker();
    }
  }

  Future<void> _fetchPositionMarker() async {
    if (_positionMarkerDTOList.isNotEmpty) {
      return;
    }
    final result = await _positionCardsQueryService.fetch();
    if (result case Failure(:final exception)) {
      await _navigationService.showFailure(
        title: 'カード情報を取得できませんでした',
        exception: exception,
      );
      return;
    }
    final dtoList = (result as Success<List<MapMarkerDTO>>).value;
    _positionMarkerDTOList
      ..clear()
      ..addAll(dtoList);
  }

  Future<void> _fetchDistributionMarker() async {
    if (_distributionMarkerDTOList.isNotEmpty) {
      return;
    }
    final result = await _distributionCardsQueryService.fetch();
    if (result case Failure(:final exception)) {
      await _navigationService.showFailure(
        title: 'カード情報を取得できませんでした',
        exception: exception,
      );
      return;
    }
    final dtoList = (result as Success<List<MapMarkerDTO>>).value;
    _distributionMarkerDTOList
      ..clear()
      ..addAll(dtoList);
  }

  void _listenAlreadyGetCard() {
    final subscription = _alreadyGetCardQueryService.getStream().listen((
      cardIds,
    ) async {
      final generation = ++_markerGeneration;
      final newViewData = await MapMarkersViewDataMapper.convertToViewData(
        mapMarkerDTOList: _currentMarkerDTOList,
        alreadyGetCardIds: cardIds,
        centerCoordinate: _position,
        searchCondition: _searchCondition.common,
        onPartial: (partial) {
          // 生成中に新しい再読み込みが始まっていたら古い結果は破棄する。
          if (generation != _markerGeneration) {
            return;
          }
          state = state.copyWith(markers: partial);
        },
      );
      // 空結果でも最新世代なら反映する（近傍にマーカーが無い領域へ移動した
      // ときに古いマーカーを消すため）。
      if (generation == _markerGeneration) {
        state = state.copyWith(markers: newViewData);
      }

      _alreadyGetCardIds = cardIds;
    });
    ref.onDispose(subscription.cancel);
  }

  void _listenSearchCondition() {
    final subscription = _searchConditionQueryService.getStream().listen((
      condition,
    ) async {
      // タイトル・フィルタバッジを更新する。
      _applySearchCondition(condition);
      // 座標種別が変わっていれば、対応するマーカーを遅延取得する。
      await _fetchCurrentMarkerDTOList();
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
    final newViewData = await MapMarkersViewDataMapper.convertToViewData(
      mapMarkerDTOList: _currentMarkerDTOList,
      alreadyGetCardIds: _alreadyGetCardIds,
      centerCoordinate: _position,
      searchCondition: _searchCondition.common,
      onPartial: (partial) {
        // 生成中に新しい再読み込みが始まっていたら古い結果は破棄する。
        if (generation != _markerGeneration) {
          return;
        }
        state = state.copyWith(markers: partial);
      },
    );
    // 空結果でも最新世代なら反映する（近傍にマーカーが無い領域へ移動したときに
    // 古いマーカーを消すため）。
    if (generation == _markerGeneration) {
      state = state.copyWith(markers: newViewData);
    }
  }

  Future<void> _moveToCurrentLocation(bool animation) async {
    if (!state.myLocationEnabled) {
      return;
    }
    final result = await _locationUseCase.getCurrentLocation();
    if (result is! Success<({double latitude, double longitude})>) {
      return;
    }
    await _moveToLocation(
      LatLng(result.value.latitude, result.value.longitude),
      animation,
    );
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
