import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/app/view_data/map_modal_card_view_data.dart';
import '/app/view_data/map_modal_contact_view_data.dart';
import '/use_case/dto/card_dto.dart';

class MapModalViewDataMapper {
  static Future<MapModalCardViewData> convertToViewData({
    required CardDTO cardDTO,
    required LatLng latLng,
  }) async {
    return MapModalCardViewData(
      id: cardDTO.id,
      name: cardDTO.name,
      contacts: cardDTO.contacts.map(
        (dto) {
          return MapModalContactViewData(
            id: dto.id,
            name: dto.name,
            nameUrl: dto.nameUrl,
          );
        },
      ).toList(),
      distributionLinkText: cardDTO.distributionLinkText,
      distributionLinkUrl: cardDTO.distributionLinkUrl,
      distributionText: cardDTO.distributionText,
      distributionOther: cardDTO.distributionOther,
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }
}
