import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/app/view_data/modal_card_view_data.dart';
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
      distributionPlaceHtml: cardDTO.distributionPlaceHtml,
      stockHtml: cardDTO.stockHtml,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
