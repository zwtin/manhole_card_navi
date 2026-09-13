import 'package:freezed_annotation/freezed_annotation.dart';

import 'modal_card_view_data.dart';

part 'card_modal_view_data.freezed.dart';

@freezed
abstract class CardModalViewData with _$CardModalViewData {
  const factory CardModalViewData({
    required ModalCardViewData card,
    required bool alreadyGet,
  }) = _CardModalViewData;
  const CardModalViewData._();

  String get alreadyGetActionButtonTitle =>
      alreadyGet ? '未取得に戻す' : '取得済みにする';
}
