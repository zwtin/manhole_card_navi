import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/app/mapper/map_markers_view_data_mapper.dart';
import '/app/provider/alert_provider.dart';
import '/app/provider/pv_sender_provider.dart';
import '/app/provider/router_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view/card_modal_view.dart';
import '/app/view_data/map_markers_view_data.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/infra/query_service_impl/distribution_cards_query_service_impl.dart';
import '/infra/query_service_impl/position_cards_query_service_impl.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/map_marker_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/query_service/distribution_cards_query_service.dart';
import '/use_case/query_service/position_cards_query_service.dart';
import '/use_case/use_case/analytics_use_case.dart';

final manholeCardMapViewModelProvider = ChangeNotifierProvider.family
    .autoDispose<ManholeCardMapViewModel, Key?>((ref, key) {
      return ManholeCardMapViewModel(
        key,
        ref,
        ref.watch(alreadyGetCardQueryServiceProvider),
        ref.watch(distributionCardsQueryServiceProvider),
        ref.watch(positionCardsQueryServiceProvider),
        ref.watch(analyticsUseCaseProvider),
      );
    });

enum MapState { position, distribution }

class ManholeCardMapViewModel extends ChangeNotifier {
  ManholeCardMapViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._distributionCardsQueryService,
    this._positionCardsQueryService,
    this._analyticsUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  final DistributionCardsQueryService _distributionCardsQueryService;
  final PositionCardsQueryService _positionCardsQueryService;

  final AnalyticsUseCase _analyticsUseCase;

  String get navigationTitle {
    switch (mapState) {
      case MapState.distribution:
        return '配布場所マップ';
      case MapState.position:
        return '蓋マップ';
      default:
        return '';
    }
  }

  GoogleMapController? mapController;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.0,
  );
  bool myLocationEnabled = false;
  MapMarkersViewData markersViewData = const MapMarkersViewData(list: []);
  MapState mapState = MapState.distribution;
  bool isShowModal = false;
  final List<MapMarkerDTO> _positionMarkerDTOList = [];
  final List<MapMarkerDTO> _distributionMarkerDTOList = [];
  final List<AlreadyGetCardDTO> _alreadyGetCardDTOList = [];
  double _zoom = 12.0;
  LatLng _position = const LatLng(35.680212, 139.757669);
  late StreamSubscription<List<AlreadyGetCardDTO>>
  _alreadyGetCardStreamSubscription;

  Future<void> onLoad() async {
    _ref.read(tabKeyStorageProvider).setMapKey(_key);
    _ref.read(tabKeyStorageProvider).setTabKey(0, _key);
    await onCameBack();
    await _fetchMarker();
    await _listenAlreadyGetCard();
  }

  Future<void> onChangeMapState(MapState newMapState) async {
    mapState = newMapState;
    await _fetchMarker();
  }

  Future<void> setGoogleMapController(GoogleMapController controller) async {
    mapController = controller;
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
    if (mapState == MapState.position) {
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
        'map_state': mapState.name,
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

  Future<void> _fetchMarker() async {
    if (mapState == MapState.position) {
      await _fetchPositionMarker();
    } else if (mapState == MapState.distribution) {
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
          final newViewData = await MapMarkersViewDataMapper.convertToViewData(
            mapMarkerDTOList:
                mapState == MapState.position
                    ? _positionMarkerDTOList
                    : _distributionMarkerDTOList,
            alreadyGetCardDTOList: dtoList,
            centerCoordinate: _position,
          );
          if (!newViewData.isEmpty) {
            markersViewData = newViewData;
            notifyListeners();
          }

          _alreadyGetCardDTOList.clear();
          _alreadyGetCardDTOList.addAll(dtoList);
        });
  }

  Future<void> _reloadMarkerViewData() async {
    final newViewData = await MapMarkersViewDataMapper.convertToViewData(
      mapMarkerDTOList:
          mapState == MapState.position
              ? _positionMarkerDTOList
              : _distributionMarkerDTOList,
      alreadyGetCardDTOList: _alreadyGetCardDTOList,
      centerCoordinate: _position,
    );
    if (!newViewData.isEmpty) {
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
    isShowModal = true;
    notifyListeners();
  }

  Future<void> _closeModal() async {
    isShowModal = false;
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
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('ManholeCardMapViewModel dispose');
    _alreadyGetCardStreamSubscription.cancel();
  }
}
