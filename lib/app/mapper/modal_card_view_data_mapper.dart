import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/app/view_data/modal_card_view_data.dart';
import '/app/view_data/modal_contact_view_data.dart';
import '/use_case/dto/card_dto.dart';

class ModalCardViewDataMapper {
  static Future<ModalCardViewData> convertToViewData({
    required CardDTO cardDTO,
    required LatLng position,
  }) async {
    final map = <String, dynamic>{};
    map['cardDTO'] = cardDTO;
    map['position'] = position;
    return compute(_convert, map);
  }

  static Future<ModalCardViewData> _convert(
    Map<String, dynamic> parameter,
  ) async {
    final cardDTO = parameter['cardDTO'] as CardDTO;
    final position = parameter['position'] as LatLng;
    return ModalCardViewData(
      id: cardDTO.id,
      name: cardDTO.name,
      contacts: cardDTO.contacts.map(
        (dto) {
          return ModalContactViewData(
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
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
