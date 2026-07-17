import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/mapper/map_markers_view_data_mapper.dart';
import '/app/provider/alert_provider.dart';
import '/app/service/marker_icon_builder.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view/card_modal_view.dart';
import '/app/view/search_condition_view.dart';
import '/app/view_data/map_markers_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/domain/entity/map_coordinate_type.dart';
import '/domain/entity/result.dart';
import '/domain/entity/search_condition.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/infra/query_service_impl/distribution_cards_query_service_impl.dart';
import '/infra/query_service_impl/position_cards_query_service_impl.dart';
import '/infra/query_service_impl/search_condition_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/map_marker_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/query_service/distribution_cards_query_service.dart';
import '/use_case/query_service/position_cards_query_service.dart';
import '/use_case/query_service/search_condition_query_service.dart';
import '/use_case/use_case/analytics_use_case.dart';

final manholeCardMapViewModelProvider = ChangeNotifierProvider.family
    .autoDispose<ManholeCardMapViewModel, Key?>((ref, key) {
      return ManholeCardMapViewModel(
        key,
        ref,
        ref.watch(alreadyGetCardQueryServiceProvider),
        ref.watch(distributionCardsQueryServiceProvider),
        ref.watch(positionCardsQueryServiceProvider),
        ref.watch(searchConditionQueryServiceProvider),
        ref.watch(analyticsUseCaseProvider),
      );
    });

class ManholeCardMapViewModel extends ChangeNotifier {
  ManholeCardMapViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._distributionCardsQueryService,
    this._positionCardsQueryService,
    this._searchConditionQueryService,
    this._analyticsUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  final DistributionCardsQueryService _distributionCardsQueryService;
  final PositionCardsQueryService _positionCardsQueryService;
  final SearchConditionQueryService _searchConditionQueryService;

  final AnalyticsUseCase _analyticsUseCase;

  String get navigationTitle {
    switch (_coordinateType) {
      case MapCoordinateType.distribution:
        return '配布場所マップ';
      case MapCoordinateType.position:
        return '蓋マップ';
    }
  }

  /// 有効な絞り込みの数。検索ボタンのバッジ表示に使う。
  int get activeFilterCount => _searchCondition.activeFilterCount;

