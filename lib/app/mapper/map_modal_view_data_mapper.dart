import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/app/view_data/map_modal_view_data.dart';
import '/use_case/dto/card_dto.dart';

class MapModalViewDataMapper {
  static Future<MapModalViewData> convertToViewData({
    required CardDTO cardDTO,
    required LatLng latLng,
  }) async {
    return MapModalViewData(
      id: cardDTO.id,
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }
}
