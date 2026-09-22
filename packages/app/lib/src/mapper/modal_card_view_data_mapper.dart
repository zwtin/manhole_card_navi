import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../view_data/modal_card_view_data.dart';

class ModalCardViewDataMapper {
  static Future<ModalCardViewData> convertToViewData({
    required ManholeCard card,
    required LatLng position,
  }) async {
    final map = <String, dynamic>{};
    map['card'] = card;
    map['position'] = position;
    return compute(_convert, map);
  }

  static Future<ModalCardViewData> _convert(
    Map<String, dynamic> parameter,
  ) async {
    final card = parameter['card'] as ManholeCard;
    final position = parameter['position'] as LatLng;
    return ModalCardViewData(
      id: card.id,
      name: card.name,
      distributionPlaceHtml: card.distributionPlaceHtml,
      stockHtml: card.stockHtml,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
