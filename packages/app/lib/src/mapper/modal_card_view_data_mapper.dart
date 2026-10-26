import 'package:app/src/view_data/modal_card_view_data.dart';
import 'package:domain/domain.dart';

abstract final class ModalCardViewDataMapper {
  /// [position] はモーダルを開いたピンの座標。地図アプリで開く場所になる。
  static ModalCardViewData toViewData({
    required ManholeCard card,
    required Coordinate position,
  }) {
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
