import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/view_data/map_marker_view_data.dart';
import 'package:manhole_card_navi/infra/query_service_impl/position_cards_query_service_impl.dart';
import 'package:manhole_card_navi/use_case/dto/already_get_card_dto.dart';
import 'package:manhole_card_navi/use_case/query_service/position_cards_query_service.dart';

import '/app/mapper/map_markers_view_data_mapper.dart';
import '/app/provider/alert_provider.dart';
import '/app/provider/location_permission_provider.dart';
import '/app/provider/map_modal_provider.dart';
import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_data/map_markers_view_data.dart';
import '/app/view_data/map_modal_view_data.dart';
import '/domain/entity/result.dart';
import '/infra/query_service_impl/already_get_card_query_service_impl.dart';
import '/infra/query_service_impl/distribution_cards_query_service_impl.dart';
import '/use_case/dto/card_dto.dart';
import '/use_case/dto/map_card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';
import '/use_case/query_service/distribution_cards_query_service.dart';
import '/use_case/use_case/card_use_case.dart';

final manholeCardMapViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<ManholeCardMapViewModel, Key?>(
  (ref, key) {
    return ManholeCardMapViewModel(
      key,
      ref,
      ref.watch(alreadyGetCardQueryServiceProvider),
      ref.watch(distributionCardsQueryServiceProvider),
      ref.watch(positionCardsQueryServiceProvider),
      ref.watch(cardUseCaseProvider),
    );
  },
);

enum MapMarkerState {
  position,
  distribution,
}

class ManholeCardMapViewModel extends ChangeNotifier {
  ManholeCardMapViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._distributionCardsQueryService,
    this._positionCardsQueryService,
    this._cardUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  final DistributionCardsQueryService _distributionCardsQueryService;
  final PositionCardsQueryService _positionCardsQueryService;

  final CardUseCase _cardUseCase;

  late GoogleMapController mapController;
  CameraPosition currentCameraPosition = const CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.5,
  );
  bool myLocationEnabled = false;
  MapMarkersViewData markersViewData = const MapMarkersViewData(list: []);

  MapMarkerState markerState = MapMarkerState.position;
  bool isShowModal = false;

  final List<MapCardDTO> _cardList = [];
  final List<AlreadyGetCardDTO> _alreadyGetList = [];

  Future<void> onLoad() async {
    _logger.d('ManholeCardMapViewModel');
    _ref.read(tabKeyStorageProvider).setTabKey(0, _key);
    _ref.read(locationPermissionProvider.notifier).request();
    await _fetchMarker();
    await _listenAlreadyGetCard();
  }

  Future<void> onTap() async {
    _logger.d('ManholeCardMapViewModel');
  }

  Future<void> setupMyLocation() async {
    var permission = await Geolocator.checkPermission();
    myLocationEnabled = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    await _moveToCurrentLocation(false);
    notifyListeners();
  }

  Future<void> setGoogleMapController(GoogleMapController controller) async {
    mapController = controller;
  }

  Future<void> onTapCurrentLocationButton() async {
    await _moveToCurrentLocation(true);
  }

  Future<void> _moveToCurrentLocation(bool animation) async {
    if (!myLocationEnabled) {
      return;
    }
    final position = await Geolocator.getCurrentPosition();
    if (animation) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: 12.5,
          ),
        ),
      );
    } else {
      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: 12.5,
          ),
        ),
      );
    }
  }

  Future<void> onChangeMarkerState(MapMarkerState state) async {
    markerState = state;
    await _fetchMarker();
  }

  Future<void> _fetchMarker() async {
    if (markerState == MapMarkerState.position) {
      await _fetchPositionMarker();
    } else if (markerState == MapMarkerState.distribution) {
      await _fetchDistributionMarker();
    }
  }

  Future<void> _fetchPositionMarker() async {
    final result = await _positionCardsQueryService.fetch();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dtoList = (result as Success<List<MapCardDTO>>).value;
    _cardList.clear();
    _cardList.addAll(dtoList);
    await _resetMarkersViewData();
  }

  Future<void> _fetchDistributionMarker() async {
    final result = await _distributionCardsQueryService.fetch();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dtoList = (result as Success<List<MapCardDTO>>).value;
    _cardList.clear();
    _cardList.addAll(dtoList);
    await _resetMarkersViewData();
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardQueryService.getStream().listen((dto) async {
      _alreadyGetList.clear();
      _alreadyGetList.addAll(dto);
      await _resetMarkersViewData();
    });
  }

  Future<void> _resetMarkersViewData() async {
    markersViewData = await MapMarkersViewDataMapper.convertToViewData(
      cardDTOList: _cardList,
      getDTOList: _alreadyGetList,
    );
    notifyListeners();
  }

  Future<void> onTapMarker(String markerId) async {
    final markerViewData = markersViewData.getByMarkerId(markerId);
    if (markerViewData == null) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    await _showMarkerModal(markerViewData);
  }

  Future<void> onTapShowMarkerModalButton(String cardId) async {
    final markerViewData = markersViewData.getByCardId(cardId);
    if (markerViewData == null) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    await _showMarkerModal(markerViewData);
  }

  Future<void> _showMarkerModal(MapMarkerViewData viewData) async {
    final result = await _cardUseCase.get(id: viewData.cardId);
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dto = (result as Success<CardDTO>).value;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            viewData.latitude,
            viewData.longitude,
          ),
          zoom: 12.5,
        ),
      ),
    );
    isShowModal = true;
    // モーダルViewDataを取得する処理を実装
    final modalViewData = MapModalViewData(
      id: dto.id,
      latitude: viewData.latitude,
      longitude: viewData.longitude,
    );
    notifyListeners();
    _ref.read(mapModalProvider.notifier).present(
          viewData: modalViewData,
        );
  }

  Future<void> onCloseMarkerModal() async {
    isShowModal = false;
    _ref.read(mapModalProvider.notifier).dismiss();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('ManholeCardMapViewModel dispose');
  }
}