  GoogleMapController? mapController;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.0,
  );
  bool myLocationEnabled = false;
  MapMarkersViewData markersViewData = const MapMarkersViewData(list: []);

  /// マーカー生成の世代番号。生成中に新しい再読み込みが始まったら、古い世代の
  /// プログレッシブ通知・最終結果を破棄するために使う。
  int _markerGeneration = 0;

  SearchCondition _searchCondition = SearchCondition.initial();

  MapCoordinateType get _coordinateType => _searchCondition.map.coordinateType;

  List<MapMarkerDTO> get _currentMarkerDTOList =>
      _coordinateType == MapCoordinateType.position
          ? _positionMarkerDTOList
          : _distributionMarkerDTOList;

  /// 表示中のモーダル枚数。詳細画面の「マップで見る」では、旧モーダルを閉じてから
  /// 新モーダルを表示するが、閉じた通知（onCameBack）が新モーダル表示より後に届く。
  /// 単純な bool だと後から false で上書きされ、モーダルが出たままマップが全画面に
  /// 戻ってしまうため、枚数で管理する。
  int _showingModalCount = 0;
  bool get isShowModal => _showingModalCount > 0;

  /// マップ表示エリア（ナビゲーションエリアと下タブエリアの間）の高さ。View の
  /// レイアウト時に通知される。
  double _mapAreaHeight = 0.0;

  /// モーダルの高さ。マップ表示エリアの 2/3 を占め、残り 1/3 がマップとして見える。
  double get modalHeight => _mapAreaHeight * 2.0 / 3.0;

  final List<MapMarkerDTO> _positionMarkerDTOList = [];
  final List<MapMarkerDTO> _distributionMarkerDTOList = [];
  final List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];
  double _zoom = 12.0;
  LatLng _position = const LatLng(35.680212, 139.757669);
  StreamSubscription<List<AlreadyGetCardDTO>>? _alreadyGetCardStreamSubscription;
  StreamSubscription<SearchCondition>? _searchConditionStreamSubscription;

  Future<void> onLoad() async {
    // 枠 PNG のデコードを先行させ、最初のマーカー合成の待ちを減らす。
    // 初期化フローを塞がないよう await しない。
    unawaited(MarkerIconBuilder.preloadFrames());
    _ref.read(tabKeyStorageProvider).setMapKey(_key);
    _ref.read(tabKeyStorageProvider).setTabKey(0, _key);
    await onCameBack();
    await _loadSearchCondition();
    await _fetchMarker();
    await _listenAlreadyGetCard();
    await _listenSearchCondition();
  }

  /// 検索条件画面へ遷移する。
  Future<void> onTapSearchCondition() async {
    await _ref.read(routerProvider(_key).notifier).present(
          nextWidget: SearchConditionView(
            key: UniqueKey(),
          ),
        );
  }

  Future<void> setGoogleMapController(GoogleMapController controller) async {
    mapController = controller;
  }

  /// レイアウト中に呼ばれるため notifyListeners しない。
  void setMapAreaHeight(double height) {
    _mapAreaHeight = height;
  }

  Future<void> updateMyLocationEnabled() async {
    final permission = await Geolocator.checkPermission();
    myLocationEnabled =
        permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    notifyListeners();
    await _moveToCurrentLocation(false);
  }

  Future<void> onTapCurrentLocationButton() async {
    if (!myLocationEnabled) {
      _ref
          .read(alertProvider.notifier)
          .show(
            title: 'エラー',
            message: '位置情報を取得できません。設定を変更してください。',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    await _moveToCurrentLocation(false);
  }

  Future<void> onTapMarker(String markerId) async {
    final markerViewData = markersViewData.getByMarkerId(markerId);
    if (markerViewData == null) {
      _ref
          .read(alertProvider.notifier)
          .show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final position = LatLng(markerViewData.latitude, markerViewData.longitude);
    await Future.wait([
      _moveToLocation(position, true),
      _transitionToCardModalView(markerViewData.cardId, position),
      _showModal(),
    ]);
  }

  Future<void> onTapCheckWithMapButton(String cardId) async {
    final MapMarkerDTO? dto;
    if (_coordinateType == MapCoordinateType.position) {
      dto =
          _positionMarkerDTOList
              .where((element) => element.cardId == cardId)
              .firstOrNull;
    } else {
      dto =
          _distributionMarkerDTOList
              .where((element) => element.cardId == cardId)
              .firstOrNull;
    }
    if (dto == null) {
      _ref
          .read(alertProvider.notifier)
          .show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final position = LatLng(dto.latitude, dto.longitude);
    await Future.wait([
      _moveToLocation(position, false),
      _transitionToCardModalView(dto.cardId, position),
      _showModal(),
    ]);
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

  Future<void> sendPV() async {
    _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'manhole_card_map_view',
        'coordinate_type': _coordinateType.name,
        'active_filter_count': activeFilterCount,
      },
    );
  }

  Future<void> onCameBack() async {
    await _closeModal();
    final bottomTabKey = _ref.read(tabKeyStorageProvider).getBottomTabKey();
    final selectedIndex =
        _ref
            .read(bottomTabViewModelProvider(bottomTabKey).notifier)
            .selectedIndex;
    _ref.read(tabKeyStorageProvider).setTabKey(selectedIndex, _key);
    _ref.read(pvSendProvider.notifier).send();
  }

  Future<void> _loadSearchCondition() async {
    final result = await _searchConditionQueryService.get();
    if (result is Success<SearchCondition>) {
      _searchCondition = result.value;
    }
  }

  Future<void> _fetchMarker() async {
    if (_coordinateType == MapCoordinateType.position) {
      await _fetchPositionMarker();
    } else {
      await _fetchDistributionMarker();
    }
    await _reloadMarkerViewData();
  }

  Future<void> _fetchPositionMarker() async {
    if (_positionMarkerDTOList.isNotEmpty) {
      return;
    }
    final result = await _positionCardsQueryService.fetch();
    if (result is Failure) {
      _ref
          .read(alertProvider.notifier)
          .show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dtoList = (result as Success<List<MapMarkerDTO>>).value;
    _positionMarkerDTOList.clear();
    _positionMarkerDTOList.addAll(dtoList);
  }

  Future<void> _fetchDistributionMarker() async {
    if (_distributionMarkerDTOList.isNotEmpty) {
      return;
    }
    final result = await _distributionCardsQueryService.fetch();
    if (result is Failure) {
      _ref
          .read(alertProvider.notifier)
          .show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dtoList = (result as Success<List<MapMarkerDTO>>).value;
    _distributionMarkerDTOList.clear();
    _distributionMarkerDTOList.addAll(dtoList);
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardStreamSubscription = _alreadyGetCardQueryService
        .getStream()
        .listen((dtoList) async {
          final generation = ++_markerGeneration;
          final newViewData = await MapMarkersViewDataMapper.convertToViewData(
            mapMarkerDTOList: _currentMarkerDTOList,
            alreadyGetCardDTOList: dtoList,
            centerCoordinate: _position,
            searchCondition: _searchCondition.common,
            onPartial: (partial) {
              // 生成中に新しい再読み込みが始まっていたら古い結果は破棄する。
              if (generation != _markerGeneration) {
                return;
              }
              markersViewData = partial;
              notifyListeners();
            },
          );
          // 空結果でも最新世代なら反映する（近傍にマーカーが無い領域へ移動した
          // ときに古いマーカーを消すため）。
          if (generation == _markerGeneration) {
            markersViewData = newViewData;
            notifyListeners();
          }

          _alreadyGetCardDTOList.clear();
          _alreadyGetCardDTOList.addAll(dtoList);
        });
  }

  Future<void> _listenSearchCondition() async {
    _searchConditionStreamSubscription = _searchConditionQueryService
        .getStream()
        .listen((condition) async {
          _searchCondition = condition;
          // 座標種別が変わっていれば、対応するマーカーを遅延取得する。
          if (_coordinateType == MapCoordinateType.position) {
            await _fetchPositionMarker();
          } else {
            await _fetchDistributionMarker();
          }
          await _reloadMarkerViewData();
          // タイトル・フィルタバッジを更新する。
          notifyListeners();
        });
  }

  /// 最後にマーカー再生成した「座標種別 + 絞り込み条件 + 中心座標」。同じ状態での
  /// 重複再生成を防ぐ。
  String? _lastReloadKey;

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
      alreadyGetCardDTOList: _alreadyGetCardDTOList,
      centerCoordinate: _position,
      searchCondition: _searchCondition.common,
      onPartial: (partial) {
        // 生成中に新しい再読み込みが始まっていたら古い結果は破棄する。
        if (generation != _markerGeneration) {
          return;
        }
        markersViewData = partial;
        notifyListeners();
      },
    );
    // 空結果でも最新世代なら反映する（近傍にマーカーが無い領域へ移動したときに
    // 古いマーカーを消すため）。
    if (generation == _markerGeneration) {
      markersViewData = newViewData;
      notifyListeners();
    }
  }

  Future<void> _moveToCurrentLocation(bool animation) async {
    if (!myLocationEnabled) {
      return;
    }
    final position = await Geolocator.getCurrentPosition();
    await _moveToLocation(
      LatLng(position.latitude, position.longitude),
      animation,
    );
  }

  Future<void> _moveToLocation(LatLng latLng, bool animation) async {
    if (animation) {
      await mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: _zoom),
        ),
      );
    } else {
      await mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: _zoom),
        ),
      );
    }
    _position = latLng;
    await _reloadMarkerViewData();
  }

  Future<void> _showModal() async {
    _showingModalCount++;
    notifyListeners();
  }

  Future<void> _closeModal() async {
    if (_showingModalCount == 0) {
      return;
    }
    _showingModalCount--;
    notifyListeners();
  }

  Future<void> _transitionToCardModalView(
    String cardId,
    LatLng position,
  ) async {
    await _ref
        .read(routerProvider(_key).notifier)
        .presentModal(
          nextWidget: CardModalView(
            key: UniqueKey(),
            cardId: cardId,
            position: position,
            height: modalHeight,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('ManholeCardMapViewModel dispose');
    _alreadyGetCardStreamSubscription?.cancel();
    _searchConditionStreamSubscription?.cancel();
  }
}
