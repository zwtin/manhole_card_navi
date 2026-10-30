import 'dart:async';
import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/mapper/map_coordinate_type_name_mapper.dart';
import 'package:app/src/mapper/map_markers_view_data_mapper.dart';
import 'package:app/src/mapper/marker_icon_mapper.dart';
import 'package:app/src/router/app_router.dart';
import 'package:app/src/router/current_route.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/camera_move_view_data.dart';
import 'package:app/src/view_data/manhole_card_map_view_data.dart';
import 'package:app/src/view_data/map_marker_view_data.dart';
import 'package:domain/domain.dart';

final manholeCardMapViewModelProvider = NotifierProvider.autoDispose<
  ManholeCardMapViewModel,
  ManholeCardMapViewData
>(ManholeCardMapViewModel.new);

class ManholeCardMapViewModel
    extends AutoDisposeNotifier<ManholeCardMapViewData> {
  /// 起動時に映す場所。View の地図と、ここでピンを選ぶ中心の両方が使う。
  static const initialCamera = (
    latitude: 35.680212,
    longitude: 139.757669,
    zoom: 12.0,
  );

  AlreadyGetCardUseCase get _alreadyGetCardUseCase =>
      ref.read(alreadyGetCardUseCaseProvider);
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  CardUseCase get _cardUseCase => ref.read(cardUseCaseProvider);
  LocationUseCase get _locationUseCase => ref.read(locationUseCaseProvider);
  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);
  SearchConditionUseCase get _searchConditionUseCase =>
      ref.read(searchConditionUseCaseProvider);

  /// 控えておくピンの画像の数。1 枚 50 KB ほど。地図に出すのは 30 本までなので、
  /// 行き来する範囲のぶんを持てればよい。
  static const _iconLimit = 200;

  /// 生成中に新しい再読み込みが始まったら、古い世代の結果を捨てるための番号。
  int _markerGeneration = 0;

  /// 合成したピンの画像。ピンを選び直すたびに作ると、ほとんど同じカードが並んで
  /// いても全部を合成し直すことになる。使ったものほど後ろに並べ、上限を超えたら
  /// 先頭（長く使っていないもの）から捨てる。
  ///
  /// 同じカードには同じインスタンスを返す。View はそれを見て、地図に画像を
  /// 送り直すかを決める。
  final _icons = <_IconKey, Uint8List>{};

  /// 合成中のピンの画像。合成が終わる前にピンを選び直しても、同じ画像を 2 度
  /// 合成しない。
  final _buildingIcons = <_IconKey, Future<Uint8List?>>{};

  SearchCondition _searchCondition = SearchCondition.initial();

  MapCoordinateType get _coordinateType => _searchCondition.map.coordinateType;

  /// 座標の種別ごとのピン。カードを読み込むまでは空。
  Map<MapCoordinateType, List<CardPin>> _pins = {};

  List<CardPin> get _currentPins => _pins[_coordinateType] ?? const [];
  Set<String> _alreadyGetCardIds = {};

  /// カメラの中心。ピンはここから近いものを選ぶ。
  Coordinate _center = Coordinate(
    latitude: initialCamera.latitude,
    longitude: initialCamera.longitude,
  );

  int _cameraMoveId = 0;

  /// マップタブで最後に表示していた画面のパス。
  String? _mapLocation;

  /// 最後にマーカー再生成した「座標種別 + 絞り込み条件 + 中心座標」。同じ状態での
  /// 重複再生成を防ぐ。
  String? _lastReloadKey;

  @override
  ManholeCardMapViewData build() {
    final locationUseCase = ref.watch(locationUseCaseProvider);

    ref.listen(currentRouteProvider, (previous, next) => _onRouteChanged(next));
    // 起動時に下タブが許可を求める。答えが出たら現在地の表示を切り替える。
    final subscription = locationUseCase.watchPermissionGranted().listen(
      _setMyLocationEnabled,
    );
    ref.onDispose(subscription.cancel);
    return ManholeCardMapViewData(
      navigationTitle: MapCoordinateTypeNameMapper.mapTitleOf(_coordinateType),
      pinWidth: MapMarkersViewDataMapper.pinWidthOf(
        _searchCondition.map.pinSize,
      ),
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

  Future<void> onTapSearchCondition() async {
    await _navigationService.presentSearchCondition();
  }

  Future<void> updateMyLocationEnabled() async {
    final result = await _locationUseCase.isPermissionGranted();
    await _setMyLocationEnabled(result is Success<bool> && result.value);
  }

  Future<void> onTapCurrentLocationButton() async {
    if (!state.myLocationEnabled ||
        await _moveToCurrentLocation(animated: false) ==
            _CurrentLocation.unavailable) {
      await _navigationService.showAlert(
        title: 'エラー',
        message: '位置情報を取得できません。設定を変更してください。',
      );
    }
  }

  Future<void> onTapMarker(String markerId) async {
    final markerViewData =
        state.markers.where((marker) => marker.id == markerId).firstOrNull;
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

  Future<void> onCameraMove({
    required double latitude,
    required double longitude,
  }) async {
    final latitudeDistance = (_center.latitude - latitude).abs();
    final longitudeDistance = (_center.longitude - longitude).abs();
    if (latitudeDistance * latitudeDistance +
            longitudeDistance * longitudeDistance >
        0.01) {
      _center = Coordinate(latitude: latitude, longitude: longitude);
      await _reloadMarkerViewData();
    }
  }

  Future<void> onCameraIdle() async {
    await _reloadMarkerViewData();
  }

  /// 表示中の座標種別で、カードのピンの位置を返す。見つからなければ null。
  ///
  /// 配布場所マップでは 1 枚のカードに複数のピンがあるため、最初のピンを返す。
  Future<Coordinate?> _findCardPosition(String cardId) async {
    await _fetchCards();
    return _currentPins
        .where((pin) => pin.card.id == cardId)
        .firstOrNull
        ?.coordinate;
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

  /// マップタブの画面遷移に合わせて、モーダルを表示中かとカメラの移動を決める。
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
      await _moveCamera(
        Coordinate(latitude: pin.latitude, longitude: pin.longitude),
        animated: true,
      );
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
    await _moveCamera(position, animated: false);
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
      pinWidth: MapMarkersViewDataMapper.pinWidthOf(condition.map.pinSize),
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
        '${_center.latitude}_${_center.longitude}';
    if (reloadKey == _lastReloadKey) {
      return;
    }
    _lastReloadKey = reloadKey;

    final generation = ++_markerGeneration;
    final pins = MapMarkersViewDataMapper.selectNearest(
      pins: _currentPins,
      searchCondition: _searchCondition.common,
      alreadyGetCardIds: _alreadyGetCardIds,
      center: _center,
    );

    // できたものから順に地図へ反映する。30 枚そろうまで待つと、地図がしばらく
    // ピンのないまま残る。
    final markers = <MapMarkerViewData>[];
    await Future.wait(
      pins.map((pin) async {
        final icon = await _iconOf(pin);
        // 生成中に新しい再読み込みが始まっていたら、古い世代の結果は捨てる。
        if (icon == null || generation != _markerGeneration) {
          return;
        }
        markers.add(MapMarkersViewDataMapper.toMarker(pin: pin, icon: icon));
        state = state.copyWith(markers: List.of(markers));
      }),
    );
    // 1 枚もできなくても最新世代なら反映する（近傍にマーカーが無い領域へ移動した
    // ときに古いマーカーを消すため）。
    if (generation == _markerGeneration) {
      state = state.copyWith(markers: markers);
    }
  }

  Future<Uint8List?> _iconOf(CardPin pin) async {
    final key = (
      cardId: pin.card.id,
      alreadyGet: _alreadyGetCardIds.contains(pin.card.id),
    );
    final icon = _icons.remove(key);
    if (icon != null) {
      _icons[key] = icon;
      return icon;
    }
    return _buildingIcons[key] ??= _buildAndKeepIcon(pin, key);
  }

  Future<Uint8List?> _buildAndKeepIcon(CardPin pin, _IconKey key) async {
    try {
      final icon = await _buildIcon(pin, alreadyGet: key.alreadyGet);
      // 取れなかったものは控えず、次に選び直したときに取り直す。
      if (icon != null) {
        _icons[key] = icon;
        if (_icons.length > _iconLimit) {
          _icons.remove(_icons.keys.first);
        }
      }
      return icon;
    } finally {
      _buildingIcons.remove(key);
    }
  }

  /// 取れなかった・合成できなかったカードは、そのピンを立てない。
  ///
  /// [alreadyGet] は控えるときのキーと同じ値を渡す。合成の途中で取得済みが
  /// 変わっても、違うキーに控えないようにするため。
  Future<Uint8List?> _buildIcon(CardPin pin, {required bool alreadyGet}) async {
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
        alreadyGet: alreadyGet,
      );
    } on Exception {
      // 壊れた画像はデコードできない。Error はバグなので捨てずに流す。
      return null;
    }
  }

  Future<void> _setMyLocationEnabled(bool enabled) async {
    state = state.copyWith(myLocationEnabled: enabled);
    await _moveToCurrentLocation(animated: false);
  }

  /// 現在地へカメラを動かす。動かせなかったときは、その理由を返す。
  Future<_CurrentLocation> _moveToCurrentLocation({
    required bool animated,
  }) async {
    if (!state.myLocationEnabled) {
      return _CurrentLocation.unavailable;
    }
    switch (await _locationUseCase.getCurrentLocation()) {
      case Failure():
        return _CurrentLocation.failed;
      case Success(value: null):
        return _CurrentLocation.unavailable;
      case Success(value: final coordinate?):
        await _moveCamera(coordinate, animated: animated);
        return _CurrentLocation.moved;
    }
  }

  /// カメラは View が動かす。ピンは動かした先を中心に選び直す。
  Future<void> _moveCamera(Coordinate target, {required bool animated}) async {
    state = state.copyWith(
      cameraMove: CameraMoveViewData(
        id: ++_cameraMoveId,
        latitude: target.latitude,
        longitude: target.longitude,
        animated: animated,
      ),
    );
    _center = target;
    await _reloadMarkerViewData();
  }
}

/// ピンの画像を引くキー。配布状態はカードを読み込み直さない限り変わらないので、
/// キーに入れない。
typedef _IconKey = ({String cardId, bool alreadyGet});

/// 現在地へカメラを動かした結果。
enum _CurrentLocation {
  moved,

  /// 端末の位置情報がオフ・許可されていない。
  unavailable,

  /// 取得に失敗した（タイムアウトなど）。
  failed,
}
