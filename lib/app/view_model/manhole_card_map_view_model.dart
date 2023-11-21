import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

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
      ref.watch(cardUseCaseProvider),
    );
  },
);

class ManholeCardMapViewModel extends ChangeNotifier {
  ManholeCardMapViewModel(
    this._key,
    this._ref,
    this._alreadyGetCardQueryService,
    this._distributionCardsQueryService,
    this._cardUseCase,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  final DistributionCardsQueryService _distributionCardsQueryService;

  final CardUseCase _cardUseCase;

  late GoogleMapController mapController;
  CameraPosition currentCameraPosition = const CameraPosition(
    target: LatLng(35.680212, 139.757669),
    zoom: 12.5,
  );
  bool myLocationEnabled = false;
  MapMarkersViewData markersViewData = const MapMarkersViewData(list: []);

  bool isShowModal = false;

  final List<MapCardDTO> _cardList = [];

  Future<void> onLoad() async {
    _logger.d('ManholeCardMapViewModel');
    _ref.read(tabKeyStorageProvider).setTabKey(0, _key);
    _ref.read(locationPermissionProvider.notifier).request();
    await fetchDistributionMarker();
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

  Future<void> fetchDistributionMarker() async {
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
  }

  Future<void> _listenAlreadyGetCard() async {
    _alreadyGetCardQueryService.getStream().listen((dto) async {
      markersViewData = await MapMarkersViewDataMapper.convertToViewData(
        cardDTOList: _cardList,
        getDTOList: dto,
      );
      notifyListeners();
    });
  }

  Future<void> onTapMarker(String markerId) async {
    final markerViewData = markersViewData.get(markerId);
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
    await showMarkerModal(markerViewData.cardId);
  }

  Future<void> showMarkerModal(String cardId) async {
    final result = await _cardUseCase.get(id: cardId);
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
    isShowModal = true;
    // モーダルViewDataを取得する処理を実装
    final viewData = MapModalViewData(
      id: dto.id,
      latitude: dto.latitude,
      longitude: dto.longitude,
    );
    notifyListeners();
    _ref.read(mapModalProvider.notifier).present(
          viewData: viewData,
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
